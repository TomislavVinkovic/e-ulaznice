using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Threading.Tasks;

namespace EBazeni.Models {
    public class TipUlaznice {

        [Key]
        public int Id { get; set; }

        [Required]
        [Display(Name = "Naziv tipa ulaznice")]
        public string Ime { get; set; }

        [Required]
        [Range(1, double.MaxValue)]
        [Display(Name = "Cijena ulaznice")]
        public double Cijena { get; set; }

        [Required]
        [Range(1, int.MaxValue)]
        [Display(Name = "Maksimalan broj korisnika ulaznice?")]
        public int MaksimalanBrojKorisnika { get; set; }
    }
}
