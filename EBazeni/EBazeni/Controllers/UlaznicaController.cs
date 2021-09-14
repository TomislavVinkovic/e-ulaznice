using EBazeni.Data;
using EBazeni.Models;
using EBazeni.Models.ViewModels;
using Microsoft.AspNetCore.Identity;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.Rendering;
using Microsoft.EntityFrameworkCore;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;


namespace EBazeni.Controllers {
    public class UlaznicaController : Controller {

        private readonly ApplicationDbContext _db;
        private readonly UserManager<ApplicationUser> _userManager;

        public UlaznicaController(ApplicationDbContext db, UserManager<ApplicationUser> userManager) {
            _db = db;
            _userManager = userManager;
        }

        [HttpGet]
        public IActionResult Index() {
            var korisniciUseUlaznice = _db.KorisnikUsesUlaznica.Include(o => o.ApplicationUser).Include(o => o.Ulaznica).ToList();

            return View(korisniciUseUlaznice);
        }

        [HttpGet]
        public async Task<IActionResult> Upsert(int? zahtjevId, Guid? ulaznicaId){

            if (zahtjevId != null) {

                var zahtjev = _db.Zahtjevi.Include(o => o.TipUlazniceForZahtjev).FirstOrDefault(o => o.Id == zahtjevId);
                if (zahtjev != null) {
                    var tipoviUlaznica = _db.TipoviUlaznica.Select(o => new SelectListItem() {
                        Value = o.Id.ToString(),
                        Text = o.Ime,
                        Selected = o.Id == zahtjev.TipUlazniceZahtjevId ? true : false
                    }).ToList();
                    var ulaznicaVM = new UlaznicaVM() {
                        Zahtjev = zahtjev,
                        TipoviUlaznica = tipoviUlaznica,

                        KorisnikUsesUlaznica = new KorisnikUsesUlaznica() {
                            ApplicationUserId = zahtjev.ApplicationUserZahtjevId,
                            Ulaznica = new Ulaznica() {
                                TipUlazniceId = zahtjev.TipUlazniceZahtjevId,
                                EndDate = DateTime.UtcNow.Date
                            },
                            
                        },
                    };
                    return View(ulaznicaVM);
                }
                else {
                    return NotFound();
                }
            }
            else if (ulaznicaId != null) {
                var tipoviUlaznica = _db.TipoviUlaznica.Select(o => new SelectListItem() {
                    Value = o.Id.ToString(),
                    Text = o.Ime
                }).ToList();
                var ulaznica = _db.Ulaznice.FirstOrDefault(o => o.BrojUlaznice == ulaznicaId);
                if (ulaznica != null) {
                    var ulaznicaVM = new UlaznicaVM() {
                        Zahtjev = null,
                        TipoviUlaznica = tipoviUlaznica,
                        KorisnikUsesUlaznica = new KorisnikUsesUlaznica() { 
                            Ulaznica = ulaznica
                        }
                    };
                    return View(ulaznicaVM);
                }
                else {
                    return NotFound();
                }

            }

            else if (zahtjevId == null && ulaznicaId == null) {
                var tipoviUlaznica = _db.TipoviUlaznica.Select(o => new SelectListItem() {
                    Value = o.Id.ToString(),
                    Text = o.Ime
                }).ToList();

                List<ApplicationUser> notEgligableUsersList = _db.KorisnikUsesUlaznica.Select(o => new ApplicationUser() {
                    Id = o.ApplicationUser.Id,
                    OIB = o.ApplicationUser.OIB,
                    Ime = o.ApplicationUser.Ime,
                    Prezime = o.ApplicationUser.Prezime,
                }).ToList();

                List<SelectListItem> usersList = _db.ApplicationUsers.Where(o => !notEgligableUsersList.Contains(o)).Select(o => new SelectListItem() { 
                    Value = o.Id,
                    Text = $"{o.Ime} {o.Prezime}, {o.OIB}, {o.Prebivaliste}, {o.Boraviste}"
                }).ToList();

                return View(new UlaznicaVM() {
                    Zahtjev = null,
                    TipoviUlaznica = tipoviUlaznica,
                    ApplicationUsers = usersList
                });
            }

            else return BadRequest();
        }

        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> Upsert(UlaznicaVM obj) {
            var tipUlaznice = _db.TipoviUlaznica.FirstOrDefault(o => o.Id == obj.KorisnikUsesUlaznica.Ulaznica.TipUlazniceId);

            if (tipUlaznice == null) {
                return NotFound();
            }
            if (obj == null) {
                return BadRequest();
            }

            if (obj.KorisnikUsesUlaznica.Ulaznica.BrojUlaznice == Guid.Empty) {
                //create
                var user = await _userManager.FindByIdAsync(obj.KorisnikUsesUlaznica.ApplicationUserId);
                var ulaznica = new Ulaznica() {
                    BrojUlaznice = Guid.NewGuid(),
                    EndDate = obj.KorisnikUsesUlaznica.Ulaznica.EndDate,
                    TipUlaznice = tipUlaznice,
                };

                await _db.Ulaznice.AddAsync(ulaznica);
                await _db.SaveChangesAsync();

                var korisnikUsesUlaznica = new KorisnikUsesUlaznica() {
                    Key = Guid.NewGuid(),
                    ApplicationUser = user,
                    Ulaznica = ulaznica
                };

                await _db.KorisnikUsesUlaznica.AddAsync(korisnikUsesUlaznica);
                await _db.SaveChangesAsync();

                var zahtjev = _db.Zahtjevi.FirstOrDefault(o => o.ApplicationUserForZahtjev == user);
                if(zahtjev != null) {
                    _db.Zahtjevi.Remove(zahtjev);
                    await _db.SaveChangesAsync();
                }

                return RedirectToAction(controllerName: "Ulaznica", actionName: "Index");
            }

            else {
                var objFromDb = _db.Ulaznice.AsNoTracking().FirstOrDefault(o => o.BrojUlaznice == obj.KorisnikUsesUlaznica.Ulaznica.BrojUlaznice);
                if (objFromDb != null) {
                    _db.Ulaznice.Update(obj.KorisnikUsesUlaznica.Ulaznica);
                    await _db.SaveChangesAsync();
                    return RedirectToAction(controllerName: "Ulaznica", actionName: "Index");
                }
                else {
                    return NotFound();
                }
            }

        }
    }
}
