using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace EBazeni.Models.DTOs.Responses {
    public class UlaznicaResponse {
        public int KorisniciUlaznice { get; set; }
        public Ulaznica UlaznicaWithProperties { get; set; }
        public KorisnikUsesUlaznica KorisnikUsesUlaznica { get; set; }
    }
}
