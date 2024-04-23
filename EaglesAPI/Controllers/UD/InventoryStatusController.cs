using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using Eagles.EF.Data;
using Eagles.EF.Models;

namespace EaglesAPI.Controllers.UD
{
    [Route("api/[controller]")]
    [ApiController]
    public class InventoryStatusController : ControllerBase
    {
        private readonly EaglesOracleContext _context;

        public InventoryStatusController(EaglesOracleContext context)
        {
            _context = context;
        }

        // GET: api/InventoryStatus
        [HttpGet]
        public async Task<ActionResult<IEnumerable<InventoryStatus>>> GetInventoryStatus()
        {
            return await _context.InventoryStatus.ToListAsync();
        }

        // GET: api/InventoryStatus/5
        [HttpGet("{id}")]
        public async Task<ActionResult<InventoryStatus>> GetInventoryStatus(string id)
        {
            var inventoryStatus = await _context.InventoryStatus.FindAsync(id);

            if (inventoryStatus == null)
            {
                return NotFound();
            }

            return inventoryStatus;
        }

        // PUT: api/InventoryStatus/5
        // To protect from overposting attacks, see https://go.microsoft.com/fwlink/?linkid=2123754
        [HttpPut("{id}")]
        public async Task<IActionResult> PutInventoryStatus(string id, InventoryStatus inventoryStatus)
        {
            if (id != inventoryStatus.InventoryStatusId)
            {
                return BadRequest();
            }

            _context.Entry(inventoryStatus).State = EntityState.Modified;

            try
            {
                await _context.SaveChangesAsync();
            }
            catch (DbUpdateConcurrencyException)
            {
                if (!InventoryStatusExists(id))
                {
                    return NotFound();
                }
                else
                {
                    throw;
                }
            }

            return NoContent();
        }

        // POST: api/InventoryStatus
        // To protect from overposting attacks, see https://go.microsoft.com/fwlink/?linkid=2123754
        [HttpPost]
        public async Task<ActionResult<InventoryStatus>> PostInventoryStatus(InventoryStatus inventoryStatus)
        {
            _context.InventoryStatus.Add(inventoryStatus);
            try
            {
                await _context.SaveChangesAsync();
            }
            catch (DbUpdateException)
            {
                if (InventoryStatusExists(inventoryStatus.InventoryStatusId))
                {
                    return Conflict();
                }
                else
                {
                    throw;
                }
            }

            return CreatedAtAction("GetInventoryStatus", new { id = inventoryStatus.InventoryStatusId }, inventoryStatus);
        }

        // DELETE: api/InventoryStatus/5
        [HttpDelete("{id}")]
        public async Task<IActionResult> DeleteInventoryStatus(string id)
        {
            var inventoryStatus = await _context.InventoryStatus.FindAsync(id);
            if (inventoryStatus == null)
            {
                return NotFound();
            }

            _context.InventoryStatus.Remove(inventoryStatus);
            await _context.SaveChangesAsync();

            return NoContent();
        }

        private bool InventoryStatusExists(string id)
        {
            return _context.InventoryStatus.Any(e => e.InventoryStatusId == id);
        }
    }
}
