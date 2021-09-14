using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace EBazeni.Models.DTOs.Responses {
    public class KreacijaUlazniceResponse {
        public bool IsSuccessful { get; set; }
        public List<string> Errors { get; set; }
    }
}
