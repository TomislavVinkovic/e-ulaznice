using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Threading.Tasks;

namespace EBazeni.Models {
    public class TipZaposlenika {

        [Key]
        public int Id { get; set; }

        [Required]
        [Display(Name = "Naziv tipa zaposlenika")]
        public string Naziv { get; set; }
    }
}
