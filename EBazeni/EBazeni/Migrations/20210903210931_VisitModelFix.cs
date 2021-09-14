using Microsoft.EntityFrameworkCore.Migrations;
using System;

namespace EBazeni.Migrations
{
    public partial class VisitModelFix : Migration
    {
        protected override void Up(MigrationBuilder migrationBuilder) {
            migrationBuilder.CreateTable(
                name: "Visits",
                columns: table => new {
                    Id = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    DateOfEntry = table.Column<DateTime>(type: "datetime2", nullable: false),
                    KorisnikUsesUlaznicaId = table.Column<Guid>(type: "uniqueidentifier", nullable: false)
                },
                constraints: table => {
                    table.PrimaryKey("PK_Visits", x => x.Id);
                    table.ForeignKey(
                        name: "FK_Visits_KorisnikUsesUlaznica_KorisnikUsesUlaznicaId",
                        column: x => x.KorisnikUsesUlaznicaId,
                        principalTable: "KorisnikUsesUlaznica",
                        principalColumn: "Key",
                        onDelete: ReferentialAction.Cascade);
                });

            migrationBuilder.CreateIndex(
                name: "IX_Visits_KorisnikUsesUlaznicaId",
                table: "Visits",
                column: "KorisnikUsesUlaznicaId");
        }

        protected override void Down(MigrationBuilder migrationBuilder) {
            migrationBuilder.DropTable(
                name: "Visits");
        }
    }
}
