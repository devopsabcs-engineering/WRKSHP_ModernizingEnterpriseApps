using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Microsoft.EntityFrameworkCore;
using SampleWebApplicationCoreDemo.Models;

namespace SampleWebApplicationCoreDemo.Data
{
    public class SampleWebApplicationCoreDemoContext : DbContext
    {
        public SampleWebApplicationCoreDemoContext (DbContextOptions<SampleWebApplicationCoreDemoContext> options)
            : base(options)
        {
            // ensure database is created
            Database.EnsureCreated();
            // ensure database is migrated
            Database.Migrate();
        }

        public DbSet<SampleWebApplicationCoreDemo.Models.AccessLog> AccessLog { get; set; } = default!;
    }
}
