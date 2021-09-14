using Microsoft.EntityFrameworkCore.Migrations;
using System;

namespace EBazeni.Migrations
{
    public partial class changedKorisnikUsesUlaznicaPK2 : Migration
    {
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.CreateTable(
                name: "KorisnikUsesUlaznica",
                columns: table => new {
                    Key = table.Column<Guid>(type: "uniqueidentifier", nullable: false),
                    UlaznicaId = table.Column<Guid>(type: "uniqueidentifier", nullable: false),
                    ApplicationUserId = table.Column<string>(type: "nvarchar(450)", nullable: false)
                },
                constraints: table => {
                    table.PrimaryKey("PK_KorisnikUsesUlaznica", x => x.Key);
                    table.ForeignKey(
                        name: "FK_KorisnikUsesUlaznica_AspNetUsers_ApplicationUserId",
                        column: x => x.ApplicationUserId,
                        principalTable: "AspNetUsers",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Cascade);
                    table.ForeignKey(
                        name: "FK_KorisnikUsesUlaznica_Ulaznice_UlaznicaId",
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
