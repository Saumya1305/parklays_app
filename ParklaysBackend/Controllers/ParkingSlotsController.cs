// using Microsoft.AspNetCore.Mvc;
// using Microsoft.EntityFrameworkCore;
// using ParklaysBackend.Data;
// using ParklaysBackend.Models;

// namespace ParklaysBackend.Controllers
// {
//     [ApiController]
//     [Route("api/[controller]")]
//     public class ParkingSlotsController : ControllerBase
//     {
//         private readonly AppDbContext _context;

//         public ParkingSlotsController(AppDbContext context)
//         {
//             _context = context;
//         }

//         // PUT: api/parkingslots/update-status/5
//         [HttpPut("update-status/{slotId}")]
//         public async Task<IActionResult> UpdateSlotStatus(int slotId, [FromBody] bool isFree)
//         {
//             var slot = await _context.ParkingSlots.FindAsync(slotId);
//             if (slot == null)
//                 return NotFound(new { message = "Slot not found" });

//             slot.IsFree = isFree;
//             await _context.SaveChangesAsync();

//             return Ok(new { message = "Slot status updated successfully." });
//         }
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
    public class ParkingSlotsController : ControllerBase
    {
        private readonly AppDbContext _context;

        public ParkingSlotsController(AppDbContext context)
        {
            _context = context;
        }

        // ✅ GET: api/parkingslots
        [HttpGet]
        public async Task<IActionResult> GetAllSlots()
        {
            var slots = await _context.ParkingSlots.ToListAsync();

            var result = slots.Select(s => new
            {
                s.Id,
                s.LotId,
                s.SlotNumber,
                s.IsFree,
                Latitude = s.Geom == null ? 0 : s.Geom.Coordinate.Y,
                Longitude = s.Geom == null ? 0 : s.Geom.Coordinate.X
            });

            return Ok(result);
        }

        // ✅ PUT: api/parkingslots/update-status/5
        [HttpPut("update-status/{slotId}")]
        public async Task<IActionResult> UpdateSlotStatus(int slotId, [FromBody] bool isFree)
        {
            var slot = await _context.ParkingSlots.FindAsync(slotId);
            if (slot == null)
                return NotFound(new { message = "Slot not found" });

            slot.IsFree = isFree;
            await _context.SaveChangesAsync();

            return Ok(new { message = "Slot status updated successfully." });
        }
    }
}

