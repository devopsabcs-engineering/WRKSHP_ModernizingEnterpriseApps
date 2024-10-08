﻿// <auto-generated />
using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Infrastructure;
using Microsoft.EntityFrameworkCore.Metadata;
using Microsoft.EntityFrameworkCore.Storage.ValueConversion;
using SampleWebApplicationCore.Data;

#nullable disable

namespace SampleWebApplicationCore.Migrations
{
    [DbContext(typeof(SampleWebApplicationCoreContext))]
    partial class SampleWebApplicationCoreContextModelSnapshot : ModelSnapshot
    {
        protected override void BuildModel(ModelBuilder modelBuilder)
        {
#pragma warning disable 612, 618
            modelBuilder
                .HasAnnotation("ProductVersion", "8.0.8")
                .HasAnnotation("Relational:MaxIdentifierLength", 128);

            SqlServerModelBuilderExtensions.UseIdentityColumns(modelBuilder);

            modelBuilder.Entity("SampleWebApplicationCore.Models.AccessLog", b =>
                {
                    b.Property<int>("VisitId")
                        .ValueGeneratedOnAdd()
                        .HasColumnType("int");

                    SqlServerPropertyBuilderExtensions.UseIdentityColumn(b.Property<int>("VisitId"));

                    b.Property<string>("AccessDate")
                        .IsRequired()
                        .HasColumnType("nvarchar(max)");

                    b.Property<string>("ComputerName")
                        .IsRequired()
                        .HasColumnType("nvarchar(max)");

                    b.Property<string>("EnvironmentName")
                        .IsRequired()
                        .HasColumnType("nvarchar(max)");

                    b.Property<string>("PageName")
                        .IsRequired()
                        .HasColumnType("nvarchar(max)");

                    b.Property<string>("VersionNumber")
                        .IsRequired()
                        .HasColumnType("nvarchar(max)");

                    b.HasKey("VisitId");

                    b.ToTable("AccessLog");
                });
#pragma warning restore 612, 618
        }
    }
}
