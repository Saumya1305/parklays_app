// using Microsoft.AspNetCore.Mvc;
// using Microsoft.EntityFrameworkCore;
// using ParklaysBackend.Data;
// using ParklaysBackend.Models;

// namespace ParklaysBackend.Controllers
// {
//     [ApiController]
//     [Route("api/[controller]")]
//     public class ParkingLotsController : ControllerBase
//     {
//         private readonly AppDbContext _context;

//         public ParkingLotsController(AppDbContext context)
//         {
//             _context = context;
//         }

//         // GET: api/parkinglots
//         [HttpGet]
//         public async Task<ActionResult<IEnumerable<ParkingLot>>> GetAll()
//         {
//             return await _context.ParkingLots.ToListAsync();
//         }

//         // GET: api/parkinglots/5
//         [HttpGet("{id}")]
//         public async Task<ActionResult<ParkingLot>> GetById(int id)
//         {
//             var lot = await _context.ParkingLots.FindAsync(id);
//             if (lot == null) return NotFound();
//             return lot;
//         }

//         // POST: api/parkinglots
//         [HttpPost]
//         public async Task<ActionResult<ParkingLot>> Create(ParkingLot lot)
//         {
//             _context.ParkingLots.Add(lot);
//             await _context.SaveChangesAsync();
//             return CreatedAtAction(nameof(GetById), new { id = lot.Id }, lot);
//         }

//         // PUT: api/parkinglots/5
//         [HttpPut("{id}")]
//         public async Task<IActionResult> Update(int id, ParkingLot lot)
//         {
//             if (id != lot.Id) return BadRequest();

//             _context.Entry(lot).State = EntityState.Modified;
//             await _context.SaveChangesAsync();

//             return NoContent();
//         }

//         // DELETE: api/parkinglots/5
//         [HttpDelete("{id}")]
//         public async Task<IActionResult> Delete(int id)
//         {
//             var lot = await _context.ParkingLots.FindAsync(id);
//             if (lot == null) return NotFound();

//             _context.ParkingLots.Remove(lot);
//             await _context.SaveChangesAsync();

//             return NoContent();
//         }
//         // GET: api/parkinglots/{lotId}/slots
//         [HttpGet("{lotId}/slots")]
//         public async Task<IActionResult> GetSlotsByLotId(int lotId)
//         {
//             var slots = await _context.ParkingSlots
//             .Where(p => p.LotId == lotId)
//             .ToListAsync();

//             if (slots == null || slots.Count == 0)
//             return NotFound($"No slots found for ParkingLotId {lotId}");

//             return Ok(slots);
//         }
//     }
// }






// using Microsoft.AspNetCore.Mvc;
// using Microsoft.EntityFrameworkCore;
// using ParklaysBackend.Data;
// using ParklaysBackend.Models;
// using System.Linq;

// namespace ParklaysBackend.Controllers
// {
//     [ApiController]
//     [Route("api/[controller]")]
//     public class ParkingLotsController : ControllerBase
//     {
//         private readonly AppDbContext _context;

//         public ParkingLotsController(AppDbContext context)
//         {
//             _context = context;
//         }

//         // ✅ FIXED: Returns clean JSON with Latitude/Longitude extracted from Geom
//         [HttpGet]
//         public async Task<IActionResult> GetAll()
//         {
//             var lots = await _context.ParkingLots.ToListAsync();

//             var result = lots.Select(p => new
//             {
//                 p.Id,
//                 p.Name,
//                 p.Location,
//                 p.Capacity,
//                 Latitude = p.Geom == null ? 0 : p.Geom.Coordinate.Y,
//                 Longitude = p.Geom == null ? 0 : p.Geom.Coordinate.X
//             });

//             return Ok(result);
//         }

//         // GET: api/parkinglots/5
//         [HttpGet("{id}")]
//         public async Task<ActionResult<ParkingLot>> GetById(int id)
//         {
//             var lot = await _context.ParkingLots.FindAsync(id);
//             if (lot == null) return NotFound();
//             return lot;
//         }

//         // POST: api/parkinglots
//         [HttpPost]
//         public async Task<ActionResult<ParkingLot>> Create(ParkingLot lot)
//         {
//             _context.ParkingLots.Add(lot);
//             await _context.SaveChangesAsync();
//             return CreatedAtAction(nameof(GetById), new { id = lot.Id }, lot);
//         }

//         // PUT: api/parkinglots/5
//         [HttpPut("{id}")]
//         public async Task<IActionResult> Update(int id, ParkingLot lot)
//         {
//             if (id != lot.Id) return BadRequest();

//             _context.Entry(lot).State = EntityState.Modified;
//             await _context.SaveChangesAsync();

//             return NoContent();
//         }

//         // DELETE: api/parkinglots/5
//         [HttpDelete("{id}")]
//         public async Task<IActionResult> Delete(int id)
//         {
//             var lot = await _context.ParkingLots.FindAsync(id);
//             if (lot == null) return NotFound();

//             _context.ParkingLots.Remove(lot);
//             await _context.SaveChangesAsync();

//             return NoContent();
//         }

//         // GET: api/parkinglots/{lotId}/slots
//         [HttpGet("{lotId}/slots")]
//         public async Task<IActionResult> GetSlotsByLotId(int lotId)
//         {
//             var slots = await _context.ParkingSlots
//                 .Where(p => p.LotId == lotId)
//                 .ToListAsync();

//             if (slots == null || slots.Count == 0)
//                 return NotFound($"No slots found for ParkingLotId {lotId}");

//             return Ok(slots);
//         }
//     }
// }



using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using ParklaysBackend.Data;
using ParklaysBackend.Models;
using System.Linq;

namespace ParklaysBackend.Controllers
{
    [ApiController]
    [Route("api/[controller]")]
    public class ParkingLotsController : ControllerBase
    {
        private readonly AppDbContext _context;

        public ParkingLotsController(AppDbContext context)
        {
            _context = context;
        }

        // ✅ FIXED: Returns clean JSON with safe Latitude/Longitude
        [HttpGet]
        public async Task<IActionResult> GetAll()
        {
            var lots = await _context.ParkingLots.ToListAsync();

            var result = lots.Select(p => new
            {
                p.Id,
                p.Name,
                p.Location,
                p.Capacity,
                Latitude = (p.Geom == null || p.Geom.IsEmpty || double.IsInfinity(p.Geom.Coordinate.Y)) ? 0 : p.Geom.Coordinate.Y,
                Longitude = (p.Geom == null || p.Geom.IsEmpty || double.IsInfinity(p.Geom.Coordinate.X)) ? 0 : p.Geom.Coordinate.X
            });

            return Ok(result);
        }

        // ✅ Optional: also make GetById safe
        [HttpGet("{id}")]
        public async Task<IActionResult> GetById(int id)
        {
            var lot = await _context.ParkingLots.FindAsync(id);
            if (lot == null) return NotFound();

            var result = new
            {
                lot.Id,
                lot.Name,
                lot.Location,
                lot.Capacity,
                Latitude = (lot.Geom == null || lot.Geom.IsEmpty || double.IsInfinity(lot.Geom.Coordinate.Y)) ? 0 : lot.Geom.Coordinate.Y,
                Longitude = (lot.Geom == null || lot.Geom.IsEmpty || double.IsInfinity(lot.Geom.Coordinate.X)) ? 0 : lot.Geom.Coordinate.X
            };

            return Ok(result);
        }

        [HttpPost]
        public async Task<ActionResult<ParkingLot>> Create(ParkingLot lot)
        {
            _context.ParkingLots.Add(lot);
            await _context.SaveChangesAsync();
            return CreatedAtAction(nameof(GetById), new { id = lot.Id }, lot);
        }

        [HttpPut("{id}")]
        public async Task<IActionResult> Update(int id, ParkingLot lot)
        {
            if (id != lot.Id) return BadRequest();

            _context.Entry(lot).State = EntityState.Modified;
            await _context.SaveChangesAsync();

            return NoContent();
        }

        [HttpDelete("{id}")]
        public async Task<IActionResult> Delete(int id)
        {
            var lot = await _context.ParkingLots.FindAsync(id);
            if (lot == null) return NotFound();

            _context.ParkingLots.Remove(lot);
            await _context.SaveChangesAsync();

            return NoContent();
        }

        [HttpGet("{lotId}/slots")]
public async Task<IActionResult> GetSlotsByLotId(int lotId)
{
    var slots = await _context.ParkingSlots
        .Where(p => p.LotId == lotId)
        .ToListAsync();

    if (slots == null || slots.Count == 0)
        return NotFound(new { message = $"No slots found for ParkingLotId {lotId}" });

    var result = slots.Select(s => new
    {
        s.Id,
        s.LotId,
        s.SlotNumber,
        s.IsFree,
        s.IsBike,
        GeoJson = s.GeoJson  // ✅ returns proper GeoJSON string
    });

    return Ok(result);
}


    }
}
