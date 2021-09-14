using EBazeni.Data;
using EBazeni.Models;
using EBazeni.Models.DTOs.Requests;
using EBazeni.Models.DTOs.Responses;
using Microsoft.AspNetCore.Authentication.JwtBearer;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Identity;
using Microsoft.AspNetCore.JsonPatch;
using Microsoft.AspNetCore.Mvc;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace EBazeni.Controllers.Api.Authentication {
    [Route("api/[controller]")]
    [ApiController]
    [Authorize(AuthenticationSchemes = JwtBearerDefaults.AuthenticationScheme)]
    public class UserManagementController : ControllerBase {

        private readonly ApplicationDbContext _db;
        private readonly UserManager<ApplicationUser> _userManager;

        public UserManagementController(ApplicationDbContext db, UserManager<ApplicationUser> userManager) {
            _userManager = userManager;
            _db = db;
        }

        [HttpPost("{userId:Guid}")]
        public async Task<IActionResult> EditUserInformation(Guid userId, [FromBody] UserInformationDTO userInformationDTO) {

            try {
                var userToPatch = await _userManager.FindByIdAsync(userId.ToString());
                if (userToPatch == null) {
                    return NotFound(new RegistrationResponse() { 
                        Success = false,
                        Errors = { "Korisnik nije pronađen" } 
                    });
                }

                if (userInformationDTO.Email != null) {
                    if (await _userManager.FindByEmailAsync(userInformationDTO.Email) != null) {
                        userToPatch.Email = userInformationDTO.Email ?? userToPatch.Email;
                    }
                }

                if(userInformationDTO.UserName != null) {
                    if (await _userManager.FindByNameAsync(userInformationDTO.UserName) != null) {
                        userToPatch.UserName = userInformationDTO.UserName ?? userToPatch.UserName;
                    }
                }
                    
                userToPatch.Ime = userInformationDTO.Ime ?? userToPatch.Ime;
                userToPatch.Prezime = userInformationDTO.Prezime ?? userToPatch.Prezime;
                userToPatch.OIB = userInformationDTO.OIB ?? userToPatch.OIB;
                userToPatch.DatumRodenja = userInformationDTO.DatumRodenja != null ?  DateTime.ParseExact(userInformationDTO.DatumRodenja, "MM-dd-yyyy", null).ToUniversalTime().Date : userToPatch.DatumRodenja;
                userToPatch.Prebivaliste = userInformationDTO.Prebivaliste ?? userToPatch.Prebivaliste;
                userToPatch.Boraviste = userInformationDTO.Boraviste ?? userToPatch.Boraviste;

                var result = await _userManager.UpdateAsync(userToPatch);
                var roles = await _userManager.GetRolesAsync(userToPatch);
                if (result.Succeeded) {
                    return Ok(new RegistrationResponse() {
                        Success = true,
                        User = userToPatch,
                        Role = roles[0]
                    });
                }

                else {
                    return StatusCode(500, new RegistrationResponse() {
                        Success = false,
                        Errors = { "Dogodila se pogreška pri pristupu serveru. Pokušajte ponovno kasnije" }
                    });
                }

            }
            catch (Exception) {

                throw;
            }

            
        }

    }
}
