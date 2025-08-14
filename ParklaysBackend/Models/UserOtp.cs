using System;

namespace ParklaysBackend.Models
{
    public class UserOtp
    {
        public int Id { get; set; }
        public string PhoneNumber { get; set; } = string.Empty;
        public string OtpCode { get; set; } = string.Empty;
        public DateTime CreatedAt { get; set; } = DateTime.UtcNow;
        public bool IsVerified { get; set; } = false;
    }
}
