using EBazeni.Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace EBazeni.Configuration {
    public class AuthResult {
        public string Token { get; set; }

        public string RefreshToken { get; set; }

        public bool Success { get; set; }

        public List<string> Errors { get; set; }

        public ApplicationUser User { get; set; }

        public string Role { get; set; }

        public bool RefreshTokenExpired { get; set; }
    }
}
