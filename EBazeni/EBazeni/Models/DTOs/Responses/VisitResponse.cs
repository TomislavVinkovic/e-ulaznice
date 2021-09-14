using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace EBazeni.Models.DTOs.Responses {
    public class VisitResponse {
        public bool IsRevoked { get; set; }
        public string ErrorMessage { get; set; }
    }
}
