using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using Microsoft.EntityFrameworkCore;

namespace Eagles.EF.Models;

[Table("INVENTORY_ATTR_VAL")]
public partial class InventoryAttrVal
{
    [Key]
    [Column("INVENTORY_ATTR_VAL_ID")]
    [StringLength(32)]
    [Unicode(false)]
    public string InventoryAttrValId { get; set; } = null!;

    [Column("INVENTORY_ATTR_VAL_INVENTORY_ID")]
    [StringLength(32)]
    [Unicode(false)]
    public string InventoryAttrValInventoryId { get; set; } = null!;

    [Column("INVENTORY_ATTR_VAL_PRODUCT_ATTR_ID")]
    [StringLength(32)]
    [Unicode(false)]
    public string InventoryAttrValProductAttrId { get; set; } = null!;

    [Column("INVENTORY_ATTR_VAL_ATTR_VAL_ID")]
    [StringLength(32)]
    [Unicode(false)]
    public string InventoryAttrValAttrValId { get; set; } = null!;

    [Column("INVENTORY_ATTR_VAL_CRTD_ID")]
    [StringLength(40)]
    [Unicode(false)]
    public string InventoryAttrValCrtdId { get; set; } = null!;

    [Column("INVENTORY_ATTR_VAL_CRTD_DT", TypeName = "DATE")]
    public DateTime InventoryAttrValCrtdDt { get; set; }

    [Column("INVENTORY_ATTR_VAL_UPDT_ID")]
    [StringLength(40)]
    [Unicode(false)]
    public string InventoryAttrValUpdtId { get; set; } = null!;

    [Column("INVENTORY_ATTR_VAL_UPDT_DT", TypeName = "DATE")]
    public DateTime InventoryAttrValUpdtDt { get; set; }

    [ForeignKey("InventoryAttrValAttrValId")]
    [InverseProperty("InventoryAttrVals")]
    public virtual AttrVal InventoryAttrValAttrVal { get; set; } = null!;

    [ForeignKey("InventoryAttrValInventoryId")]
    [InverseProperty("InventoryAttrVals")]
    public virtual Inventory InventoryAttrValInventory { get; set; } = null!;

    [ForeignKey("InventoryAttrValProductAttrId")]
    [InverseProperty("InventoryAttrVals")]
    public virtual ProductAttr InventoryAttrValProductAttr { get; set; } = null!;
}
