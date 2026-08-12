// using Microsoft.AspNetCore.Mvc;
// using Microsoft.EntityFrameworkCore;
// using ParklaysBackend.Data;
// using ParklaysBackend.Models;

// namespace ParklaysBackend.Controllers
// {
//     [ApiController]
//     [Route("api/[controller]")]
//     public class ParkingSessionsController : ControllerBase
//     {
//         private readonly AppDbContext _context;

//         public ParkingSessionsController(AppDbContext context)
//         {
//             _context = context;
//         }

//         // GET: api/parkingsessions
//         [HttpGet]
//         public async Task<ActionResult<IEnumerable<ParkingSession>>> GetAll()
//         {
//             // Include ParkingLot details
//             return await _context.ParkingSessions
//                 .Include(p => p.ParkingLot)
//                 .Include(p => p.Slot)
//                 .ToListAsync();
//         }

//         // GET: api/parkingsessions/5
//         [HttpGet("{id}")]
//         public async Task<ActionResult<ParkingSession>> GetById(int id)
//         {
//             var session = await _context.ParkingSessions
//                 .Include(p => p.ParkingLot)
//                 .Include(p => p.Slot)
//                 .FirstOrDefaultAsync(p => p.Id == id);

//             if (session == null) return NotFound();
//             return session;
//         }

//         // POST: api/parkingsessions
//         [HttpPost]
//         public async Task<ActionResult<ParkingSession>> Create(ParkingSession session)
//         {
//             // No need to manually set UTC here because your model already does that
//             _context.ParkingSessions.Add(session);
//             await _context.SaveChangesAsync();

//             return CreatedAtAction(nameof(GetById), new { id = session.Id }, session);
//         }

//         // PUT: api/parkingsessions/5
//         [HttpPut("{id}")]
//         public async Task<IActionResult> Update(int id, ParkingSession session)
//         {
//             if (id != session.Id) return BadRequest();

//             _context.Entry(session).State = EntityState.Modified;
//             await _context.SaveChangesAsync();

//             return NoContent();
//         }

        

//         // DELETE: api/parkingsessions/5
//         [HttpDelete("{id}")]
//         public async Task<IActionResult> Delete(int id)
//         {
//             var session = await _context.ParkingSessions.FindAsync(id);
//             if (session == null) return NotFound();

//             _context.ParkingSessions.Remove(session);
//             await _context.SaveChangesAsync();

//             return NoContent();
//         }

//         public class StartSessionDto
// {
//     public int LotId { get; set; }
//     public long SlotId { get; set; }
//     public int SlotNumber { get; set; }
//     public int ScannedBy { get; set; }

//     public string UserName { get; set; } = "";
//     public string VehicleType { get; set; } = "";
//     public string VehicleNumber { get; set; } = "";
//     public string Email { get; set; } = "";
//     public string Phone { get; set; } = "";
//     public string VehicleColor { get; set; } = "";
//     public string VehicleModel { get; set; } = "";
// }

//     [HttpPost("start")]
// public async Task<IActionResult> StartSession(StartSessionDto dto)
// {
//     var session = new ParkingSession
//     {
//         LotId = dto.LotId,
//         SlotId = dto.SlotId,
//         SlotNumber = dto.SlotNumber,
//         ScannedBy = dto.ScannedBy,

//         UserName = dto.UserName,
//         VehicleType = dto.VehicleType,
//         VehicleNumber = dto.VehicleNumber,
//         Email = dto.Email,
//         Phone = dto.Phone,
//         VehicleColor = dto.VehicleColor,
//         VehicleModel = dto.VehicleModel,

//         EntryTime = DateTime.UtcNow,
//         Status = "active"
//     };

//     _context.ParkingSessions.Add(session);
//     await _context.SaveChangesAsync();

//     return Ok(session);
// }


//     }
// }






using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using ParklaysBackend.Data;
using ParklaysBackend.Models;

namespace ParklaysBackend.Controllers
{
    [ApiController]
    [Route("api/[controller]")]
    public class ParkingSessionsController : ControllerBase
    {
        private readonly AppDbContext _context;

        public ParkingSessionsController(AppDbContext context)
        {
            _context = context;
        }

        // ---------------- GET ALL ----------------
        [HttpGet]
        public async Task<ActionResult<IEnumerable<ParkingSession>>> GetAll()
        {
            return await _context.ParkingSessions
                .Include(p => p.ParkingLot)
                .Include(p => p.Slot)
                .ToListAsync();
        }

        // ---------------- GET ALL SESSIONS BY LOT ----------------
[HttpGet("byLot")]
public async Task<IActionResult> GetSessionsByLot([FromQuery] int lotId)
{
    var sessions = await _context.ParkingSessions
        .Where(p => p.LotId == lotId)
        .OrderByDescending(p => p.EntryTime)
        .ToListAsync();

    return Ok(sessions);
}

        // ---------------- GET COMPLETED SESSIONS BY LOT ----------------
[HttpGet("status/completed")]
public async Task<IActionResult> GetCompletedSessions([FromQuery] int lotId)
{
    var sessions = await _context.ParkingSessions
        .Where(p => p.LotId == lotId && p.Status == "completed")
        .OrderByDescending(p => p.ExitTime)
        .ToListAsync();

    return Ok(sessions);
}

// ---------------- GET ACTIVE SESSIONS BY LOT ----------------
[HttpGet("status/active/byLot")]
public async Task<IActionResult> GetActiveSessionsByLot([FromQuery] int lotId)
{
    var sessions = await _context.ParkingSessions
        .Where(p => p.LotId == lotId && p.Status == "active")
        .OrderByDescending(p => p.EntryTime)
        .ToListAsync();

    return Ok(sessions);
}


        // ---------------- GET BY ID ----------------
        [HttpGet("{id:int}")]
        public async Task<ActionResult<ParkingSession>> GetById(int id)
        {
            var session = await _context.ParkingSessions
                .Include(p => p.ParkingLot)
                .Include(p => p.Slot)
                .FirstOrDefaultAsync(p => p.Id == id);

            if (session == null) return NotFound();
            return session;
        }

        // ---------------- CREATE NEW SESSION ----------------
        [HttpPost]
        public async Task<ActionResult<ParkingSession>> Create(ParkingSession session)
        {
            _context.ParkingSessions.Add(session);
            await _context.SaveChangesAsync();
            return CreatedAtAction(nameof(GetById), new { id = session.Id }, session);
        }

        // ---------------- UPDATE SESSION ----------------
        [HttpPut("{id}")]
        public async Task<IActionResult> Update(int id, ParkingSession session)
        {
            if (id != session.Id) return BadRequest();

            _context.Entry(session).State = EntityState.Modified;
            await _context.SaveChangesAsync();

            return NoContent();
        }

        // ---------------- DELETE SESSION ----------------
        [HttpDelete("{id}")]
        public async Task<IActionResult> Delete(int id)
        {
            var session = await _context.ParkingSessions.FindAsync(id);
            if (session == null) return NotFound();

            _context.ParkingSessions.Remove(session);
            await _context.SaveChangesAsync();

            return NoContent();
        }

        // ---------------- DTO FOR START SESSION ----------------
        public class StartSessionDto
        {
            public int LotId { get; set; }
            public long SlotId { get; set; }
            public int SlotNumber { get; set; }
            public int ScannedBy { get; set; }

            public string UserName { get; set; } = "";
            public string VehicleType { get; set; } = "";
            public string VehicleNumber { get; set; } = "";
            public string Email { get; set; } = "";
            public string Phone { get; set; } = "";
            public string VehicleColor { get; set; } = "";
            public string VehicleModel { get; set; } = "";
        }

        // ---------------- START SESSION ----------------
        [HttpPost("start")]
        public async Task<IActionResult> StartSession(StartSessionDto dto)
        {
            var session = new ParkingSession
            {
                LotId = dto.LotId,
                SlotId = dto.SlotId,
                SlotNumber = dto.SlotNumber,
                ScannedBy = dto.ScannedBy,

                UserName = dto.UserName,
                VehicleType = dto.VehicleType,
                VehicleNumber = dto.VehicleNumber,
                Email = dto.Email,
                Phone = dto.Phone,
                VehicleColor = dto.VehicleColor,
                VehicleModel = dto.VehicleModel,

                EntryTime = DateTime.UtcNow,
                Status = "active"
            };

            _context.ParkingSessions.Add(session);
            await _context.SaveChangesAsync();

            return Ok(session);
        }

        // ---------------- END SESSION ----------------
        public class EndSessionDto
        {
            public long SlotId { get; set; }
        }

        [HttpPost("end")]
        public async Task<IActionResult> EndSession(EndSessionDto dto)
        {
            // Find the active session for this slot
            var session = await _context.ParkingSessions
                .Where(p => p.SlotId == dto.SlotId && p.Status == "active")
                .OrderByDescending(p => p.EntryTime)
                .FirstOrDefaultAsync();

            if (session == null) return NotFound("No active session found for this slot.");

            session.ExitTime = DateTime.UtcNow;
            session.Status = "completed";

            _context.Entry(session).State = EntityState.Modified;
            await _context.SaveChangesAsync();

            return Ok(session);
        }
        // ---------------- GET ACTIVE SESSION BY SLOT ----------------
[HttpGet("active")]
public async Task<IActionResult> GetActiveSession([FromQuery] long slotId)
{
    var session = await _context.ParkingSessions
        //.Include(p => p.ParkingLot)
        //.Include(p => p.Slot)
        .Where(p => p.SlotId == slotId && p.Status == "active")
        .OrderByDescending(p => p.EntryTime)
        .FirstOrDefaultAsync();

    if (session == null)
        return NotFound(new { message = "No active session found for this slot." });

    return Ok(session);
}
//test//
[HttpGet("test/{phone}")]
public IActionResult TestPhone(string phone)
{
    return Ok(new { message = "Route working", phone });
}
// ---------------- GET HISTORY BY PHONE ----------------
[HttpGet("by-phone/{phone}")]
public async Task<IActionResult> GetSessionsByPhone(string phone)
{
    if (string.IsNullOrWhiteSpace(phone))
        return BadRequest("Phone is required.");

    string normalized = phone.Trim().Replace("+91", "");

    var sessions = await _context.ParkingSessions
        .Where(p => p.Phone.Replace(" ", "").Replace("+91", "") == normalized)
        .OrderByDescending(p => p.EntryTime)
        .ToListAsync();

    return Ok(sessions);
}

    }
}
