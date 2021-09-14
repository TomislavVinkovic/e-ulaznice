using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

//Datoteka u kojoj se nalaze web konstante

namespace EBazeni {
    public class WC {
        public const string AdminRole = "Admin";
        public const string ZaposlenikRole = "Zaposlenik";
        public const string KupacRole = "Kupac";
        public static readonly List<string> OpcinskaNaselja = new List<string>() { "Kneževi Vinogradi", "Karanac", "Kamenac", "Suza", "Zmajevac", "Mirkovac" };
    }
}
