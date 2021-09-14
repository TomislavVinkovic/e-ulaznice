using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace EBazeni.Models.DTOs.Responses {
    public class OvjeraUlazniceResponse {
        public string ImeKorisnika { get; set; }
        public string PrezimeKorisnika { get; set; }
        public DateTime EndDate { get; set; }
        public bool isValid { get; set; }
        public bool AlreadyVisited { get; set; }
    }
}
