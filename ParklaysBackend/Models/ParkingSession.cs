
// using System;
// using System.ComponentModel.DataAnnotations;
// using System.ComponentModel.DataAnnotations.Schema;

// namespace ParklaysBackend.Models
// {
//     [Table("parkingsessions")]
//     public class ParkingSession
//     {
//         [Key]
//         [Column("id")]
//         public int Id { get; set; }

//         [Column("lotid")]
//         public int LotId { get; set; }   // matches DB column name
//         public ParkingLot? ParkingLot { get; set; }  // optional navigation

//         [Column("user_name")]
//         public string UserName { get; set; } = string.Empty;

//         [Column("vehicle_type")]
//         public string VehicleType { get; set; } = string.Empty;

//         [Column("vehicle_number")]
//         public string VehicleNumber { get; set; } = string.Empty;

//         [Column("email")]
//         public string Email { get; set; } = string.Empty;

//         [Column("phone")]
//         public string Phone { get; set; } = string.Empty;

//         [Column("vehicle_color")]
//         public string VehicleColor { get; set; } = string.Empty;

//         [Column("vehicle_model")]
//         public string VehicleModel { get; set; } = string.Empty;

//         [Column("slotnumber")]
//         public int SlotNumber { get; set; }

//         [Column("entry_time")]
//         public DateTime EntryTime { get; set; } = DateTime.UtcNow;

//         [Column("exit_time")]
//         public DateTime? ExitTime { get; set; }

//         [Column("status")]
//         public string Status { get; set; } = "active";

//         [Column("scanned_by")]
//         public int? ScannedBy { get; set; }
//     }
// }





// using System;
// using System.ComponentModel.DataAnnotations;
// using System.ComponentModel.DataAnnotations.Schema;

// namespace ParklaysBackend.Models
// {
//     [Table("parkingsessions")]
//     public class ParkingSession
//     {
//         [Key]
//         [Column("id")]
//         public int Id { get; set; }

//         // -------------------------
//         // Parking Lot (FK)
//         // -------------------------
//         [Column("lotid")]
//         public int LotId { get; set; }
//         public ParkingLot? ParkingLot { get; set; }

//         [NotMapped]  // because DB no longer has slotnumber
//         public long SlotNumber { get; set; }

//         // -------------------------
//         // Slot (FK)  ✅ REQUIRED
//         // -------------------------
//         [Column("slotid")]
//         public long SlotId { get; set; }
//         public ParkingSlot? Slot { get; set; }   // Navigation Property

//         // -------------------------
//         // User & Vehicle Details
//         // -------------------------
//         [Column("user_name")]
//         public string UserName { get; set; } = string.Empty;

//         [Column("vehicle_type")]
//         public string VehicleType { get; set; } = string.Empty;

//         [Column("vehicle_number")]
//         public string VehicleNumber { get; set; } = string.Empty;

//         [Column("email")]
//         public string Email { get; set; } = string.Empty;

//         [Column("phone")]
//         public string Phone { get; set; } = string.Empty;

//         [Column("vehicle_color")]
//         public string VehicleColor { get; set; } = string.Empty;

//         [Column("vehicle_model")]
//         public string VehicleModel { get; set; } = string.Empty;

//         // -------------------------
//         // Time
//         // -------------------------
//         [Column("entry_time")]
//         public DateTime EntryTime { get; set; } = DateTime.UtcNow;

//         [Column("exit_time")]
//         public DateTime? ExitTime { get; set; }

//         // -------------------------
//         // Status
//         // -------------------------
//         [Column("status")]
//         public string Status { get; set; } = "active";

//         [Column("scanned_by")]
//         public int? ScannedBy { get; set; }
//     }
// }







using System;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace ParklaysBackend.Models
{
    [Table("parkingsessions")]
    public class ParkingSession
{
    [Key]
    [Column("id")]
    public int Id { get; set; }

    [Column("lotid")]
    public int LotId { get; set; }

    [ForeignKey("LotId")]        // ✅ this tells EF which FK column to use
    public ParkingLot? ParkingLot { get; set; }

    [Column("slotnumber")]
    public int SlotNumber { get; set; }

    [Column("slotid")]
    public long SlotId { get; set; }

    [ForeignKey("SlotId")]       // ✅ maps Slot navigation
    public ParkingSlot? Slot { get; set; }

    [Column("user_name")]
    public string UserName { get; set; } = string.Empty;

    [Column("vehicle_type")]
    public string VehicleType { get; set; } = string.Empty;

    [Column("vehicle_number")]
    public string VehicleNumber { get; set; } = string.Empty;

    [Column("email")]
    public string Email { get; set; } = string.Empty;

    [Column("phone")]
    public string Phone { get; set; } = string.Empty;

    [Column("vehicle_color")]
    public string VehicleColor { get; set; } = string.Empty;

    [Column("vehicle_model")]
    public string VehicleModel { get; set; } = string.Empty;

    [Column("entry_time")]
    public DateTime EntryTime { get; set; } = DateTime.UtcNow;

    [Column("exit_time")]
    public DateTime? ExitTime { get; set; }

    [Column("status")]
    public string Status { get; set; } = "active";
    [Column("scanned_by")]
    public int? ScannedBy { get; set; }
    }
}

