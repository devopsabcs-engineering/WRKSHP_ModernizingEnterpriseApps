using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Microsoft.EntityFrameworkCore;
using SampleWebApplicationCore.Models;

namespace SampleWebApplicationCore.Data
{
    public class SampleWebApplicationCoreContext : DbContext
    {
        public SampleWebApplicationCoreContext (DbContextOptions<SampleWebApplicationCoreContext> options)
            : base(options)
        {
            Database.EnsureCreated();
        }

        public DbSet<SampleWebApplicationCore.Models.AccessLog> AccessLog { get; set; } = default!;
    }
}
