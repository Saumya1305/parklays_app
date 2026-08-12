using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace ParklaysBackend.Migrations
{
    /// <inheritdoc />
    public partial class FixParkingSessionFK : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            // migrationBuilder.DropForeignKey(
            //     name: "FK_parkingsessions_parkinglots_ParkingLotId",
            //     table: "parkingsessions");

            // migrationBuilder.DropIndex(
            //     name: "IX_parkingsessions_ParkingLotId",
            //     table: "parkingsessions");

            // migrationBuilder.DropColumn(
            //     name: "ParkingLotId",
            //     table: "parkingsessions");

            migrationBuilder.CreateIndex(
                name: "IX_parkingsessions_lotid",
                table: "parkingsessions",
                column: "lotid");

            migrationBuilder.AddForeignKey(
                name: "FK_parkingsessions_parkinglots_lotid",
                table: "parkingsessions",
                column: "lotid",
                principalTable: "parkinglots",
                principalColumn: "id",
                onDelete: ReferentialAction.Cascade);
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropForeignKey(
                name: "FK_parkingsessions_parkinglots_lotid",
                table: "parkingsessions");

            migrationBuilder.DropIndex(
                name: "IX_parkingsessions_lotid",
                table: "parkingsessions");

            // migrationBuilder.AddColumn<int>(
            //     name: "ParkingLotId",
            //     table: "parkingsessions",
            //     type: "integer",
            //     nullable: true);

            // migrationBuilder.CreateIndex(
            //     name: "IX_parkingsessions_ParkingLotId",
            //     table: "parkingsessions",
            //     column: "ParkingLotId");

            // migrationBuilder.AddForeignKey(
            //     name: "FK_parkingsessions_parkinglots_ParkingLotId",
            //     table: "parkingsessions",
            //     column: "ParkingLotId",
            //     principalTable: "parkinglots",
            //     principalColumn: "id");
        }
    }
}
