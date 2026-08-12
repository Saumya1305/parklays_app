using Microsoft.AspNetCore.Mvc;
using ParklaysBackend.Data;
using ParklaysBackend.Models;
using Microsoft.EntityFrameworkCore;

namespace ParklaysBackend.Controllers
{
    [ApiController]
    [Route("api/user")]
    public class UserController : ControllerBase
    {
        private readonly AppDbContext _db;
        public UserController(AppDbContext db)
        {
            _db = db;
        }

        // GET: api/user/find?email=xyz@example.com
        [HttpGet("find")]
        public async Task<IActionResult> FindUser([FromQuery] string email, [FromQuery] string? phone = null)
        {
            var user = await _db.UserProfiles
                .FirstOrDefaultAsync(u => u.Email == email || (phone != null && u.PhoneNumber == phone));

            if (user == null)
                return NotFound(new { message = "User not found" });

            return Ok(user);
        }
    }
}
