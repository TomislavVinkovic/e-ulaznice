using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Threading.Tasks;
using EBazeni.Data;
using EBazeni.Models;
using EBazeni.Models.ViewModels;
using Microsoft.AspNetCore.Identity;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.RazorPages;
using Microsoft.AspNetCore.Mvc.Rendering;
using Microsoft.EntityFrameworkCore;

namespace EBazeni.Areas.Identity.Pages.Account.Manage
{
    public class EditUserAdminModel : PageModel
    {

        private readonly UserManager<ApplicationUser> _userManager;
        private readonly RoleManager<IdentityRole> _roleManager;
        private readonly ApplicationDbContext _db;

        public EditUserAdminModel(UserManager<ApplicationUser> userManager, ApplicationDbContext db, RoleManager<IdentityRole> roleManager) {
            _userManager = userManager;
            _db = db;
            _roleManager = roleManager;
        }

        [BindProperty]
        public IEnumerable<SelectListItem> TipoviZaposlenika { get; set; }

        [BindProperty]
        public Zaposlenik Zaposlenik { get; set; }

        [BindProperty]
        public InputModel Input { get; set; }

        public class InputModel {

            public void mapToUser(ApplicationUser user) {
                user.Email = Email;
                user.UserName = UserName;
                user.Ime = Ime;
                user.Prezime = Prezime;
                user.OIB = OIB;
                user.DatumRodenja = DatumRodenja;
                user.Prebivaliste = Prebivaliste;
                user.Boraviste = Boraviste;
            }

            [Required]
            [Display(Name = "Korisničko ime")]
            public string UserName { get; set; }

            [Required]
            [Display(Name = "E-mail adresa")]
            public string Email { get; set; }

            [Required]
            public string Ime { get; set; }

            [Required]
            public string Prezime { get; set; }

            [Required]
            [MaxLength(11)]
            [Display(Name = "OIB (Osobni Identifikacijski Broj)")]
            public string OIB { get; set; }

            [Required]
            [Display(Name = "Datum rođenja")]
            public DateTime DatumRodenja { get; set; }

            [Required]
            [Display(Name = "Mjesto prebivališta")]
            public string Prebivaliste { get; set; }

            [Required]
            [Display(Name = "Mjesto boravišta")]
            public string Boraviste { get; set; }

            [Required]
            [Display(Name = ("Zaposlenik ima pune administratorske ovlasti?"))]
            public bool IsAdmin { get; set; }

            [Required]
            [Display(Name = ("Tip Zaposlenika"))]
            public int TipZaposlenika { get; set; }
        }

        public async Task<IActionResult> OnGetAsync(string? id){

            if (id == null) return NotFound();

            var user = await _db.ApplicationUsers.AsNoTracking().FirstOrDefaultAsync(o => o.Id == id);
            var roles = await _userManager.GetRolesAsync(user);
            bool isAdminInitial;
            if (roles.Contains(WC.AdminRole)) {
                isAdminInitial = true;
            }
            else {
                isAdminInitial = false;
            }
            Zaposlenik = _db.Zaposlenici.Include(o => o.TipZaposlenika).Include(o => o.ApplicationUser).FirstOrDefault(o => o.ApplicationUserId == user.Id);
            Input = new InputModel() {
                Email = user.Email,
                UserName = user.UserName,
                Ime = user.Ime,
                Prezime = user.Prezime,
                OIB = user.OIB,
                DatumRodenja = user.DatumRodenja,
                Prebivaliste = user.Prebivaliste,
                Boraviste = user.Boraviste,
                IsAdmin = isAdminInitial,
                TipZaposlenika = Zaposlenik.TipZaposlenika.Id
        };

            TipoviZaposlenika = _db.TipoviZaposlenika.Select(o => new SelectListItem {
                Value = o.Id.ToString(),
                Text = o.Naziv.ToString(),
            });

            return Page();
        }

        public async Task<IActionResult> OnPostAsync() {
            if (Input.Email != null) {
                var user = await _userManager.FindByEmailAsync(Input.Email);
                Zaposlenik = _db.Zaposlenici.Include(o => o.TipZaposlenika).Include(o => o.ApplicationUser).FirstOrDefault(o => o.ApplicationUser == user);
                var roles = await _userManager.GetRolesAsync(user);
                if (!roles.Contains(WC.AdminRole) && Input.IsAdmin) {
                    await _userManager.AddToRoleAsync(user, WC.AdminRole);
                }
                Input.mapToUser(user);
                await _userManager.UpdateAsync(user);
                Zaposlenik.TipZaposlenika = _db.TipoviZaposlenika.Find(Input.TipZaposlenika);
                _db.Zaposlenici.Update(Zaposlenik);
                _db.SaveChanges();
            }
            else {
                return NotFound();
            }

            return RedirectToAction(controllerName: "UserManager", actionName: "Index");
        }
    }
}
