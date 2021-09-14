using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using System.Linq;
using System.Threading.Tasks;

namespace EBazeni.Models {
    public class Zaposlenik {


        [Key]
        public int Id { get; set; }

        public int TipZaposlenikaId { get; set; }
        public string ApplicationUserId { get; set; }

        [Required]
        [ForeignKey("TipZaposlenikaId")]
        [Display(Name = "Tip zaposlenika")]
        public virtual TipZaposlenika TipZaposlenika { get; set; }

        [Required]
        [ForeignKey("ApplicationUserId")]
        public virtual ApplicationUser ApplicationUser { get; set; }
    }
}
