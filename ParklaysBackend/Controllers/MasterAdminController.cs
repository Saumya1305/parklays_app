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
    public class MasterAdminController : ControllerBase
    {
        private readonly AppDbContext _context;
        private readonly IConfiguration _config;

        public MasterAdminController(AppDbContext context, IConfiguration config)
        {
            _context = context;
            _config = config;
        }

        // ============================================================
        // ✅ 1. LOGIN MASTER ADMIN (Email + Password → JWT)
        // ============================================================
        [HttpPost("login")]
        public async Task<IActionResult> Login([FromBody] LoginRequest request)
        {
            var master = await _context.MasterAdmins
                .FirstOrDefaultAsync(x => x.Email == request.Email);

            if (master == null)
                return Unauthorized(new { message = "Invalid credentials." });

            if (master.PasswordHash != HashPassword(request.Password))
                return Unauthorized(new { message = "Invalid credentials." });

            var token = GenerateJwtToken(master);

            return Ok(new
            {
                message = "Login successful",
                token,
                masterAdmin = new
                {
                    master.Id,
                    master.Name,
                    master.Email
                }
            });
        }

        // ============================================================
        // ✅ 2. CREATE SUPER ADMIN
        // ============================================================
        [HttpPost("superadmin/create")]
        public async Task<IActionResult> CreateSuperAdmin([FromBody] SuperAdmin admin)
        {
            if (await _context.SuperAdmins.AnyAsync(x => x.Email == admin.Email))
                return BadRequest(new { message = "Email already exists." });

            admin.PasswordHash = HashPassword(admin.PasswordHash);

            _context.SuperAdmins.Add(admin);
            await _context.SaveChangesAsync();

            return Ok(new { message = "Super Admin created successfully" });
        }

        // ============================================================
        // ✅ 3. LIST ALL SUPER ADMINS
        // ============================================================
        [HttpGet("superadmins")]
        public async Task<IActionResult> GetSuperAdmins()
        {
            var list = await _context.SuperAdmins.ToListAsync();
            return Ok(list);
        }

        // ============================================================
        // ✅ 4. CREATE PARKING LOT
        // ============================================================
        [HttpPost("parkinglots/create")]
        public async Task<IActionResult> CreateParkingLot([FromBody] ParkingLot lot)
        {
            _context.ParkingLots.Add(lot);
            await _context.SaveChangesAsync();

            return Ok(new
            {
                message = "Parking lot created successfully",
                lot
            });
        }

        // ============================================================
        // ✅ 5. UPDATE PARKING LOT
        // ============================================================
        [HttpPut("parkinglots/update/{id}")]
        public async Task<IActionResult> UpdateParkingLot(int id, [FromBody] ParkingLot updated)
        {
            var lot = await _context.ParkingLots.FirstOrDefaultAsync(x => x.Id == id);
            if (lot == null)
                return NotFound(new { message = "Parking lot not found." });

            lot.Name = updated.Name;
            lot.Location = updated.Location;
            lot.Capacity = updated.Capacity;
            lot.Geom = updated.Geom;

            await _context.SaveChangesAsync();

            return Ok(new { message = "Parking lot updated successfully" });
        }

        // ============================================================
        // ✅ 6. GET ALL PARKING LOTS
        // ============================================================
        [HttpGet("parkinglots")]
        public async Task<IActionResult> GetParkingLots()
        {
            var lots = await _context.ParkingLots.ToListAsync();
            return Ok(lots);
        }

        // ============================================================
        // 🔐 Helper: Generate JWT Token
        // ============================================================
        private string GenerateJwtToken(MasterAdmin admin)
        {
            var claims = new[]
            {
                new Claim("masterAdminId", admin.Id.ToString()),
                new Claim("email", admin.Email),
                new Claim("name", admin.Name)
            };

            var jwtKey = _config["Jwt:Key"] ?? throw new Exception("JWT Key missing in configuration");

            var key = new SymmetricSecurityKey(Encoding.UTF8.GetBytes(jwtKey));
            var creds = new SigningCredentials(key, SecurityAlgorithms.HmacSha256);

            var token = new JwtSecurityToken(
                issuer: _config["Jwt:Issuer"],
                audience: _config["Jwt:Issuer"],
                claims: claims,
                expires: DateTime.UtcNow.AddHours(12),
                signingCredentials: creds
            );

            return new JwtSecurityTokenHandler().WriteToken(token);
        }

        // ============================================================
        // 🔐 Helper: Hash Password
        // ============================================================
        private static string HashPassword(string password)
        {
            using var sha = SHA256.Create();
            var bytes = sha.ComputeHash(Encoding.UTF8.GetBytes(password));
            return Convert.ToBase64String(bytes);
        }

        // ============================================================
        // DTO: Login Request
        // ============================================================
        public class LoginRequest
        {
            public string Email { get; set; } = string.Empty;
            public string Password { get; set; } = string.Empty;
        }
    }
}
