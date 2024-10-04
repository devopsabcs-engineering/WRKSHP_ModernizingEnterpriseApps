using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace SampleWebApplicationCore.Migrations
{
    /// <inheritdoc />
    public partial class EnvironmentNameadded : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.AddColumn<string>(
                name: "EnvironmentName",
                table: "AccessLog",
                type: "nvarchar(max)",
                nullable: false,
                defaultValue: "");
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropColumn(
                name: "EnvironmentName",
                table: "AccessLog");
        }
    }
}
