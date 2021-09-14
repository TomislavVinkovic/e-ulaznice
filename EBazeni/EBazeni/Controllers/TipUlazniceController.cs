using EBazeni.Data;
using EBazeni.Models;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Microsoft.EntityFrameworkCore;

namespace EBazeni.Controllers {
    [Authorize(Roles = WC.AdminRole + "," + WC.ZaposlenikRole)]
    public class TipUlazniceController : Controller {

        private readonly ApplicationDbContext _db;

        public TipUlazniceController(ApplicationDbContext db) {
            _db = db;
        }

        public IActionResult Index() {
            var tipoviUlaznica = _db.TipoviUlaznica;
            return View(tipoviUlaznica);
        }

        //UPSERT - GET
        public IActionResult Upsert(int? id) {
            var obj = new TipUlaznice();
            if (id == null) {
                return View(obj);
            }
            obj = _db.TipoviUlaznica.FirstOrDefault(o => o.Id == id);
            if (obj == null) return NotFound();

            return View(obj);
        }

        //UPSERT - POST
        [HttpPost]
        [ValidateAntiForgeryToken]
        public IActionResult Upsert(TipUlaznice obj) {
            if (obj == null) {
                return NotFound();
            }
            var tipUlazniceFromDb = _db.TipoviUlaznica.AsNoTracking().FirstOrDefault(o => o.Id == obj.Id);
            if (tipUlazniceFromDb == null) {
                _db.TipoviUlaznica.Add(obj);
                _db.SaveChanges();
            }
            else {
                _db.TipoviUlaznica.Update(obj);
                _db.SaveChanges();
            }
            return RedirectToAction(nameof(Index));
        }

        //DELETE - GET
        public IActionResult Delete(int? id) {
            if (id == null) {
                return NotFound();
            }
            var tipUlaznice = _db.TipoviUlaznica.FirstOrDefault(o => o.Id == id);
            if (tipUlaznice == null) {
                return NotFound();
            }

            return View(tipUlaznice);
        }

        //DELETE - POST
        [HttpPost, ActionName("Delete")]
        [ValidateAntiForgeryToken]
        public IActionResult DeletePost(int? id) {
            var obj = _db.TipoviUlaznica.FirstOrDefault(o => o.Id == id);
            if (obj == null || obj.Id == 0) {
                return NotFound();
            }
            _db.TipoviUlaznica.Remove(obj);
            _db.SaveChanges();
            return RedirectToAction(nameof(Index));
        }

    }
}
