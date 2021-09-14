using EBazeni.Models;
using EBazeni.Models.DTOs.Responses;
using Microsoft.AspNetCore.Identity;
using Microsoft.EntityFrameworkCore;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace EBazeni.Data.Repositories {
    public class UlaznicaRepository : IUlaznicaRepository {

        private readonly ApplicationDbContext _db;
        private readonly UserManager<ApplicationUser> _userManager;

        public UlaznicaRepository(ApplicationDbContext db, UserManager<ApplicationUser> userManager) {
            _db = db;
            _userManager = userManager;
        }

        public async Task<KorisnikUsesUlaznica> GetUlaznicaByBrojUlaznice(Guid brojUlaznice) {
            return await _db.KorisnikUsesUlaznica.Include(o => o.Ulaznica).Include(o => o.ApplicationUser).FirstOrDefaultAsync(o => o.Key == brojUlaznice);

        }

        public async Task<IEnumerable<Ulaznica>> GetUlaznice() {
            return await _db.Ulaznice.Include(o => o.TipUlaznice).ToListAsync();
        }

        public async Task<IEnumerable<Ulaznica>> GetUlazniceOfType(int id) {
            return await _db.Ulaznice
                .Include(o => o.TipUlaznice)
                .Where(o => o.TipUlazniceId == id)
                .ToListAsync();
        }

        public async Task<KorisnikUsesUlaznica> GetUlaznicaByUserId(Guid userId){
            var user = await _userManager.FindByIdAsync(userId.ToString());
            try {
                var korisnikUsesUlaznica = await _db.KorisnikUsesUlaznica.Include(o => o.Ulaznica).FirstOrDefaultAsync(o => o.ApplicationUser == user && o.Ulaznica.EndDate >= DateTime.UtcNow);

                if (korisnikUsesUlaznica != null) {
                    return korisnikUsesUlaznica;
                }
                else return null;
            }

            catch {
                return null;
            }
            
        }

        public async Task<OvjeraUlazniceResponse> OvjeriUlaznicu(Guid brojUlaznice) {
            var korisnikUsesUlaznica = await _db.KorisnikUsesUlaznica.FirstOrDefaultAsync(o => o.Key == brojUlaznice);

            //checks if the user and ulaznica objects exist
            if (korisnikUsesUlaznica == null) {
                return new OvjeraUlazniceResponse() {
                    isValid = false,
                };
            }

            var user = await _userManager.FindByIdAsync(korisnikUsesUlaznica.ApplicationUserId);
            var ulaznica = await _db.Ulaznice.FirstOrDefaultAsync(o => o.BrojUlaznice == korisnikUsesUlaznica.UlaznicaId);

            //checks if the date of the ticket is valid
            if (ulaznica.EndDate.ToLocalTime() < DateTime.Now.ToLocalTime()) {
                return new OvjeraUlazniceResponse() {
                    isValid = false
                };
            }

            //checks if the user already got in today
            var visit = _db.Visits.FirstOrDefault(o => o.KorisnikUsesUlaznica == korisnikUsesUlaznica && o.DateOfEntry.Date == DateTime.UtcNow.Date);
            if (visit != null) {
                return new OvjeraUlazniceResponse() {
                    ImeKorisnika = user.Ime,
                    PrezimeKorisnika = user.Prezime,
                    EndDate = ulaznica.EndDate,
                    isValid = true,
                    AlreadyVisited = true
                };
            }

            return new OvjeraUlazniceResponse() {
                ImeKorisnika = user.Ime,
                PrezimeKorisnika = user.Prezime,
                EndDate = ulaznica.EndDate,
                isValid = true,
                AlreadyVisited = false
            };

        }
    }
}
