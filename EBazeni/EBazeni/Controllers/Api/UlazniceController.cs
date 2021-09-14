using EBazeni.Data;
using EBazeni.Data.Repositories;
using EBazeni.Models;
using EBazeni.Models.DTOs.Requests;
using EBazeni.Models.DTOs.Responses;
using Microsoft.AspNetCore.Authentication.JwtBearer;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Identity;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace EBazeni.Controllers.Api {
    [Route("api/[controller]")]
    [Authorize(AuthenticationSchemes = JwtBearerDefaults.AuthenticationScheme)]
    [ApiController]
    public class UlazniceController : ControllerBase {

        private readonly IUlaznicaRepository _ulaznicaRepository;
        private readonly IZahtjevRepository _zahtjevRepository;
        private readonly UserManager<ApplicationUser> _userManager;
        private readonly ApplicationDbContext _db;

        public UlazniceController(IUlaznicaRepository ulaznicaRepository, IZahtjevRepository zahtjevRepository, UserManager<ApplicationUser> userManager, ApplicationDbContext db) {
            _ulaznicaRepository = ulaznicaRepository;
            _zahtjevRepository = zahtjevRepository;
            _userManager = userManager;
            _db = db;
        }

        [HttpGet("{userId:Guid}")]
        public async Task<IActionResult> GetUlaznicaByUserId(Guid userId) {
            try {
                var korisnikUsesUlaznica = await _ulaznicaRepository.GetUlaznicaByUserId(userId);
                var count = _db.KorisnikUsesUlaznica.Where(o => o.Ulaznica.BrojUlaznice == korisnikUsesUlaznica.Ulaznica.BrojUlaznice).Count();
                if (korisnikUsesUlaznica == null) return NotFound();
                Ulaznica ulaznicaWithForeignProperties = await _db.Ulaznice.Include(o => o.TipUlaznice).FirstOrDefaultAsync(o => o.BrojUlaznice == korisnikUsesUlaznica.Ulaznica.BrojUlaznice);
                var ulaznicaResponse = new UlaznicaResponse() {
                    KorisnikUsesUlaznica = korisnikUsesUlaznica,
                    UlaznicaWithProperties = ulaznicaWithForeignProperties,
                    KorisniciUlaznice = count,
                };

                return Ok(ulaznicaResponse);
            }
            catch (Exception) {

                return BadRequest();
            }

        }



        [HttpPost]
        [Route("AddKorisnikToUlaznica")]
        public async Task<IActionResult> AddKorisnikToUlaznica(Guid brojulaznice, Guid userid) {
            try {
                var korisnikUsesUlaznica = await _ulaznicaRepository.GetUlaznicaByBrojUlaznice(brojulaznice);
                var user = await _userManager.FindByIdAsync(userid.ToString());
                if (korisnikUsesUlaznica != null) {
                    Ulaznica ulaznicaWithForeignProperties = await _db.Ulaznice.Include(o => o.TipUlaznice).FirstOrDefaultAsync(o => o.BrojUlaznice == korisnikUsesUlaznica.Ulaznica.BrojUlaznice);
                    if (ulaznicaWithForeignProperties.TipUlaznice.Ime == "Dijete do 15 godina" || ulaznicaWithForeignProperties.TipUlaznice.Ime == "Odrasla osoba + dijete") { 
                        if(DateTime.UtcNow.Date.Subtract(user.DatumRodenja).TotalDays > DateTime.UtcNow.Date.Subtract(new DateTime(year: DateTime.Now.ToUniversalTime().Year - 15, month: DateTime.Now.ToUniversalTime().Month, day: DateTime.Now.ToUniversalTime().Day)).TotalDays) {
                            return BadRequest("Ne možete koristiti ovu ulaznicu jer je namijenjena za roditelja i dijete, a vi ste punoljetni");
                        }
                    }
                    int brojKorisnika = _db.KorisnikUsesUlaznica.Where(o => o.Ulaznica == korisnikUsesUlaznica.Ulaznica).Count();
                    int maksimalanBrojKorisnika = ulaznicaWithForeignProperties.TipUlaznice.MaksimalanBrojKorisnika;
                    if (brojKorisnika < maksimalanBrojKorisnika) {
                        var newKorisnikUsesUlaznica = new KorisnikUsesUlaznica() {
                            ApplicationUser = user,
                            Ulaznica = korisnikUsesUlaznica.Ulaznica
                        };
                        await _db.KorisnikUsesUlaznica.AddAsync(newKorisnikUsesUlaznica);
                        await _db.SaveChangesAsync();
                        return Ok(new UlaznicaResponse() {
                            KorisnikUsesUlaznica = newKorisnikUsesUlaznica,
                            UlaznicaWithProperties = ulaznicaWithForeignProperties,
                            KorisniciUlaznice = brojKorisnika - 1
                        });
                    }
                    else return BadRequest();

                }
                else return NotFound();
            }
            catch (Exception) {
                return BadRequest();
            }
        }

        //broj ulaznice odnosi se na kljuc relacijske tablice korisnikusesulaznica

        [HttpPost]
        [Route("OvjeraUlaznice")]
        public async Task<IActionResult> OvjeriUlaznicu(Guid brojulaznice) {
            var korisnikUsesUlaznica = _db.KorisnikUsesUlaznica.FirstOrDefault(o => o.Key == brojulaznice);
            try {
                var ovjeraUlazniceResponse = await _ulaznicaRepository.OvjeriUlaznicu(brojUlaznice: brojulaznice);
                if (!ovjeraUlazniceResponse.AlreadyVisited) {
                    await _db.Visits.AddAsync(new Visit() {
                        KorisnikUsesUlaznica = korisnikUsesUlaznica,
                        DateOfEntry = DateTime.UtcNow.Date
                    });
                    await _db.SaveChangesAsync();
                }
                return Ok(ovjeraUlazniceResponse);
            }
            catch (Exception) {
                return StatusCode(500);
            }
            
        }

        [HttpPost]
        [Route("KreirajUlaznicu")]
        public async Task<IActionResult> KreirajUlaznicu([FromBody]KreacijaUlazniceRequest kreacijaUlazniceRequest) {
            try {
                var zahtjev = await _zahtjevRepository.GetZahtjevById(Convert.ToInt32(kreacijaUlazniceRequest.ZahtjevId));

                if (zahtjev == null) {
                    return NotFound(new KreacijaUlazniceResponse() { 
                        IsSuccessful = false,
                        Errors = new List<string>() { 
                            "Broj ulaznice nije pronađen"
                        }
                    });
                }

                

                var ulaznica = new Ulaznica() { 
                    TipUlaznice = zahtjev.TipUlazniceForZahtjev,
                    BrojUlaznice = Guid.NewGuid(),
                    EndDate = DateTime.ParseExact(kreacijaUlazniceRequest.EndDate, "MM-dd-yyyy", null).Date.ToUniversalTime(),
                };

                await _db.Ulaznice.AddAsync(ulaznica);
                await _db.SaveChangesAsync();

                var korisnikUsesUlaznica = new KorisnikUsesUlaznica() { 
                    Key = Guid.NewGuid(),
                    Ulaznica = ulaznica,
                    ApplicationUser = zahtjev.ApplicationUserForZahtjev
                };

                await _db.KorisnikUsesUlaznica.AddAsync(korisnikUsesUlaznica);
                await _db.SaveChangesAsync();

                await _zahtjevRepository.DeleteZahtjev(zahtjev.Id);

                return Ok(new KreacijaUlazniceResponse() { 
                    IsSuccessful = true
                });
            }
            catch (Exception) {
                throw;
            }
        }

        [HttpPost]
        [Route("PonistiPosjet")]
        public async Task<IActionResult> PonistiPosjet(Guid brojulaznice) {
            try {
                var korisnikUsesUlaznica = _db.KorisnikUsesUlaznica.FirstOrDefault(o => o.Key == brojulaznice);
                var ovjeraUlaznice = await _ulaznicaRepository.OvjeriUlaznicu(brojulaznice);
                if (ovjeraUlaznice.isValid == true && ovjeraUlaznice.AlreadyVisited == true) {
                    var visit = _db.Visits.FirstOrDefault(o => o.KorisnikUsesUlaznica == korisnikUsesUlaznica && o.DateOfEntry == DateTime.UtcNow.Date);
                    if (visit != null) {
                        _db.Visits.Remove(visit);
                        _db.SaveChanges();

                    }
                    return Ok(new VisitResponse() {
                        IsRevoked = true
                    });
                }
                else {
                    return Ok(new VisitResponse() {
                        IsRevoked = false,
                        ErrorMessage = "Skenirani QR kod nije valjana ulaznica ili korisnik još nije ušao danas!"
                    });
                }
                
            }
            catch (Exception) {
                return StatusCode(500);
            }
        }

    }
}
