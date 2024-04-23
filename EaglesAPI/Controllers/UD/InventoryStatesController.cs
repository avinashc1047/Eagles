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
    public class InventoryStatesController : ControllerBase
    {
        private readonly EaglesOracleContext _context;

        public InventoryStatesController(EaglesOracleContext context)
        {
            _context = context;
        }

        // GET: api/InventoryStates
        [HttpGet]
        public async Task<ActionResult<IEnumerable<InventoryState>>> GetInventoryState()
        {
            return await _context.InventoryState.ToListAsync();
        }

        // GET: api/InventoryStates/5
        [HttpGet("{id}")]
        public async Task<ActionResult<InventoryState>> GetInventoryState(string id)
        {
            var inventoryState = await _context.InventoryState.FindAsync(id);

            if (inventoryState == null)
            {
                return NotFound();
            }

            return inventoryState;
        }

        // PUT: api/InventoryStates/5
        // To protect from overposting attacks, see https://go.microsoft.com/fwlink/?linkid=2123754
        [HttpPut("{id}")]
        public async Task<IActionResult> PutInventoryState(string id, InventoryState inventoryState)
        {
            if (id != inventoryState.InventoryStateId)
            {
                return BadRequest();
            }

            _context.Entry(inventoryState).State = EntityState.Modified;

            try
            {
                await _context.SaveChangesAsync();
            }
            catch (DbUpdateConcurrencyException)
            {
                if (!InventoryStateExists(id))
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

        // POST: api/InventoryStates
        // To protect from overposting attacks, see https://go.microsoft.com/fwlink/?linkid=2123754
        [HttpPost]
        public async Task<ActionResult<InventoryState>> PostInventoryState(InventoryState inventoryState)
        {
            _context.InventoryState.Add(inventoryState);
            await _context.SaveChangesAsync();

            return CreatedAtAction("GetInventoryState", new { id = inventoryState.InventoryStateId }, inventoryState);
        }

        // DELETE: api/InventoryStates/5
        [HttpDelete("{id}")]
        public async Task<IActionResult> DeleteInventoryState(string id)
        {
            var inventoryState = await _context.InventoryState.FindAsync(id);
            if (inventoryState == null)
            {
                return NotFound();
            }

            _context.InventoryState.Remove(inventoryState);
            await _context.SaveChangesAsync();

            return NoContent();
        }

        private bool InventoryStateExists(string id)
        {
            return _context.InventoryState.Any(e => e.InventoryStateId == id);
        }
    }
}
