using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using System.Linq;
using System.Threading.Tasks;

namespace EBazeni.Models {
    public class Visit {

        [Key]
        public int Id { get; set; }

        [Required]
        [DataType(DataType.Date)]
        public DateTime DateOfEntry { get; set; }

        public Guid KorisnikUsesUlaznicaId { get; set; }

        [Required]
        [ForeignKey("KorisnikUsesUlaznicaId")]
        public virtual KorisnikUsesUlaznica KorisnikUsesUlaznica { get; set; }
    }
}
