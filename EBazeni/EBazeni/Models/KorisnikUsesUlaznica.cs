using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using System.Linq;
using System.Threading.Tasks;

namespace EBazeni.Models {
    public class KorisnikUsesUlaznica {

        [Key]
        public Guid Key { get; set; }

        public Guid UlaznicaId { get; set; }
        public string ApplicationUserId { get; set; }

        [Required]
        [ForeignKey("UlaznicaId")]
        public virtual Ulaznica Ulaznica { get; set; }


        [Required]
        [ForeignKey("ApplicationUserId")]
        public virtual ApplicationUser ApplicationUser { get; set; }
    }
}
