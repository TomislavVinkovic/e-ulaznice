using System;
using System.Transactions;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Threading.Tasks;
using EBazeni.Data;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Identity;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.RazorPages;
using EBazeni.Models;
using EBazeni.Utilities.ValidationAttributes;
using System.Net;
using Microsoft.EntityFrameworkCore;

namespace EBazeni.Areas.Identity.Pages.Account.Manage
{
    [Authorize(Roles = WC.AdminRole)]
    public class DisableUserAdminModel : PageModel {

        private readonly UserManager<ApplicationUser> _userManager;
        private readonly ApplicationDbContext _db;

        public DisableUserAdminModel(UserManager<ApplicationUser> userManager, ApplicationDbContext db) {
            _db = db;
            _userManager = userManager;
        }

        [BindProperty]
        public InputModel Input { get; set; }

        public class InputModel {
            [Display(Name = "Trajno obrisati korisnika?")]
            public bool Delete { get; set; }

            
            [Display(Name = "Onemogući pristup do:")]
            [DataType(DataType.Date)]
            [DateTimeRange]
            public DateTime OnemogucenjePristupa { get; set; }
        }
        
        public async Task<IActionResult> OnGetAsync(string? id)
        {
            if (id == null) return NotFound();

            var user = await _db.ApplicationUsers.AsNoTracking().FirstOrDefaultAsync(o => o.Id == id);
            if (user != null) {
                Input = new InputModel();              
                Input.Delete = false;
                if (user.LockoutEnd != null) {
                    Input.OnemogucenjePristupa = user.LockoutEnd.Value.ToLocalTime().Date;
                }
                else {
                    Input.OnemogucenjePristupa = DateTime.Now.Date;
                }
            }
            else return NotFound();
            
            return Page();
            
        }

        public async Task<IActionResult> OnPostAsync(string? id) {
            var user = await _userManager.FindByIdAsync(id);
            var rolesForUser = await _userManager.GetRolesAsync(user);
            var logins = await _userManager.GetLoginsAsync(user);
            if (ModelState.IsValid) {
                if (Input.Delete) {
                    using (var transaction = _db.Database.BeginTransaction()) {
                        IdentityResult result = IdentityResult.Success;

                        foreach (var login in logins) {
                            result = await _userManager.RemoveLoginAsync(user, login.LoginProvider, login.ProviderKey);
                            if (result != IdentityResult.Success) {
                                break;
                            }
                        }

                        if (result == IdentityResult.Success) {
                            foreach (var role in rolesForUser) {
                                result = await _userManager.RemoveFromRoleAsync(user, role);
                                if (result != IdentityResult.Success) {
                                    break;
                                }
                            }
                        }

                        if (result == IdentityResult.Success) {
                            result = await _userManager.DeleteAsync(user);
                            if (result == IdentityResult.Success) {
                                transaction.Commit();
                            }
                        }
                    }

                }


                else if (!Input.Delete) {
                    using (var transaction = _db.Database.BeginTransaction()) {
                        IdentityResult result = IdentityResult.Success;
                        result = await _userManager.SetLockoutEnabledAsync(user, true);
                        result = await _userManager.SetLockoutEndDateAsync(user, lockoutEnd: Input.OnemogucenjePristupa.ToUniversalTime());
                        transaction.Commit();
                    }
                }
            }
            else return Page();

            return RedirectToAction("Index", controllerName: "UserManager");
        }
    }
}
