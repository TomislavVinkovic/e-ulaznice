using Microsoft.EntityFrameworkCore.Migrations;

namespace EBazeni.Migrations
{
    public partial class Initial2 : Migration
    {
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.CreateTable(
                name: "Zahtjevi",
                columns: table => new
                {
                    Id = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    ApplicationUserZahtjevId = table.Column<string>(type: "nvarchar(450)", nullable: true),
                    TipUlazniceZahtjevId = table.Column<int>(type: "int", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_Zahtjevi", x => x.Id);
                    table.ForeignKey(
                        name: "FK_Zahtjevi_AspNetUsers_ApplicationUserZahtjevId",
                        column: x => x.ApplicationUserZahtjevId,
                        principalTable: "AspNetUsers",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Restrict);
                    table.ForeignKey(
                        name: "FK_Zahtjevi_TipoviUlaznica_TipUlazniceZahtjevId",
                        column: x => x.TipUlazniceZahtjevId,
                        principalTable: "TipoviUlaznica",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Cascade);
                });

            migrationBuilder.CreateIndex(
                name: "IX_Zahtjevi_ApplicationUserZahtjevId",
                table: "Zahtjevi",
                column: "ApplicationUserZahtjevId");

            migrationBuilder.CreateIndex(
                name: "IX_Zahtjevi_TipUlazniceZahtjevId",
                table: "Zahtjevi",
                column: "TipUlazniceZahtjevId");
        }

        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropTable(
                name: "Zahtjevi");
        }
    }
}
