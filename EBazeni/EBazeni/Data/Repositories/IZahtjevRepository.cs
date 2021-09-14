using EBazeni.Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace EBazeni.Data.Repositories {
    public interface IZahtjevRepository {
        Task<IEnumerable<Zahtjev>> GetZahtjevi();
        Task<Zahtjev> GetZahtjevById(int zahtjevId);
        Task<Zahtjev> GetZahtjevByUserId(string userId);
        Task<Zahtjev> AddZahtjev(Zahtjev zahtjev);
        Task<Zahtjev> UpdateZahtjev(Zahtjev zahtjev);
        Task DeleteZahtjev(int zahtjevId);

    }
}
