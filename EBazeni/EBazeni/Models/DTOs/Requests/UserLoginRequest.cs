using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Threading.Tasks;

namespace EBazeni.Models.DTOs.Requests {
    public class UserLoginRequest {

        [Required]
        public string UserName { get; set; }

        [Required]
        public string Password { get; set; }
    }
}
