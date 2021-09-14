using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace EBazeni.Models.ViewModels {
    public class ZaposlenikVM {
        public IEnumerable<Zaposlenik> Zaposlenici { get; set; }
        public IEnumerable<ApplicationUser> ApplicationUsers { get; set; }
    }
}
