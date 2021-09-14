using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Text;
using System.Text.Encodings.Web;
using System.Threading.Tasks;
using EBazeni.Data;
using EBazeni.Models;
using Microsoft.AspNetCore.Authentication;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Identity;
using Microsoft.AspNetCore.Identity.UI.Services;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.RazorPages;
using Microsoft.AspNetCore.Mvc.Rendering;
using Microsoft.AspNetCore.WebUtilities;
using Microsoft.Extensions.Logging;

namespace EBazeni.Areas.Identity.Pages.Account
{
    [Authorize(Roles = WC.AdminRole)]
    public class RegisterModel : PageModel
    {
        private readonly SignInManager<ApplicationUser> _signInManager;
        private readonly UserManager<ApplicationUser> _userManager;
        private readonly ILogger<RegisterModel> _logger;
        private readonly IEmailSender _emailSender;
        private readonly RoleManager<IdentityRole> _roleManager;
        private readonly ApplicationDbContext _db;

        public RegisterModel(
            UserManager<ApplicationUser> userManager,
            SignInManager<ApplicationUser> signInManager,
            ILogger<RegisterModel> logger,
            IEmailSender emailSender,
            RoleManager<IdentityRole> roleManager,
            ApplicationDbContext db
            )
        {
            _userManager = userManager;
            _signInManager = signInManager;
            _logger = logger;
            _emailSender = emailSender;
            _roleManager = roleManager;
            _db = db;
        }

        [BindProperty]
        public InputModel Input { get; set; }

        [BindProperty]
        public IEnumerable<SelectListItem> TipoviZaposlenika { get; set; }

        public string ReturnUrl { get; set; }

        public IList<AuthenticationScheme> ExternalLogins { get; set; }

        public class InputModel
        {
            [Required]
            [EmailAddress]
            [Display(Name = "E-mail adresa")]
            public string Email { get; set; }

            [Required]
            [Display(Name = "Korisničko ime")]
            public string Username { get; set; }

            
            [Required]
            [MaxLength(11)]
            [Display(Name = "OIB(Osobni identifikacijski broj)")]
            public string OIB { get; set; }
            
            [Required]
            [Display(Name = "Tip zaposlenika")]
            public int TipZaposlenika { get; set; }

            [Required]
            [Display(Name = "Datum Rođenja")]
            [DataType(DataType.Date)]
            public DateTime DatumRodenja { get; set; }
            

            [Required]
            [Display(Name = "Ime")]
            public string Ime { get; set; }

            [Required]
            [Display(Name = "Prezime")]
            public string Prezime { get; set; }

            
            [Required]
            [Display(Name = "Prebivalište")]
            public string Prebivaliste { get; set; }

            [Required]
            [Display(Name = "Boravište")]
            public string Boraviste { get; set; }
            

            [Required]
            [StringLength(100, ErrorMessage = "The {0} must be at least {2} and at max {1} characters long.", MinimumLength = 6)]
            [DataType(DataType.Password)]
            [Display(Name = "Lozinka")]
            public string Password { get; set; }

            [DataType(DataType.Password)]
            [Display(Name = "Potvrdi lozinku")]
            [Compare("Password", ErrorMessage = "The password and confirmation password do not match.")]
            public string ConfirmPassword { get; set; }

            
            [Display(Name = "Zaposlenik ima pune administratorske ovlasti?")]
            public bool IsAdmin { get; set; }
            


        }

        public async Task OnGetAsync(string returnUrl = null)
        {
            TipoviZaposlenika = _db.TipoviZaposlenika.Select(o => new SelectListItem {
                Value = o.Id.ToString(),
                Text = o.Naziv.ToString()
            });
            ReturnUrl = returnUrl;
            ExternalLogins = (await _signInManager.GetExternalAuthenticationSchemesAsync()).ToList();
        }

        public async Task<IActionResult> OnPostAsync(string returnUrl = null)
        {
            returnUrl ??= Url.Content("~/");
            TipZaposlenika tipZaposlenika = _db.TipoviZaposlenika.Find(Input.TipZaposlenika);
            ExternalLogins = (await _signInManager.GetExternalAuthenticationSchemesAsync()).ToList();
            if (ModelState.IsValid)
            {

                ApplicationUser user;

                if (Input.IsAdmin) {
                    user = new ApplicationUser { UserName = Input.Username, Email = Input.Email, Ime = Input.Ime, Prezime = Input.Prezime, OIB = Input.OIB, Prebivaliste = Input.Prebivaliste, Boraviste = Input.Boraviste, DatumRodenja = Input.DatumRodenja };
                }
                else {
                    user = new ApplicationUser { UserName = Input.Username, Email = Input.Email, Ime = Input.Ime, Prezime = Input.Prezime, OIB = Input.OIB, Prebivaliste = Input.Prebivaliste, Boraviste = Input.Boraviste, DatumRodenja = Input.DatumRodenja };
                }
                


                var result = await _userManager.CreateAsync(user, Input.Password);
                if (result.Succeeded)
                {
                    //Ovo sam napravio pri prvoj registraciji kako bih dodao korisniku automatski ulogu admina

                    /*
                    await _roleManager.CreateAsync(new IdentityRole{ Name = WC.AdminRole });
                    await _roleManager.CreateAsync(new IdentityRole { Name = WC.ZaposlenikRole });
                    await _roleManager.CreateAsync(new IdentityRole { Name = WC.KupacRole });
                    */
                    

                    if (Input.IsAdmin) {
                        await _userManager.AddToRoleAsync(user, WC.AdminRole);
                    }
                    else {
                        await _userManager.AddToRoleAsync(user, WC.ZaposlenikRole);
                        
                        var zaposlenik = new Zaposlenik() {
                            TipZaposlenika = _db.TipoviZaposlenika.Find(Input.TipZaposlenika),
                            ApplicationUser = user
                        };
                        _db.Zaposlenici.Add(zaposlenik);
                        _db.SaveChanges();
                        
                }


                _logger.LogInformation("User created a new account with password.");

                    var code = await _userManager.GenerateEmailConfirmationTokenAsync(user);
                    code = WebEncoders.Base64UrlEncode(Encoding.UTF8.GetBytes(code));
                    var callbackUrl = Url.Page(
                        "/Account/ConfirmEmail",
                        pageHandler: null,
                        values: new { area = "Identity", userId = user.Id, code = code, returnUrl = returnUrl },
                        protocol: Request.Scheme);

                    await _emailSender.SendEmailAsync(Input.Email, "Confirm your email",
                        $"Please confirm your account by <a href='{HtmlEncoder.Default.Encode(callbackUrl)}'>clicking here</a>.");

                    if (_userManager.Options.SignIn.RequireConfirmedAccount)
                    {
                        return RedirectToPage("RegisterConfirmation", new { email = Input.Email, returnUrl = returnUrl });
                    }
                    else
                    {
                        await _signInManager.SignInAsync(user, isPersistent: false);
                        return LocalRedirect(returnUrl);
                    }
                }
                foreach (var error in result.Errors)
                {
                    ModelState.AddModelError(string.Empty, error.Description);
                }
            }

            // If we got this far, something failed, redisplay form
            return Page();
        }
    }
}
