using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using Microsoft.IdentityModel.Tokens;
using ParklaysBackend.Data;
using ParklaysBackend.Models;
using System.IdentityModel.Tokens.Jwt;
using System.Security.Claims;
using System.Security.Cryptography;
using System.Text;

namespace ParklaysBackend.Controllers
{
    [ApiController]
    [Route("api/[controller]")]
    public class SuperAdminController : ControllerBase
    {
        private readonly AppDbContext _context;
        private readonly IConfiguration _config;

        public SuperAdminController(AppDbContext context, IConfiguration config)
        {
            _context = context;
            _config = config;
        }

        // ❌ REMOVED: Super Admin Register API — internal team will handle this
        // (No register endpoint now)

        // ✅ 1. Login Super Admin (returns JWT)
        [HttpPost("login")]
        public async Task<IActionResult> Login([FromBody] LoginRequest request)
        {
            var admin = await _context.SuperAdmins.FirstOrDefaultAsync(x => x.Email == request.Email);
            if (admin == null) return Unauthorized("Invalid credentials.");

            if (admin.PasswordHash != HashPassword(request.Password))
                return Unauthorized("Invalid credentials.");

            var token = GenerateJwtToken(admin);
            return Ok(new
            {
                message = "Login successful",
                token,
                superAdmin = new { admin.Id, admin.Name, admin.Email, admin.Organization }
            });
        }

        // ✅ 2. Add Admin under Super Admin
        [HttpPost("add-admin")]
        public async Task<IActionResult> AddAdmin([FromBody] Admin admin)
        {
            if (!await _context.SuperAdmins.AnyAsync(x => x.Id == admin.CreatedBy))
                return BadRequest("Invalid Super Admin.");

            if (!await _context.ParkingLots.AnyAsync(x => x.Id == admin.LotId))
                return BadRequest("Invalid Parking Lot.");

            _context.Admins.Add(admin);
            await _context.SaveChangesAsync();

            return Ok(new { message = "Admin added successfully" });
        }

        // ✅ 3. Get all Admins under a Super Admin
        [HttpGet("admins/{superAdminId}")]
        public async Task<IActionResult> GetAdmins(int superAdminId)
        {
            var admins = await _context.Admins
                .Include(a => a.ParkingLot)
                .Where(a => a.CreatedBy == superAdminId)
                .ToListAsync();

            return Ok(admins);
        }

        // 🔒 Helper: Create JWT Token
        private string GenerateJwtToken(SuperAdmin admin)
        {
            var claims = new[]
            {
                new Claim(JwtRegisteredClaimNames.Sub, admin.Email),
                new Claim("superAdminId", admin.Id.ToString()),
                new Claim("name", admin.Name)
            };

            var jwtKey = _config["Jwt:Key"] ?? throw new Exception("JWT Key missing in configuration");

            var key = new SymmetricSecurityKey(Encoding.UTF8.GetBytes(jwtKey));
            var creds = new SigningCredentials(key, SecurityAlgorithms.HmacSha256);

            var token = new JwtSecurityToken(
                issuer: _config["Jwt:Issuer"],
                audience: _config["Jwt:Issuer"],
                claims: claims,
                expires: DateTime.UtcNow.AddHours(8),
                signingCredentials: creds
            );

            return new JwtSecurityTokenHandler().WriteToken(token);
        }

        // 🔑 Helper: hash password using SHA256
        private static string HashPassword(string password)
        {
            using var sha = SHA256.Create();
            var bytes = sha.ComputeHash(Encoding.UTF8.GetBytes(password));
            return Convert.ToBase64String(bytes);
        }

        // DTO: Login request
        public class LoginRequest
        {
            public string Email { get; set; } = string.Empty;
            public string Password { get; set; } = string.Empty;
        }
    }
}
