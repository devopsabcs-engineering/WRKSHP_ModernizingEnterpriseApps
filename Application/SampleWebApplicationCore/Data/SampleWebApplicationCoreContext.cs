using Microsoft.EntityFrameworkCore;

namespace SampleWebApplicationCore.Data
{
    public class SampleWebApplicationCoreContext : DbContext
    {
        public SampleWebApplicationCoreContext(DbContextOptions<SampleWebApplicationCoreContext> options)
            : base(options)
        {
            Database.EnsureCreated();
        }

        public DbSet<SampleWebApplicationCore.Models.AccessLog> AccessLog { get; set; } = default!;
    }
}
