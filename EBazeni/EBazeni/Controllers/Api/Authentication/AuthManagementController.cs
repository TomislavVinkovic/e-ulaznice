using EBazeni.Configuration;
using EBazeni.Data;
using EBazeni.Models;
using EBazeni.Models.DTOs.Requests;
using EBazeni.Models.DTOs.Responses;
using EBazeni.Utilities.EmailTemplate;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Identity;
using Microsoft.AspNetCore.Identity.UI.Services;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.WebUtilities;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.Options;
using Microsoft.IdentityModel.Tokens;
using System;
using System.Collections.Generic;
using System.IdentityModel.Tokens.Jwt;
using System.Linq;
using System.Security.Claims;
using System.Security.Policy;
using System.Text;
using System.Threading.Tasks;

namespace EBazeni.Controllers.Api.Authentication {
    [Route("api/[controller]")]
    [ApiController]
    public class AuthManagementController : ControllerBase {

        private readonly UserManager<ApplicationUser> _userManager;
        private readonly IEmailSender _emailSender;
        private readonly JWTConfig _jWTConfig;
        private readonly TokenValidationParameters _tokenValidationParams;
        private readonly ApplicationDbContext _db;
        private readonly IConfiguration _config;
        private readonly IEmailTemplateConfig _emailTemplateConfig;

        public AuthManagementController(
            UserManager<ApplicationUser> userManager,
            IOptionsMonitor<JWTConfig> jWTConfig, //ovo mi treba kako bih inheritovao defaultne verzije jwt konfiguracije iz startup klase
            TokenValidationParameters tokenValidationParams,
            ApplicationDbContext db,
            RoleManager<IdentityRole> roleManager,
            IConfiguration config,
            IEmailSender emailSender,
            IEmailTemplateConfig emailTemplateConfig
            ) {
            _userManager = userManager;
            _jWTConfig = jWTConfig.CurrentValue;
            _tokenValidationParams = tokenValidationParams;
            _db = db;
            _config = config;
            _emailSender = emailSender;
            _emailTemplateConfig = emailTemplateConfig;
        }

        [HttpPost]
        [Route("Register")]
        public async Task<IActionResult> Register([FromBody] UserRegistrationDTO user) {
            try {
                if (ModelState.IsValid) {
                    //everything checks out

                    var existingUserByEmail = await _userManager.FindByEmailAsync(user.Email);
                    var existingUserByUserName = await _userManager.FindByNameAsync(user.UserName);

                    //korisnik s tom mail adresom ili korisnickim imenom postoji
                    if (existingUserByEmail != null || existingUserByUserName != null) {
                        //user cannot register
                        return BadRequest(new RegistrationResponse() {
                            Errors = new List<string>() {
                            "Korisničko ime ili E-mail adresa već u uporabi"
                        },
                            Success = false
                        });
                    }

                    var newUser = new ApplicationUser() {
                        UserName = user.UserName,
                        Email = user.Email,
                        OIB = user.OIB,
                        Ime = user.Ime,
                        Prezime = user.Prezime,
                        DatumRodenja = DateTime.ParseExact(user.DatumRodenja, "MM-dd-yyyy", null).Date.ToUniversalTime(),
                        Prebivaliste = user.Prebivaliste,
                        Boraviste = user.Boraviste
                    };

                    var isCreated = await _userManager.CreateAsync(newUser, user.Password);
                    if (isCreated.Succeeded) {
                        //korisnik je uspjesno kreiran, vracamo JWT token
                        await _userManager.AddToRoleAsync(newUser, WC.KupacRole);
                        //var jwtToken = await GenerateJwtToken(newUser);
                        //vraca token i refreshtoken

                        var code = await _userManager.GenerateEmailConfirmationTokenAsync(newUser);
                        code = WebEncoders.Base64UrlEncode(Encoding.UTF8.GetBytes(code));



                        var callBackUri = $"https://85c7-141-138-31-195.ngrok.io/api/authmanagement/confirmemail?code={code}&userid={newUser.Id}";

                        var htmlMessage = _emailTemplateConfig.GetAndFormatHtmlString("emailTemplate.html", newUser.Ime, newUser.Prezime, callBackUri);

                        await _emailSender.SendEmailAsync(newUser.Email, "Molimo potvrdite vašu E-mail adresu", htmlMessage);

                        //return Ok(jwtToken);
                        return Ok();
                    }
                    //korisnik iz nekog razloga nije mogao biti kreiran
                    else {
                        return BadRequest(new RegistrationResponse() {
                            Errors = isCreated.Errors.Select(x => x.Description).ToList(),
                            Success = false
                        }); ;
                    }

                }

                else {
                    return BadRequest(new RegistrationResponse() {
                            Errors = new List<string>() {
                                "Unešeni podaci nisu ispravni. Molimo provjerite formu još jednom!"
                            },
                            Success = false
                    }); ;
                }
            }
            catch (Exception) {

                return BadRequest(new RegistrationResponse() {
                    Errors = new List<string>() {
                    "Dogodila se greška pri vašem zahtjevu. Molimo, obratite se korisničkoj podršci"
                },
                    Success = false
                });
            }
            
        }

        [HttpPost]
        [Route("Login")]
        public async Task<IActionResult> Login([FromBody] UserLoginRequest user) {
            if (ModelState.IsValid) {
                var existingUser = await _userManager.FindByNameAsync(user.UserName);
                if (existingUser == null) {
                    return BadRequest(new RegistrationResponse() {
                        Errors = new List<string>() {
                            "Korisnik s ovim korisničkim imenom nije registriran"
                        },
                        Success = false
                    });
                }

                //is the password correct
                bool isCorrectPassword = await _userManager.CheckPasswordAsync(existingUser, user.Password);
                if (!isCorrectPassword) {
                    return BadRequest(new RegistrationResponse() {
                        Errors = new List<string>() {
                            "Pogrešno korisničko ime ili lozinka"
                        },
                        Success = false
                    });
                }

                if (!existingUser.EmailConfirmed){
                    return BadRequest(new RegistrationResponse() {
                        Errors = new List<string>() {
                            "Niste potvrdili svoju E-mail adresu. Ne možete se prijaviti ukoliko je ne potvrdite"
                        },
                        Success = false
                    });
                }

                var jwtToken = await GenerateJwtToken(existingUser);
                return Ok(jwtToken);
            }
            else {
                return BadRequest(new RegistrationResponse() {
                    Errors = new List<string>() {
                        "Dogodila se greška pri vašem zahtjevu. Molimo, obratite se korisničkoj podršci"
                    },
                    Success = false
                });
            }
        }

        [HttpGet]
        [Route("ConfirmEmail")]
        public async Task<IActionResult> ConfirmEmail(string code, string userid) {
            if (userid == null || code == null) {
                return BadRequest(new RegistrationResponse() {
                    Errors = new List<string>() {
                        "Poveznica nije valjana"
                    },
                    Success = false
                });
            }

            var user = await _userManager.FindByIdAsync(userid);
            if (user == null) {
                return BadRequest(new RegistrationResponse() {
                    Errors = new List<string>() {
                        "Korisnik nije pronađen"
                    },
                    Success = false
                });
            };

            var codeString = Encoding.UTF8.GetString(WebEncoders.Base64UrlDecode(code));
            var result = await _userManager.ConfirmEmailAsync(user, codeString);

            if (result.Succeeded) {
                var StatusMessage = "E-mail adresa uspješno potvrđena. Sad se možete prijaviti u aplikaciju";

                await GenerateJwtToken(user);

                return Ok($"{StatusMessage}");
            }

            else {
                var StatusMessage = "Nismo mogli potvrditi vašu E-mail adresu";
                return Ok($"{StatusMessage}");
            }
            

        }

        [HttpPost]
        [Route("RefreshToken")]
        public async Task<IActionResult> RefreshToken([FromBody] TokenRequest tokenRequest) {
            if (ModelState.IsValid) {
                var result = await VerifyAndGenerateToken(tokenRequest);

                if (result == null) {
                    return BadRequest(new RegistrationResponse() {
                    Errors = new List<string>(){
                        "Problem s autentikacijom tokena",
                        
                    },
                        Success = false
                    });
                }

                return Ok(result);
            }
            return BadRequest(new RegistrationResponse() {
                Errors = new List<string> (){
                    "Pogrešan zahtjev"
                },
                Success = false
            });
        }


        private async Task<AuthResult> GenerateJwtToken(ApplicationUser user) {
            var jwtTokenHandler = new JwtSecurityTokenHandler();

            var key = Encoding.ASCII.GetBytes(_jWTConfig.Secret);

            var tokenDescriptor = new SecurityTokenDescriptor {
                Subject = new ClaimsIdentity(new[] {
                    new Claim("Id", user.Id),
                    new Claim(JwtRegisteredClaimNames.Email, user.Email),//predefinirana imena claimova ugrađena u JWT klasu
                    new Claim(JwtRegisteredClaimNames.Sub, user.Email),
                    //jedinstveni ID koji jwt koristi kako bi kreirao novi oken kad je stari istekao
                    new Claim(JwtRegisteredClaimNames.Jti, Guid.NewGuid().ToString())
                }),
                //zbog potrebe demo-a, uglavnom JWT tokeni traju 5-10 minuta u production aplikacijama
                Expires = DateTime.UtcNow.AddSeconds(30),
                //koju metodu koristimo za digitalno potpisivanje novih tokena
                SigningCredentials = new SigningCredentials(new SymmetricSecurityKey(key), SecurityAlgorithms.HmacSha256)
            };

            var token = jwtTokenHandler.CreateToken(tokenDescriptor);

            //serijalizira token u prijenosni format
            var jwtToken = jwtTokenHandler.WriteToken(token);


            var tokenFromDb = await _db.RefreshTokens.FirstOrDefaultAsync(
                o => o.ApplicationUser == user &&
                o.ExipryDate > DateTime.UtcNow &&
                o.IsRevoked == false &&
                o.IsUsed == false
            );

            if (tokenFromDb == null) {
                var refreshToken = new RefreshToken() {
                    //Id dolazi iz jwt token handlera
                    JwtId = token.Id,
                    IsUsed = false,
                    IsRevoked = false,
                    ApplicationUserId = user.Id,
                    AddedDate = DateTime.UtcNow,
                    ExipryDate = DateTime.UtcNow.AddMonths(6),
                    Token = RandomString(35) + Guid.NewGuid()
                };

                await _db.RefreshTokens.AddAsync(refreshToken);
                await _db.SaveChangesAsync();

                var roles = await _userManager.GetRolesAsync(user);
                var role = roles.ElementAt(0); //gets the user role

                return new AuthResult() {
                    Token = jwtToken,
                    Success = true,
                    RefreshToken = refreshToken.Token,
                    User = user,
                    Role = role

                };
            }
            else {
                tokenFromDb.JwtId = token.Id;
                await _db.SaveChangesAsync();
                var refreshToken = tokenFromDb;

                var roles = await _userManager.GetRolesAsync(user);
                var role = roles.ElementAt(0); //gets the user role


                return new AuthResult() {
                    Token = jwtToken,
                    Success = true,
                    RefreshToken = refreshToken.Token,
                    User = user,
                    Role = role
                };
            }
            
        }

        private async Task<AuthResult> VerifyAndGenerateToken(TokenRequest tokenRequest) {
            var jwtTokenHandler = new JwtSecurityTokenHandler();

            var key = Encoding.ASCII.GetBytes(_config["JwtConfig:Secret"]); //klasa jwt config, prop secret
            var refreshTokenValidationParams = new TokenValidationParameters() {
                ValidateIssuerSigningKey = true,
                IssuerSigningKey = new SymmetricSecurityKey(key),
                ValidateIssuer = false,
                ValidateAudience = false,
                ValidateLifetime = false,
                RequireExpirationTime = false,
                ClockSkew = TimeSpan.FromSeconds(10),
            };

            try {
                //Validation 1
                var tokenInVerification = jwtTokenHandler.ValidateToken(tokenRequest.Token, refreshTokenValidationParams, out var validatedToken);

                //Validation 2
                if (validatedToken is JwtSecurityToken jwtSecurityToken) {
                    //je li algoritam kojim je token potpisan jednak onome koji je u headeru
                    var result = jwtSecurityToken.Header.Alg.Equals(SecurityAlgorithms.HmacSha256, StringComparison.InvariantCultureIgnoreCase);

                    if (result == false) {
                        return null;
                    }
                }

                //Validation 3
                //broj sekundi koji je prosao od 1.1.1970(tako je spremljen datum u bazu)
                var utcExpiryDate = long.Parse(tokenInVerification.Claims.FirstOrDefault(o => o.Type == JwtRegisteredClaimNames.Exp).Value);

                //pretvaranje offseta u sekundama u datum koji mozemo iskoristiti
                var expiryDate = UnixTimeStampToDateTime(utcExpiryDate);

                if (expiryDate > DateTime.UtcNow) {
                    //token has not yet expired, so the user does not need a new one
                    return new AuthResult() {
                        Success = false,
                        Errors = new List<string>() {
                            "Token nije još istekao"
                        }
                    };

                }

                //Validation 4
                //Does the token exist?
                var storedToken = await _db.RefreshTokens.FirstOrDefaultAsync(
                    x => x.Token == tokenRequest.RefreshToken);

                if (storedToken == null) {
                    return new AuthResult() {
                        Success = false,
                        Errors = new List<string>() {
                            "Token ne postoji"
                        }
                    };
                }

                //Validation 5
                //has this refresh token expired? It is marked as used if it has expired
                if (storedToken.ExipryDate <= DateTime.UtcNow) {
                    storedToken.IsUsed = true;
                    await _db.SaveChangesAsync();
                    return new AuthResult() {
                        Success = false,
                        Errors = new List<string>() {
                            "Token je istekao, molimo oponovno se prijavite"
                        },
                        RefreshTokenExpired = true
                    };
                }

                //Validation 6
                if (storedToken.IsRevoked || storedToken.IsUsed) {
                    return new AuthResult() {
                        Success = false,
                        Errors = new List<string>() {
                            "Token je poništen ili nije valjan"
                        },

                    };
                }

                var jti = tokenInVerification.Claims.FirstOrDefault(x => x.Type == JwtRegisteredClaimNames.Jti).Value;

                //Validation 7
                //Is the refresh token used for the jwt used in the request
                if (storedToken.JwtId != jti) {
                    return new AuthResult() {
                        Success = false,
                        Errors = new List<string>() {
                            "Dani tokeni nisu upareni"
                        }
                    };
                }

                var userFromDb = await _userManager.FindByIdAsync(storedToken.ApplicationUserId);
                return await GenerateJwtToken(userFromDb);
            }
            catch (Exception) {

                return null;
            }
        }

        private string RandomString(int length) {
            var random = new Random();
            var chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789";
            return new string(Enumerable.Repeat(chars, length)
                .Select(x => x[random.Next(x.Length)]).ToArray());
        }

        private DateTime UnixTimeStampToDateTime(long unixTimeStamp) {
            var dateTimeVal = new DateTime(1970, 1, 1, 0, 0, 0, 0, System.DateTimeKind.Utc);
            dateTimeVal = dateTimeVal.AddSeconds(unixTimeStamp).ToUniversalTime();

            return dateTimeVal;
        }

    }
                
}
        

    
