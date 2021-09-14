using EBazeni.Data;
using EBazeni.Models;
using EBazeni.Models.ViewModels;
using Microsoft.AspNetCore.Identity;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace EBazeni.Controllers {
    public class UserManagerController : Controller {

        private readonly ApplicationDbContext _db;
        public UserManager<ApplicationUser> _userManager { get; set; }

        public UserManagerController(ApplicationDbContext db, UserManager<ApplicationUser> userManager) {
            _db = db;
            _userManager = userManager;
        }

        public async Task<IActionResult> Index() {
            IEnumerable<ApplicationUser> users = await _userManager.GetUsersInRoleAsync(roleName : WC.ZaposlenikRole);
            IEnumerable<Zaposlenik> zaposlenici = _db.Zaposlenici.Where(o => users.Contains(o.ApplicationUser)).Include(o => o.TipZaposlenika);

            ZaposlenikVM zaposlenikVM = new ZaposlenikVM() {
                ApplicationUsers = users,
                Zaposlenici = zaposlenici
            };

            return View(zaposlenikVM);
        }
    }
}
