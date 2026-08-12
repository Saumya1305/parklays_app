using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using ParklaysBackend.Data;
using ParklaysBackend.Models;
using NetTopologySuite.IO;

namespace ParklaysBackend.Controllers
{
    [ApiController]
    [Route("api/[controller]")]
    public class AdminController : ControllerBase
    {
        private readonly AppDbContext _context;

        public AdminController(AppDbContext context)
        {
            _context = context;
        }

        // ✅ 1. Admin Login using Phone Number (NO OTP)
        [HttpPost("login")]
        public async Task<IActionResult> Login([FromBody] LoginRequest req)
        {
            var admin = await _context.Admins
                .FirstOrDefaultAsync(a => a.Phone == req.Phone && a.IsActive);

            if (admin == null)
                return Unauthorized(new { message = "Admin not found or inactive" });

            return Ok(new
            {
                message = "Login successful",
                admin = new
                {
                    admin.Id,
                    admin.Name,
                    admin.Phone,
                    admin.Email,
                    admin.LotId
                }
            });
        }

        // ✅ 2. Get Slot list for this admin's lot
        [HttpGet("{adminId}/slots")]
        public async Task<IActionResult> GetSlots(int adminId)
        {
            var admin = await _context.Admins.FindAsync(adminId);
            if (admin == null)
                return NotFound(new { message = "Admin not found" });

            var slots = await _context.ParkingSlots
                .Where(s => s.LotId == admin.LotId)
                .ToListAsync();

            var geoWriter = new GeoJsonWriter();

            var result = slots.Select(s => new
            {
                s.Id,
                s.SlotNumber,
                s.IsFree,
                s.IsBike,
                GeoJson = s.Geom != null ? geoWriter.Write(s.Geom) : null
            });

            return Ok(result);
        }


        [HttpPut("slot-status/{slotId}")]
        public async Task<IActionResult> UpdateSlot(long slotId, [FromBody] SlotStatusRequest req)
        {
            var slot = await _context.ParkingSlots.FindAsync(slotId);
            if (slot == null) return NotFound(new { message = "Slot not found" });

            slot.IsFree = req.IsFree;
            await _context.SaveChangesAsync();

            return Ok(new { message = "Slot updated", slotId, isFree = req.IsFree });
        }

        // ==========================
        // 4. Create Parking Session (QR Scan)
        // ==========================
        [HttpPost("scan")]
        public async Task<IActionResult> CreateParkingSession([FromBody] ParkingSession session)
        {
            session.EntryTime = DateTime.UtcNow;
            session.Status = "active";

            _context.ParkingSessions.Add(session);
            await _context.SaveChangesAsync();

            return Ok(new { message = "Parking session started", session.Id });
        }

        // ==========================
        // 5. End Parking Session
        // ==========================
        [HttpPut("end-session/{sessionId}")]
        public async Task<IActionResult> EndSession(int sessionId)
        {
            var session = await _context.ParkingSessions.FindAsync(sessionId);
            if (session == null)
                return NotFound(new { message = "Session not found" });

            session.ExitTime = DateTime.UtcNow;
            session.Status = "completed";

            await _context.SaveChangesAsync();

            return Ok(new { message = "Parking session ended" });
        }

        // ==========================
        // 6. Get Pending Parking Sessions for this lot (optional)
        // ==========================
        [HttpGet("{adminId}/pending-sessions")]
        public async Task<IActionResult> GetPendingSessions(int adminId)
        {
            var admin = await _context.Admins.FindAsync(adminId);
            if (admin == null)
                return NotFound(new { message = "Admin not found" });

            var sessions = await _context.ParkingSessions
                .Include(ps => ps.Slot).Where(ps => ps.Slot != null &&
                ps.Slot.LotId == admin.LotId &&
                ps.Status == "active")
               
                .ToListAsync();

            var result = sessions.Select(ps => new
            {
                ps.Id,
                ps.SlotId,
                ps.EntryTime,
                ps.Status,
                SlotNumber = ps.Slot?.SlotNumber
            });

            return Ok(result);
        }

        // ==========================
        // Login Request DTO
        // ==========================
        public class LoginRequest
        {
            public string Phone { get; set; } = string.Empty;
        }

        // ==========================
        // Slot Status Update DTO
        // ==========================
        public class SlotStatusRequest
        {

            public bool IsFree { get; set; }
        }

        // ==========================
// 7. Get Admin Profile by ID
// ==========================
[HttpGet("profile/{id}")]
public async Task<IActionResult> GetAdminProfile(int id)
{
    var admin = await _context.Admins
        .Include(a => a.ParkingLot)
        .Include(a => a.SuperAdmin)
        .FirstOrDefaultAsync(a => a.Id == id);

    if (admin == null)
        return NotFound(new { message = "Admin not found" });

    return Ok(new
    {
        admin.Id,
        admin.Name,
        admin.Dob,
        admin.Email,
        admin.Phone,
        admin.LotId,
        ParkingLotName = admin.ParkingLot?.Name,
        admin.IsActive,
        admin.CreatedBy,
        CreatedByName = admin.SuperAdmin?.Name,
        admin.CreatedAt
    });
}

    }
}







 // ✅ 3. Update Slot Status (Guard does this)
        // [HttpPut("slot-status/{slotId}")]
        // public async Task<IActionResult> UpdateSlot(int slotId, [FromBody] bool isFree)
        // {
        //     var slot = await _context.ParkingSlots.FindAsync(slotId);
        //     if (slot == null) return NotFound(new { message = "Slot not found" });

        //     slot.IsFree = isFree;
        //     await _context.SaveChangesAsync();

        //     return Ok(new { message = "Slot updated", slotId, isFree });
        // }