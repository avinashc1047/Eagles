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
    public class OrdersLinesController : ControllerBase
    {
        private readonly EaglesOracleContext _context;

        public OrdersLinesController(EaglesOracleContext context)
        {
            _context = context;
        }

        // GET: api/OrdersLines
        [HttpGet]
        public async Task<ActionResult<IEnumerable<OrdersLine>>> GetOrdersLines()
        {
            return await _context.OrdersLines.ToListAsync();
        }

        // GET: api/OrdersLines/5
        [HttpGet("{id}")]
        public async Task<ActionResult<OrdersLine>> GetOrdersLine(string id)
        {
            var ordersLine = await _context.OrdersLines.FindAsync(id);

            if (ordersLine == null)
            {
                return NotFound();
            }

            return ordersLine;
        }

        // PUT: api/OrdersLines/5
        // To protect from overposting attacks, see https://go.microsoft.com/fwlink/?linkid=2123754
        [HttpPut("{id}")]
        public async Task<IActionResult> PutOrdersLine(string id, OrdersLine ordersLine)
        {
            if (id != ordersLine.OrdersLineId)
            {
                return BadRequest();
            }

            _context.Entry(ordersLine).State = EntityState.Modified;

            try
            {
                await _context.SaveChangesAsync();
            }
            catch (DbUpdateConcurrencyException)
            {
                if (!OrdersLineExists(id))
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

        // POST: api/OrdersLines
        // To protect from overposting attacks, see https://go.microsoft.com/fwlink/?linkid=2123754
        [HttpPost]
        public async Task<ActionResult<OrdersLine>> PostOrdersLine(OrdersLine ordersLine)
        {
            _context.OrdersLines.Add(ordersLine);
            await _context.SaveChangesAsync();

            return CreatedAtAction("GetOrdersLine", new { id = ordersLine.OrdersLineId }, ordersLine);
        }

        // DELETE: api/OrdersLines/5
        [HttpDelete("{id}")]
        public async Task<IActionResult> DeleteOrdersLine(string id)
        {
            var ordersLine = await _context.OrdersLines.FindAsync(id);
            if (ordersLine == null)
            {
                return NotFound();
            }

            _context.OrdersLines.Remove(ordersLine);
            await _context.SaveChangesAsync();

            return NoContent();
        }

        private bool OrdersLineExists(string id)
        {
            return _context.OrdersLines.Any(e => e.OrdersLineId == id);
        }
    }
}
