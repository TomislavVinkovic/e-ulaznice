using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Threading.Tasks;

namespace EBazeni.Models.DTOs.Responses {
    public class UserResponseDTO {
        [Required]
        [EmailAddress]
        public string Email { get; set; }

        [Required]
        public string UserName { get; set; }

        [Required]
        [MaxLength(11)]
        public string OIB { get; set; }

        [Required]
        public string DatumRodenja { get; set; }

        [Required]
        public string Ime { get; set; }

        [Required]
        public string Prezime { get; set; }


        [Required]
        public string Prebivaliste { get; set; }

        [Required]
        public string Boraviste { get; set; }
    }
}
