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
    public class AttrsController : ControllerBase
    {
        private readonly EaglesOracleContext _context;

        public AttrsController(EaglesOracleContext context)
        {
            _context = context;
        }

        // GET: api/Attrs
        [HttpGet]
        public async Task<ActionResult<IEnumerable<Attr>>> GetAttrs()
        {
            return await _context.Attrs.ToListAsync();
        }

        // GET: api/Attrs/5
        [HttpGet("{id}")]
        public async Task<ActionResult<Attr>> GetAttr(string id)
        {
            var attr = await _context.Attrs.FindAsync(id);

            if (attr == null)
            {
                return NotFound();
            }

            return attr;
        }

        // PUT: api/Attrs/5
        // To protect from overposting attacks, see https://go.microsoft.com/fwlink/?linkid=2123754
        [HttpPut("{id}")]
        public async Task<IActionResult> PutAttr(string id, Attr attr)
        {
            if (id != attr.AttrId)
            {
                return BadRequest();
            }

            _context.Entry(attr).State = EntityState.Modified;

            try
            {
                await _context.SaveChangesAsync();
            }
            catch (DbUpdateConcurrencyException)
            {
                if (!AttrExists(id))
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

        // POST: api/Attrs
        // To protect from overposting attacks, see https://go.microsoft.com/fwlink/?linkid=2123754
        [HttpPost]
        public async Task<ActionResult<Attr>> PostAttr(Attr attr)
        {
            _context.Attrs.Add(attr);
            await _context.SaveChangesAsync();

            return CreatedAtAction("GetAttr", new { id = attr.AttrId }, attr);
        }

        // DELETE: api/Attrs/5
        [HttpDelete("{id}")]
        public async Task<IActionResult> DeleteAttr(string id)
        {
            var attr = await _context.Attrs.FindAsync(id);
            if (attr == null)
            {
                return NotFound();
            }

            _context.Attrs.Remove(attr);
            await _context.SaveChangesAsync();

            return NoContent();
        }

        private bool AttrExists(string id)
        {
            return _context.Attrs.Any(e => e.AttrId == id);
        }
    }
}
