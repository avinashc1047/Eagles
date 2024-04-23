using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using Microsoft.EntityFrameworkCore;

namespace Eagles.EF.Models;

[Table("INVENTORY_STATE")]
public partial class InventoryState
{
    [Key]
    [Column("INVENTORY_STATE_ID")]
    [StringLength(32)]
    [Unicode(false)]
    public string InventoryStateId { get; set; } = null!;

    [Column("INVENTORY_STATE_TS")]
    [Precision(6)]
    public DateTime InventoryStateTs { get; set; }

    [Column("INVENTORY_STATE_INVENTORY_STATUS_ID")]
    [StringLength(32)]
    [Unicode(false)]
    public string InventoryStateInventoryStatusId { get; set; } = null!;

    [Column("INVENTORY_STATE_INVENTORY_ID")]
    [StringLength(32)]
    [Unicode(false)]
    public string InventoryStateInventoryId { get; set; } = null!;

    [Column("INVENTORY_STATE_CRTD_ID")]
    [StringLength(40)]
    [Unicode(false)]
    public string InventoryStateCrtdId { get; set; } = null!;

    [Column("INVENTORY_STATE_CRTD_DT", TypeName = "DATE")]
    public DateTime InventoryStateCrtdDt { get; set; }

    [Column("INVENTORY_STATE_UPDT_ID")]
    [StringLength(40)]
    [Unicode(false)]
    public string InventoryStateUpdtId { get; set; } = null!;

    [Column("INVENTORY_STATE_UPDT_DT", TypeName = "DATE")]
    public DateTime InventoryStateUpdtDt { get; set; }

    [ForeignKey("InventoryStateInventoryId")]
    [InverseProperty("InventoryStates")]
    public virtual Inventory InventoryStateInventory { get; set; } = null!;

    [ForeignKey("InventoryStateInventoryStatusId")]
    [InverseProperty("InventoryStates")]
    public virtual InventoryStatus InventoryStateInventoryStatus { get; set; } = null!;
}
