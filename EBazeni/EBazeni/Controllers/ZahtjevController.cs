using EBazeni.Data;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace EBazeni.Controllers {
    public class ZahtjevController : Controller {

        private readonly ApplicationDbContext _db;

        public ZahtjevController(ApplicationDbContext db) {
            _db = db;
        }

        public IActionResult Index() {
            var zahtjevi = _db.Zahtjevi.Include(o => o.ApplicationUserForZahtjev).Include(o => o.TipUlazniceForZahtjev).ToList();

            return View(zahtjevi);
        }

    }
}
