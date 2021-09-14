using Microsoft.AspNetCore.Mvc.Rendering;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace EBazeni.Models.ViewModels {
    public class UlaznicaVM {
        public Zahtjev Zahtjev { get; set; }
        public KorisnikUsesUlaznica KorisnikUsesUlaznica { get; set; }
        public List<SelectListItem> TipoviUlaznica { get; set; }
        public List<SelectListItem> ApplicationUsers { get; set; }
    }
}
