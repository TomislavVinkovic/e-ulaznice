using Microsoft.AspNetCore.Identity;
using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Threading.Tasks;

namespace EBazeni.Models {
    public class ApplicationUser : IdentityUser{
        [Required]
        public string Ime { get; set; }

        [Required]
        public string Prezime { get; set; }

        [Required]
        [MaxLength(11)]
        [Display(Name = "OIB (Osobni Identifikacijski Broj)")]
        public string OIB { get; set; }

        [Required]
        [Display(Name = "Datum rođenja")]
        public DateTime DatumRodenja { get; set; }

        [Required]
        [Display(Name = "Mjesto prebivališta")]
        public string Prebivaliste { get; set; }

        [Required]
        [Display(Name = "Mjesto boravišta")]
        public string Boraviste { get; set; }
    }
}
