// using Microsoft.EntityFrameworkCore;
// using ParklaysBackend.Models;

// namespace ParklaysBackend.Data
// {
//     public class AppDbContext : DbContext
//     {
//         public AppDbContext(DbContextOptions<AppDbContext> options) : base(options) { }

//         public DbSet<ParkingLot> ParkingLots { get; set; }

//         public DbSet<ParkingSlot> ParkingSlots { get; set; }
//         public DbSet<ParkingSession> ParkingSessions { get; set; }

//     }
// }





using Microsoft.EntityFrameworkCore;
using ParklaysBackend.Models;
using NetTopologySuite.Geometries;

namespace ParklaysBackend.Data
{
    public class AppDbContext : DbContext
    {
        public AppDbContext(DbContextOptions<AppDbContext> options)
            : base(options)
        {
        }

        // === DbSets ===
        public DbSet<MasterAdmin> MasterAdmins { get; set; }
        public DbSet<UserProfile> UserProfiles { get; set; }
        public DbSet<ParkingLot> ParkingLots { get; set; }
        public DbSet<ParkingSlot> ParkingSlots { get; set; }
        public DbSet<ParkingSession> ParkingSessions { get; set; }
        public DbSet<SuperAdmin> SuperAdmins { get; set; }
        public DbSet<Admin> Admins { get; set; }

        

        protected override void OnModelCreating(ModelBuilder modelBuilder)
        {
            base.OnModelCreating(modelBuilder);

            // === Table Mappings ===
            modelBuilder.Entity<ParkingLot>().ToTable("parkinglots");
            modelBuilder.Entity<ParkingSlot>().ToTable("parkingslots");
            modelBuilder.Entity<ParkingSession>().ToTable("parkingsessions");
            modelBuilder.Entity<SuperAdmin>().ToTable("superadmins");
            modelBuilder.Entity<Admin>().ToTable("admins");

            // === ParkingLot mapping ===
            modelBuilder.Entity<ParkingLot>(entity =>
            {
                entity.HasKey(e => e.Id);
                entity.Property(e => e.Name).IsRequired();
                entity.Property(e => e.Geom)
                      .HasColumnType("geometry");
            });

            // === ParkingSlot mapping ===
            modelBuilder.Entity<ParkingSlot>(entity =>
            {
                entity.HasKey(e => e.Id);
                entity.Property(e => e.LotId).IsRequired();
                entity.Property(e => e.Geom)
                      .HasColumnType("geometry");
            });

            // === ParkingSession mapping ===
            modelBuilder.Entity<ParkingSession>(entity =>
    {
        entity.ToTable("parkingsessions");

        entity.HasKey(e => e.Id);
        entity.Property(e => e.LotId).HasColumnName("lotid");
        entity.Property(e => e.SlotId).HasColumnName("slotid");
        entity.Property(e => e.SlotNumber).HasColumnName("slotnumber");
        entity.Property(e => e.UserName).HasColumnName("user_name");
        entity.Property(e => e.VehicleType).HasColumnName("vehicle_type");
        entity.Property(e => e.VehicleNumber).HasColumnName("vehicle_number");
        entity.Property(e => e.Email).HasColumnName("email");
        entity.Property(e => e.Phone).HasColumnName("phone");
        entity.Property(e => e.VehicleColor).HasColumnName("vehicle_color");
        entity.Property(e => e.VehicleModel).HasColumnName("vehicle_model");
        entity.Property(e => e.EntryTime).HasColumnName("entry_time");
        entity.Property(e => e.ExitTime).HasColumnName("exit_time");
        entity.Property(e => e.Status).HasColumnName("status").HasMaxLength(20);
        entity.Property(e => e.ScannedBy).HasColumnName("scanned_by");
    });

            // === SuperAdmin mapping ===
            modelBuilder.Entity<SuperAdmin>(entity =>
            {
                entity.HasKey(e => e.Id);
                entity.Property(e => e.Email).IsRequired();
                entity.Property(e => e.PasswordHash).IsRequired();
            });

            // === Admin mapping ===
            modelBuilder.Entity<Admin>(entity =>
            {
                entity.HasKey(e => e.Id);
                entity.HasOne(a => a.ParkingLot)
                      .WithMany()
                      .HasForeignKey(a => a.LotId)
                      .OnDelete(DeleteBehavior.Cascade);

                entity.HasOne(a => a.SuperAdmin)
                      .WithMany()
                      .HasForeignKey(a => a.CreatedBy)
                      .OnDelete(DeleteBehavior.Cascade);
            });
        }
    }
}