using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using ParklaysBackend.Data;
using ParklaysBackend.Models;

namespace ParklaysBackend.Controllers
{
    [ApiController]
    [Route("api/[controller]")]
    public class UserProfilesController : ControllerBase
    {
        private readonly AppDbContext _context;

        public UserProfilesController(AppDbContext context)
        {
            _context = context;
        }

        // ✅ Create new profile
        [HttpPost]
        public async Task<IActionResult> CreateUserProfile([FromBody] UserProfile profile)
        {
            if (profile == null)
                return BadRequest("Profile data is null");

            // Check duplicate phone
            var existing = await _context.UserProfiles
                .FirstOrDefaultAsync(p => p.PhoneNumber == profile.PhoneNumber);

            if (existing != null)
                return Conflict("Phone number already exists");

            await _context.UserProfiles.AddAsync(profile);
            await _context.SaveChangesAsync();

            return CreatedAtAction(nameof(GetProfileByPhone), new { phoneNumber = profile.PhoneNumber }, profile);
        }

        // ✅ Get profile by phone
        [HttpGet("by-phone/{phoneNumber}")]
        public async Task<IActionResult> GetProfileByPhone(string phoneNumber)
        {
            var profile = await _context.UserProfiles
                .FirstOrDefaultAsync(p => p.PhoneNumber == phoneNumber);

            if (profile == null)
                return NotFound();

            return Ok(profile);
        }

        // ✅ Update profile by phone
        [HttpPut("by-phone/{phoneNumber}")]
        public async Task<IActionResult> UpdateProfileByPhone(string phoneNumber, [FromBody] UserProfile updatedProfile)
        {
            var profile = await _context.UserProfiles
                .FirstOrDefaultAsync(p => p.PhoneNumber == phoneNumber);

            if (profile == null)
                return NotFound();

            // Update fields
            profile.Name = updatedProfile.Name;
            profile.Email = updatedProfile.Email;
            profile.Address = updatedProfile.Address;
            profile.VehicleType = updatedProfile.VehicleType;
            profile.VehicleNumber = updatedProfile.VehicleNumber;
            profile.VehicleModel = updatedProfile.VehicleModel;
            profile.VehicleColor = updatedProfile.VehicleColor;

            await _context.SaveChangesAsync();

            return Ok(profile);
        }
    }
}
