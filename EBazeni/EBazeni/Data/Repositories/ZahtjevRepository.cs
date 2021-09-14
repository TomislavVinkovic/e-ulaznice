using EBazeni.Models;
using Microsoft.EntityFrameworkCore;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace EBazeni.Data.Repositories {
    public class ZahtjevRepository : IZahtjevRepository {

        private readonly ApplicationDbContext _db;

        public ZahtjevRepository(ApplicationDbContext db) {
            _db = db;
        }

        public async Task<Zahtjev> AddZahtjev(Zahtjev zahtjev) {
            var result = await _db.Zahtjevi.AddAsync(zahtjev);
            await _db.SaveChangesAsync();
            return result.Entity;
        }

        public async Task DeleteZahtjev(int zahtjevId) {
            var result = await _db.Zahtjevi.FirstOrDefaultAsync(o => o.Id == zahtjevId);
            if (result != null) {
                _db.Zahtjevi.Remove(result);
                await _db.SaveChangesAsync();
            }
        }

        public async Task<Zahtjev> GetZahtjevById(int zahtjevId) {
            return await _db.Zahtjevi
                .Include(o => o.ApplicationUserForZahtjev)
                .Include(o => o.TipUlazniceForZahtjev)
                .FirstOrDefaultAsync(o => o.Id == zahtjevId);
        }

        public async Task<Zahtjev> GetZahtjevByUserId(string userId) {
            var user = await _db.ApplicationUsers.FindAsync(userId);
            return await _db.Zahtjevi
                .Include(o => o.ApplicationUserForZahtjev)
                .Include(o => o.TipUlazniceForZahtjev)
                .FirstOrDefaultAsync(o => o.ApplicationUserForZahtjev == user);
        }

        public async Task<IEnumerable<Zahtjev>> GetZahtjevi() {
            return await _db.Zahtjevi
                .Include(o => o.ApplicationUserForZahtjev)
                .Include(o => o.TipUlazniceForZahtjev)
                .ToListAsync();
        }

        public async Task<Zahtjev> UpdateZahtjev(Zahtjev zahtjev) {
            var result = await _db.Zahtjevi.FirstOrDefaultAsync(o => o.Id == zahtjev.Id);
            if (result != null){
                if(zahtjev.ApplicationUserZahtjevId != null && zahtjev.ApplicationUserZahtjevId != "") {
                    var user = _db.ApplicationUsers.FirstOrDefault(o => o.Id == zahtjev.ApplicationUserZahtjevId);
                    if (user == null) {
                        return null;
                    }
                    result.ApplicationUserForZahtjev = user;
                }

                else {
                    return null;
                }


                if (zahtjev.TipUlazniceZahtjevId != 0) {
                    var tipUlaznice = _db.TipoviUlaznica.FirstOrDefault(o => o.Id == zahtjev.TipUlazniceZahtjevId);
                    if (tipUlaznice == null) {
                        return null;
                    }
                    result.TipUlazniceForZahtjev = tipUlaznice;
                }

                else {
                    return null;
                }

                _db.Zahtjevi.Update(result);

                await _db.SaveChangesAsync();
                return result;
            }
            return null;
        }
    }
}
