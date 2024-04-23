using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using Microsoft.EntityFrameworkCore;

namespace Eagles.EF.Models;

[Table("INVENTORY_STATUS")]
public partial class InventoryStatus
{
    [Key]
    [Column("INVENTORY_STATUS_ID")]
    [StringLength(32)]
    [Unicode(false)]
    public string InventoryStatusId { get; set; } = null!;

    [Column("INVENTORY_STATUS_DESC")]
    [StringLength(20)]
    [Unicode(false)]
    public string InventoryStatusDesc { get; set; } = null!;

    [Column("INVENTORY_STATUS_CRTD_ID")]
    [StringLength(40)]
    [Unicode(false)]
    public string InventoryStatusCrtdId { get; set; } = null!;

    [Column("INVENTORY_STATUS_CRTD_DT", TypeName = "DATE")]
    public DateTime InventoryStatusCrtdDt { get; set; }

    [Column("INVENTORY_STATUS_UPDT_ID")]
    [StringLength(40)]
    [Unicode(false)]
    public string InventoryStatusUpdtId { get; set; } = null!;

    [Column("INVENTORY_STATUS_UPDT_DT", TypeName = "DATE")]
    public DateTime InventoryStatusUpdtDt { get; set; }

    [InverseProperty("InventoryStateInventoryStatus")]
    public virtual ICollection<InventoryState> InventoryStates { get; set; } = new List<InventoryState>();
}
