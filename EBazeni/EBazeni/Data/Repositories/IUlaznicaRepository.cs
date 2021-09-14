using EBazeni.Models;
using EBazeni.Models.DTOs.Responses;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace EBazeni.Data.Repositories {
    public interface IUlaznicaRepository {
        Task<KorisnikUsesUlaznica> GetUlaznicaByBrojUlaznice(Guid brojUlaznice);
        Task<IEnumerable<Ulaznica>> GetUlaznice();
        Task<IEnumerable<Ulaznica>> GetUlazniceOfType(int id);
        Task<KorisnikUsesUlaznica> GetUlaznicaByUserId(Guid userId);
        Task<OvjeraUlazniceResponse> OvjeriUlaznicu(Guid brojUlaznice); 
    }
}
