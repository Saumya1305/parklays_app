namespace ParklaysBackend.Models
{
    public class OtpVerificationDto
    {
        public string PhoneNumber { get; set; } = string.Empty;

        // Accepts either "otp" or "otpCode" from JSON
        [System.Text.Json.Serialization.JsonPropertyName("otp")]
        public string Otp { get; set; } = string.Empty;

        [System.Text.Json.Serialization.JsonPropertyName("otpCode")]
        public string? OtpCode { get; set; }
    }
}
