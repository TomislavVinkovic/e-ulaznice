using EBazeni.Models;
using Microsoft.AspNetCore.Identity.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore;
using System;
using System.Collections.Generic;
using System.Text;

namespace EBazeni.Data {
    public class ApplicationDbContext : IdentityDbContext {
        public ApplicationDbContext(DbContextOptions<ApplicationDbContext> options) : base(options) {

        }

        //public DbSet<ZaposlenikUser> Zaposlenici { get; set; }
        public DbSet<ApplicationUser> ApplicationUsers { get; set; }
        public DbSet<TipZaposlenika> TipoviZaposlenika { get; set; }
        public DbSet<Ulaznica> Ulaznice { get; set; }
        public DbSet<TipUlaznice> TipoviUlaznica { get; set; }
        public DbSet<KorisnikUsesUlaznica> KorisnikUsesUlaznica { get; set; }
        public DbSet<Zaposlenik> Zaposlenici { get; set; }
        public DbSet<Zahtjev> Zahtjevi { get; set; }
        public DbSet<RefreshToken> RefreshTokens { get; set; }
        public DbSet<Visit> Visits { get; set; }

        /*
        protected override void OnConfiguring(DbContextOptionsBuilder optionsBuilder) {
            optionsBuilder.EnableSensitiveDataLogging();
        }
        */
        protected override void OnModelCreating(ModelBuilder modelBuilder) {
            base.OnModelCreating(modelBuilder);
            modelBuilder.Entity<Zahtjev>()
                .HasIndex(o => o.ApplicationUserZahtjevId).IsUnique();
        }

    }


}
