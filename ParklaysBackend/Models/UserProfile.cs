using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace ParklaysBackend.Models
{
    [Table("userprofiles")]
    public class UserProfile
    {
        [Key]
        [Column("id")]
        public int Id { get; set; }

        [Required]
        [Column("name")]
        public string Name { get; set; } = string.Empty;

        [Required]
        [Column("vehicle_type")]
        public string VehicleType { get; set; } = string.Empty;

        [Required]
        [Column("vehicle_number")]
        public string VehicleNumber { get; set; } = string.Empty;

        [Column("address")]
        public string? Address { get; set; }
        [Column("email")]
        public string? Email { get; set; }
        [Column("phone")]
        public string? PhoneNumber { get; set; }

        [Column("vehicle_color")]
        public string? VehicleColor { get; set; }
        [Column("vehicle_model")]
        public string? VehicleModel { get; set; }
    }
}
