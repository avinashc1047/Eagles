using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using Microsoft.EntityFrameworkCore;

namespace Eagles.EF.Models;

[Table("INVENTORY")]
public partial class Inventory
{
    [Key]
    [Column("INVENTORY_ID")]
    [StringLength(32)]
    [Unicode(false)]
    public string InventoryId { get; set; } = null!;

    [Column("INVENTORY_PRODUCT_ID")]
    [StringLength(32)]
    [Unicode(false)]
    public string InventoryProductId { get; set; } = null!;

    [Column("INVENTORY_SERIAL_NBR")]
    [StringLength(50)]
    [Unicode(false)]
    public string? InventorySerialNbr { get; set; }

    [Column("INVENTORY_CRTD_ID")]
    [StringLength(40)]
    [Unicode(false)]
    public string InventoryCrtdId { get; set; } = null!;

    [Column("INVENTORY_CRTD_DT", TypeName = "DATE")]
    public DateTime InventoryCrtdDt { get; set; }

    [Column("INVENTORY_UPDT_ID")]
    [StringLength(40)]
    [Unicode(false)]
    public string InventoryUpdtId { get; set; } = null!;

    [Column("INVENTORY_UPDT_DT", TypeName = "DATE")]
    public DateTime InventoryUpdtDt { get; set; }

    [ForeignKey("InventoryProductId")]
    [InverseProperty("Inventories")]
    public virtual Product InventoryProduct { get; set; } = null!;

    [InverseProperty("InventoryStateInventory")]
    public virtual ICollection<InventoryState> InventoryStates { get; set; } = new List<InventoryState>();

    [InverseProperty("OrdersLineInventory")]
    public virtual ICollection<OrdersLine> OrdersLines { get; set; } = new List<OrdersLine>();
}
