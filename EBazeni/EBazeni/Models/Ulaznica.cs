using EBazeni.Utilities.ValidationAttributes;
using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using System.Linq;
using System.Threading.Tasks;

namespace EBazeni.Models {
    public class Ulaznica {
        [Key]
        public Guid BrojUlaznice { get; set; }

        [Required]
        public int TipUlazniceId { get; set; }

        [ForeignKey("TipUlazniceId")]
        [Display(Name="Tip ulaznice")]
        public virtual TipUlaznice TipUlaznice { get; set; }

        [Required]
        [Display(Name = "Kraj valjanosti ulaznice")]
        [DateTimeRange]
        [DataType(DataType.Date)]
        public DateTime EndDate { get; set; }

    }
}
