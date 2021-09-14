using EBazeni.Data;
using EBazeni.Models;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace EBazeni.Controllers {
    [Authorize(Roles = WC.AdminRole)]
    public class TipZaposlenikaController : Controller {

        private readonly ApplicationDbContext _db;

        public TipZaposlenikaController(ApplicationDbContext db) {
            _db = db;
        }

        public IActionResult Index() {
            IEnumerable<TipZaposlenika> tipoviZaposlenika = _db.TipoviZaposlenika;
            return View(tipoviZaposlenika);
        }

        public IActionResult Upsert(int? id) {
            if (id == null) {
                //Create
                var obj = new TipZaposlenika();
                return View(obj);
            }
            else {
                var obj = _db.TipoviZaposlenika.Find(id);

                if(obj == null) {
                    return NotFound();
                }

                return View(obj);
            }

        }

        [HttpPost]
        [ValidateAntiForgeryToken]
        public IActionResult Upsert(TipZaposlenika obj) {
            if (obj == null) {
                return NotFound();
            }

            if (obj.Id == 0) {
                _db.TipoviZaposlenika.Add(obj);
                _db.SaveChanges();
            }

            //edit
            var tipZaposlenikaFromDb = _db.TipoviZaposlenika.AsNoTracking().FirstOrDefault(o => o.Id == obj.Id);
            if (tipZaposlenikaFromDb == null) {
                return NotFound();
            }
            _db.TipoviZaposlenika.Update(obj);
            _db.SaveChanges();


            return RedirectToAction(nameof(Index));

        }

        public IActionResult Delete(int? id) {
            if (id == null) return NotFound();
            var obj = _db.TipoviZaposlenika.FirstOrDefault(o => o.Id == id);
            if (obj == null) {
                return NotFound();
            }
            return View(obj);
        }

        [HttpPost, ActionName("Delete")]
        [ValidateAntiForgeryToken]
        public IActionResult DeletePost(int? id) {
            if (id == null) return NotFound();
            var obj = _db.TipoviZaposlenika.FirstOrDefault(o => o.Id == id);
            if (obj == null) {
                return NotFound();
            }
            _db.TipoviZaposlenika.Remove(obj);
            _db.SaveChanges();


            return RedirectToAction(nameof(Index));

        }

    }
}
