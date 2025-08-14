// using Microsoft.AspNetCore.Mvc;
// using Microsoft.IdentityModel.Tokens;
// using ParklaysBackend.Data;
// using ParklaysBackend.Models;
// using System.IdentityModel.Tokens.Jwt;
// using System.Security.Claims;
// using System.Text;

// namespace ParklaysBackend.Controllers
// {
//     [ApiController]
//     [Route("api/[controller]")]
//     public class OtpController : ControllerBase
//     {
//         private readonly AppDbContext _context;
//         private readonly IConfiguration _config;

//         public OtpController(AppDbContext context, IConfiguration config)
//         {
//             _context = context;
//             _config = config;
//         }

//         // Endpoint to send OTP
//         [HttpPost("send")]
// public async Task<IActionResult> SendOtp([FromBody] SendOtpRequest request)

// {
//     var otp = new Random().Next(100000, 999999).ToString();

//     var userOtp = new UserOtp
//     {
//         PhoneNumber = request.PhoneNumber,
//         OtpCode = otp,
//         CreatedAt = DateTime.UtcNow,
//         IsVerified = false
//     };

//     _context.UserOtps.Add(userOtp);
//     await _context.SaveChangesAsync();

//     // Simulate SMS sending
//     Console.WriteLine($"[Mock OTP] Sent to {request.PhoneNumber}: {otp}");

//     return Ok(new { message = "OTP sent successfully" });
// }

//         // Endpoint to verify OTP and return JWT token
//         [HttpPost("verify")]
// public async Task<IActionResult> VerifyOtp([FromBody] OtpVerificationDto dto)
// {
//     // Use whichever field is provided
//     var providedOtp = !string.IsNullOrWhiteSpace(dto.Otp) ? dto.Otp : dto.OtpCode;

//     if (string.IsNullOrWhiteSpace(providedOtp))
//         return BadRequest(new { message = "OTP is required." });

//     var otpRecord = _context.UserOtps
//         .OrderByDescending(x => x.CreatedAt)
//         .FirstOrDefault(x =>
//             x.PhoneNumber == dto.PhoneNumber &&
//             x.OtpCode == providedOtp &&
//             !x.IsVerified);

//     if (otpRecord == null)
//         return BadRequest(new { message = "Invalid or expired OTP." });

//     otpRecord.IsVerified = true;
//     await _context.SaveChangesAsync();

//     var token = GenerateJwtToken(dto.PhoneNumber);
//     return Ok(new { message = "OTP verified successfully", token });
// }

//         // Helper method to generate JWT token
//         private string GenerateJwtToken(string phoneNumber)
//         {
//             var claims = new[]
//             {
//                 new Claim(ClaimTypes.Name, phoneNumber)
//             };

//             var key = new SymmetricSecurityKey(Encoding.UTF8.GetBytes(_config["Jwt:Key"]!));
//             var creds = new SigningCredentials(key, SecurityAlgorithms.HmacSha256);

//             var token = new JwtSecurityToken(
//                 issuer: _config["Jwt:Issuer"],
//                 audience: _config["Jwt:Audience"],
//                 claims: claims,
//                 expires: DateTime.UtcNow.AddHours(1),
//                 signingCredentials: creds
//             );

//             return new JwtSecurityTokenHandler().WriteToken(token);
//         }
//     }
// }



using Microsoft.AspNetCore.Mvc;
using Microsoft.IdentityModel.Tokens;
using ParklaysBackend.Data;
using ParklaysBackend.Models;
using System.IdentityModel.Tokens.Jwt;
using System.Security.Claims;
using System.Text;

namespace ParklaysBackend.Controllers
{
    [ApiController]
    [Route("api/[controller]")]
    public class OtpController : ControllerBase
    {
        private readonly AppDbContext _context;
        private readonly IConfiguration _config;

        public OtpController(AppDbContext context, IConfiguration config)
        {
            _context = context;
            _config = config;
        }

        // Mock OTP sender
        [HttpPost("send")]
public async Task<IActionResult> SendOtp([FromBody] SendOtpRequest request)
{
    if (string.IsNullOrWhiteSpace(request.PhoneNumber))
        return BadRequest(new { message = "Phone number is required" });

    // Always generate a new OTP
    var otp = new Random().Next(100000, 999999).ToString();

    var userOtp = new UserOtp
    {
        PhoneNumber = request.PhoneNumber,
        OtpCode = otp,
        CreatedAt = DateTime.UtcNow,
        IsVerified = false
    };

    _context.UserOtps.Add(userOtp);
    await _context.SaveChangesAsync();

    // Mock "sending" OTP
    Console.WriteLine($"[Mock OTP] Sent to {request.PhoneNumber}: {otp}");

    // Include OTP in response (for Flutter debug)
    return Ok(new
    {
        message = "OTP sent successfully (mock mode)",
        otp = otp // <-- added for testing
    });
}


        // OTP verification
        [HttpPost("verify")]
        public async Task<IActionResult> VerifyOtp([FromBody] OtpVerificationDto dto)
        {
            var otpRecord = _context.UserOtps
                .OrderByDescending(x => x.CreatedAt)
                .FirstOrDefault(x =>
                    x.PhoneNumber == dto.PhoneNumber &&
                    x.OtpCode == dto.Otp &&
                    !x.IsVerified);

            if (otpRecord == null)
                return BadRequest(new { message = "Invalid or expired OTP." });

            otpRecord.IsVerified = true;
            await _context.SaveChangesAsync();

            var token = GenerateJwtToken(dto.PhoneNumber);
            return Ok(new { message = "OTP verified successfully", token });
        }

        // JWT generator
        private string GenerateJwtToken(string phoneNumber)
        {
            var claims = new[]
            {
                new Claim(ClaimTypes.Name, phoneNumber)
            };

            var key = new SymmetricSecurityKey(Encoding.UTF8.GetBytes(_config["Jwt:Key"]!));
            var creds = new SigningCredentials(key, SecurityAlgorithms.HmacSha256);

            var token = new JwtSecurityToken(
                issuer: _config["Jwt:Issuer"],
                audience: _config["Jwt:Audience"],
                claims: claims,
                expires: DateTime.UtcNow.AddHours(1),
                signingCredentials: creds
            );

            return new JwtSecurityTokenHandler().WriteToken(token);
        }
    }
}

