using Microsoft.EntityFrameworkCore.Migrations;

namespace EBazeni.Migrations
{
    public partial class zahtjevuserunique : Migration
    {
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropIndex(
                name: "IX_Zahtjevi_ApplicationUserZahtjevId",
                table: "Zahtjevi");

            migrationBuilder.CreateIndex(
                name: "IX_Zahtjevi_ApplicationUserZahtjevId",
                table: "Zahtjevi",
                column: "ApplicationUserZahtjevId",
                unique: true,
                filter: "[ApplicationUserZahtjevId] IS NOT NULL");
        }

        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropIndex(
                name: "IX_Zahtjevi_ApplicationUserZahtjevId",
                table: "Zahtjevi");

            migrationBuilder.CreateIndex(
                name: "IX_Zahtjevi_ApplicationUserZahtjevId",
                table: "Zahtjevi",
                column: "ApplicationUserZahtjevId");
        }
    }
}
