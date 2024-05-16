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
    public class ProductAttrsController : ControllerBase
    {
        private readonly EaglesOracleContext _context;

        public ProductAttrsController(EaglesOracleContext context)
        {
            _context = context;
        }

        // GET: api/ProductAttrs
        [HttpGet]
        public async Task<ActionResult<IEnumerable<ProductAttr>>> GetProductAttrs()
        {
            return await _context.ProductAttrs.ToListAsync();
        }

        // GET: api/ProductAttrs/5
        [HttpGet("{id}")]
        public async Task<ActionResult<ProductAttr>> GetProductAttr(string id)
        {
            var productAttr = await _context.ProductAttrs.FindAsync(id);

            if (productAttr == null)
            {
                return NotFound();
            }

            return productAttr;
        }

        // PUT: api/ProductAttrs/5
        // To protect from overposting attacks, see https://go.microsoft.com/fwlink/?linkid=2123754
        [HttpPut("{id}")]
        public async Task<IActionResult> PutProductAttr(string id, ProductAttr productAttr)
        {
            if (id != productAttr.ProductAttrId)
            {
                return BadRequest();
            }

            _context.Entry(productAttr).State = EntityState.Modified;

            try
            {
                await _context.SaveChangesAsync();
            }
            catch (DbUpdateConcurrencyException)
            {
                if (!ProductAttrExists(id))
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

        // POST: api/ProductAttrs
        // To protect from overposting attacks, see https://go.microsoft.com/fwlink/?linkid=2123754
        [HttpPost]
        public async Task<ActionResult<ProductAttr>> PostProductAttr(ProductAttr productAttr)
        {
            _context.ProductAttrs.Add(productAttr);
            await _context.SaveChangesAsync();

            return CreatedAtAction("GetProductAttr", new { id = productAttr.ProductAttrId }, productAttr);
        }

        // DELETE: api/ProductAttrs/5
        [HttpDelete("{id}")]
        public async Task<IActionResult> DeleteProductAttr(string id)
        {
            var productAttr = await _context.ProductAttrs.FindAsync(id);
            if (productAttr == null)
            {
                return NotFound();
            }

            _context.ProductAttrs.Remove(productAttr);
            await _context.SaveChangesAsync();

            return NoContent();
        }

        private bool ProductAttrExists(string id)
        {
            return _context.ProductAttrs.Any(e => e.ProductAttrId == id);
        }
    }
}
