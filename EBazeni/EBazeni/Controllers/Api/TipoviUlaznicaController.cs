using EBazeni.Data;
using EBazeni.Models;
using Microsoft.AspNetCore.Authentication.JwtBearer;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Identity;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace EBazeni.Controllers.Api {
    [Route("api/[controller]")]
    [Authorize(AuthenticationSchemes = JwtBearerDefaults.AuthenticationScheme)]
    [ApiController]
    public class TipoviUlaznicaController : ControllerBase {

        private readonly ApplicationDbContext _db;
        private readonly UserManager<ApplicationUser> _userManager;

        public TipoviUlaznicaController(ApplicationDbContext db, UserManager<ApplicationUser> userManager) {
            _db = db;
            _userManager = userManager;
        }

        [HttpGet]
        public async Task<IActionResult> GetTipoviUlaznica(Guid userid) {
            try {
                var user = await _userManager.FindByIdAsync(userid.ToString());

                var temptipoviUlaznica = await _db.TipoviUlaznica.ToArrayAsync();

                var tipoviUlaznica = await _db.TipoviUlaznica.ToArrayAsync();

                if(DateTime.UtcNow.Date.Subtract(user.DatumRodenja).TotalDays >= DateTime.UtcNow.Date.Subtract(new DateTime(year: DateTime.Now.ToUniversalTime().Year - 15, month: DateTime.Now.ToUniversalTime().Month, day: DateTime.Now.ToUniversalTime().Day)).TotalDays) {
                    tipoviUlaznica = temptipoviUlaznica.Where(o => o.Ime != "Dijete do 15 godina").Select(o => new TipUlaznice() {
                        Id = o.Id,
                        Ime = o.Ime,
                        Cijena = o.Cijena,
                        MaksimalanBrojKorisnika = o.MaksimalanBrojKorisnika
                    }).ToArray();

                    //return Ok(tipoviUlaznica);
                }

                //je li korisnik unutar opcine?
                if (!WC.OpcinskaNaselja.Contains(user.Boraviste) && !WC.OpcinskaNaselja.Contains(user.Prebivaliste)) {
                    
                    tipoviUlaznica = temptipoviUlaznica.Where(o => o.Ime != "Odrasla osoba (unutar općine)").Select(o => new TipUlaznice() {
                        Id = o.Id,
                        Ime = o.Ime,
                        Cijena = o.Cijena,
                        MaksimalanBrojKorisnika = o.MaksimalanBrojKorisnika
                    }).ToArray();
                }

                return Ok(tipoviUlaznica);
                
                
            }
            catch (Exception) {

                return StatusCode(
                    StatusCodes.Status500InternalServerError,
                    "An error occured accessing the database"
                );
            }
        }
    }
}
