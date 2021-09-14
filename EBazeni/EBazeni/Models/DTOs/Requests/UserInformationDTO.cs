using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Threading.Tasks;

namespace EBazeni.Models.DTOs.Requests {
    public class UserInformationDTO {
        public string Email { get; set; }

        public string UserName { get; set; }


        [MaxLength(11)]
        public string OIB { get; set; }


        public string DatumRodenja { get; set; }


        public string Ime { get; set; }


        public string Prezime { get; set; }



        public string Prebivaliste { get; set; }


        public string Boraviste { get; set; }
    }
}
