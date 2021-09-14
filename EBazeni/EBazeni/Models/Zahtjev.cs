using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using System.Linq;
using System.Threading.Tasks;

namespace EBazeni.Models {
    public class Zahtjev {
        [Key]
        public int Id { get; set; }

        public string ApplicationUserZahtjevId { get; set; }
        public int TipUlazniceZahtjevId { get; set; }

        [ForeignKey("TipUlazniceZahtjevId")]
        public virtual TipUlaznice TipUlazniceForZahtjev { get; set; }


        [ForeignKey("ApplicationUserZahtjevId")]
        public virtual ApplicationUser ApplicationUserForZahtjev { get; set; }
    }
}
