using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace SampleWebApplicationCore.Migrations
{
    /// <inheritdoc />
    public partial class AddedVersionNumber : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.AddColumn<string>(
                name: "VersionNumber",
                table: "AccessLog",
                type: "nvarchar(max)",
                nullable: false,
                defaultValue: "");
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropColumn(
                name: "VersionNumber",
                table: "AccessLog");
        }
    }
}
