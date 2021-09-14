using Microsoft.EntityFrameworkCore.Migrations;
using System;

namespace EBazeni.Migrations
{
    public partial class UlaznicaModelChanged : Migration
    {
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.CreateTable(
                name: "Ulaznice",
                columns: table => new {
                    BrojUlaznice = table.Column<Guid>(type: "uniqueidentifier", nullable: false),
                    TipUlazniceId = table.Column<int>(type: "int", nullable: false),
                    EndDate = table.Column<DateTime>(type: "datetime2", nullable: false)
                },
                constraints: table => {
                    table.PrimaryKey("PK_Ulaznice", x => x.BrojUlaznice);
                    table.ForeignKey(
                        name: "FK_Ulaznice_TipoviUlaznica_TipUlazniceId",
                        column: x => x.TipUlazniceId,
                        principalTable: "TipoviUlaznica",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Cascade);
                });

            migrationBuilder.CreateTable(
                name: "KorisnikUsesUlaznica",
                columns: table => new {
                    Id = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    UlaznicaId = table.Column<Guid>(type: "uniqueidentifier", nullable: false),
                    ApplicationUserId = table.Column<string>(type: "nvarchar(450)", nullable: false)
                },
                constraints: table => {
                    table.PrimaryKey("PK_KorisnikUsesUlaznica", x => x.Id);
                    table.ForeignKey(
                        name: "FK_KorisnikUsesUlaznica_AspNetUsers_ApplicationUserId",
                        column: x => x.ApplicationUserId,
                        principalTable: "AspNetUsers",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Cascade);
                    table.ForeignKey(
                        name: "FK_KorisnikUsesUlaznica_Ulaznice_BrojUlaznice",
                        column: x => x.UlaznicaId,
                        principalTable: "Ulaznice",
                        principalColumn: "BrojUlaznice",
                        onDelete: ReferentialAction.Cascade);
                });
        }

        protected override void Down(MigrationBuilder migrationBuilder)
        {

        }
    }
}
