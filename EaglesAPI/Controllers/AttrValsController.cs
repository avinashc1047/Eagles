using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using Eagles.EF.Data;
using Eagles.EF.Models;

namespace EaglesAPI.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class AttrValsController : ControllerBase
    {
        private readonly EaglesOracleContext _context;

        public AttrValsController(EaglesOracleContext context)
        {
            _context = context;
        }

        // GET: api/AttrVals
        [HttpGet]
        public async Task<ActionResult<IEnumerable<AttrVal>>> GetAttrVals()
        {
            return await _context.AttrVals.ToListAsync();
        }

        // GET: api/AttrVals/5
        [HttpGet("{id}")]
        public async Task<ActionResult<AttrVal>> GetAttrVal(string id)
        {
            var attrVal = await _context.AttrVals.FindAsync(id);

            if (attrVal == null)
            {
                return NotFound();
            }

            return attrVal;
        }

        // PUT: api/AttrVals/5
        // To protect from overposting attacks, see https://go.microsoft.com/fwlink/?linkid=2123754
        [HttpPut("{id}")]
        public async Task<IActionResult> PutAttrVal(string id, AttrVal attrVal)
        {
            if (id != attrVal.AttrValId)
            {
                return BadRequest();
            }

            _context.Entry(attrVal).State = EntityState.Modified;

            try
            {
                await _context.SaveChangesAsync();
            }
            catch (DbUpdateConcurrencyException)
            {
                if (!AttrValExists(id))
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

        // POST: api/AttrVals
        // To protect from overposting attacks, see https://go.microsoft.com/fwlink/?linkid=2123754
        [HttpPost]
        public async Task<ActionResult<AttrVal>> PostAttrVal(AttrVal attrVal)
        {
            _context.AttrVals.Add(attrVal);
            await _context.SaveChangesAsync();

            return CreatedAtAction("GetAttrVal", new { id = attrVal.AttrValId }, attrVal);
        }

        // DELETE: api/AttrVals/5
        [HttpDelete("{id}")]
        public async Task<IActionResult> DeleteAttrVal(string id)
        {
            var attrVal = await _context.AttrVals.FindAsync(id);
            if (attrVal == null)
            {
                return NotFound();
            }

            _context.AttrVals.Remove(attrVal);
            await _context.SaveChangesAsync();

            return NoContent();
        }

        private bool AttrValExists(string id)
        {
            return _context.AttrVals.Any(e => e.AttrValId == id);
        }
    }
}
