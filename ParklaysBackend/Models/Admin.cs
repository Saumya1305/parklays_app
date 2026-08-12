// using System;
// using System.ComponentModel.DataAnnotations;
// using System.ComponentModel.DataAnnotations.Schema;

// namespace ParklaysBackend.Models
// {
//     [Table("admins")]
//     public class Admin
//     {
//         [Column("id")]
//         public int Id { get; set; }

//         [Required]
//         [Column("name")]
//         public string Name { get; set; } = string.Empty;

//         [Column("dob")]

//         public DateTime? Dob { get; set; }

//         [Column("email")]
//         public string? Email { get; set; }

//         [Required]
//         [Column("phone")]
//         public string Phone { get; set; } = string.Empty;

//         [ForeignKey("ParkingLot")]
//         public int LotId { get; set; }
//         public ParkingLot? ParkingLot { get; set; }

//         public bool IsActive { get; set; } = true;

//         [ForeignKey("SuperAdmin")]
//         public int CreatedBy { get; set; }
//         public SuperAdmin? SuperAdmin { get; set; }

//         public DateTime CreatedAt { get; set; } = DateTime.UtcNow;
//     }
// }





using System;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
namespace ParklaysBackend.Models
{
    [Table("admins")]
    public class Admin
    {
        [Key]
        [Column("id")]
        public int Id { get; set; }

        [Required]
        [Column("name")]
        public string Name { get; set; } = string.Empty;

        [Column("dob")]
        public DateTime? Dob { get; set; }

        [Column("email")]
        public string? Email { get; set; }

        [Required]
        [Column("phone")]
        public string Phone { get; set; } = string.Empty;

        // FK → parkinglots(id)
        [Column("lotid")]
        public int? LotId { get; set; }
        public ParkingLot? ParkingLot { get; set; }

        [Column("is_active")]
        public bool IsActive { get; set; } = true;

        // FK → superadmins(id)
        [Column("created_by")]
        public int CreatedBy { get; set; }
        public SuperAdmin? SuperAdmin { get; set; }

        [Column("created_at")]
        public DateTime CreatedAt { get; set; } = DateTime.UtcNow;
    }
}
