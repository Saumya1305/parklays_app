using Microsoft.EntityFrameworkCore;
using ParklaysBackend.Models;

namespace ParklaysBackend.Data
{
    public class AppDbContext : DbContext
    {
        public AppDbContext(DbContextOptions<AppDbContext> options) : base(options) { }

        public DbSet<UserOtp> UserOtps { get; set; }
    }
}
