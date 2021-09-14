using EBazeni.Data.Repositories;
using EBazeni.Models;
using Microsoft.AspNetCore.Authentication.JwtBearer;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace EBazeni.Controllers.Api {
    [Route("api/[controller]")]
    [Authorize(AuthenticationSchemes =JwtBearerDefaults.AuthenticationScheme)]
    [ApiController]
    public class ZahtjeviController : ControllerBase {
        private readonly IZahtjevRepository _zahtjevRepository;

        public ZahtjeviController(IZahtjevRepository zahtjevRepository) {
            _zahtjevRepository = zahtjevRepository;
        }

        [HttpGet]
        public async Task<ActionResult> GetZahtjevi() {
            try {
                return Ok(await _zahtjevRepository.GetZahtjevi());
            }
            catch (Exception) {

                return StatusCode(
                    StatusCodes.Status500InternalServerError,
                    "An error occured accessing the database"
                );
            }
            
        }

        //ekstenzija api rute
        [HttpGet("{id:int}")]
        public async Task<ActionResult<Zahtjev>> GetZahtjev(int id) {
            try {
                if (ModelState.IsValid) {
                    var result = await _zahtjevRepository.GetZahtjevById(id);

                    if (result == null) {
                        return NotFound();
                    }
                    return result;
                }
                else return StatusCode(
                    StatusCodes.Status500InternalServerError,
                    "Provided model is not valid"
                );

            }
            catch (Exception) {

                return StatusCode(
                    StatusCodes.Status500InternalServerError,
                    "An error occured accessing the database"
                );
            }
        }

        [HttpPost]
        public async Task<ActionResult<Zahtjev>> CreateZahtjev(Zahtjev zahtjev) {
            try {
                if (zahtjev == null) {
                    return BadRequest();
                }

                var createdZahtjev = await _zahtjevRepository.AddZahtjev(zahtjev);

                return CreatedAtAction(
                    nameof(GetZahtjev),
                    new { id = createdZahtjev.Id}, createdZahtjev);
            }
            catch (Exception) {

                return StatusCode(
                    StatusCodes.Status500InternalServerError,
                    "An error occured creating the record"
                );
            }
        }

        [HttpPut("{userId:int}")]

        public async Task<ActionResult<Zahtjev>> UpdateZahtjev(string userId) {
            try {

                var zahtjevFromDb = await _zahtjevRepository.GetZahtjevByUserId(userId);

                if (zahtjevFromDb == null || userId == null || userId != zahtjevFromDb.ApplicationUserZahtjevId) {
                    return NotFound($"Zahtjev sa Id-em {userId} nije pronađen");
                }
                return Ok(zahtjevFromDb);
            }
            catch (Exception) {

                return StatusCode(
                    StatusCodes.Status500InternalServerError,
                    "An error occured updating the record"
                );
            }
        }

        [HttpGet("{userId:Guid}")]
        public async Task<ActionResult<Zahtjev>> GetZahtjevByUserId(Guid userId) {
            try {

                var zahtjevFromDb = await _zahtjevRepository.GetZahtjevByUserId(userId.ToString());

                if (zahtjevFromDb == null) {
                    return NotFound($"Zahtjev sa Id-em {userId} nije pronađen");
                }
                return Ok(zahtjevFromDb);
            }
            catch (Exception) {

                return StatusCode(
                    StatusCodes.Status500InternalServerError,
                    "An error occured updating the record"
                );
            }
        }

        [HttpDelete("{id:int}")]
        public async Task<ActionResult<Zahtjev>> DeleteZahtjev(int id) {
            try {
                var zahtjevFromDb = await _zahtjevRepository.GetZahtjevById(id);
                if (zahtjevFromDb == null) {
                    return NotFound($"Zahtjev sa Id-em {id} nije pronađen");
                }
                await _zahtjevRepository.DeleteZahtjev(id);

                return Ok("Zahtjev uspješno obrisan!");
            }
            catch (Exception) {

                return StatusCode(
                    StatusCodes.Status500InternalServerError,
                    "An error occured deleting the record"
                );
            }
        }

    }
}
