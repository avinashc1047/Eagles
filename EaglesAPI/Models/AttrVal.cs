using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using Microsoft.EntityFrameworkCore;

namespace Eagles.EF.Models;

[Table("ATTR_VAL")]
public partial class AttrVal
{
    [Key]
    [Column("ATTR_VAL_ID")]
    [StringLength(32)]
    [Unicode(false)]
    public string AttrValId { get; set; } = null!;

    [Column("ATTR_VAL_VAL")]
    [Unicode(false)]
    public string AttrValVal { get; set; } = null!;

    [Column("ATTR_VAL_CRTD_ID")]
    [StringLength(40)]
    [Unicode(false)]
    public string AttrValCrtdId { get; set; } = null!;

    [Column("ATTR_VAL_CRTD_DT", TypeName = "DATE")]
    public DateTime AttrValCrtdDt { get; set; }

    [Column("ATTR_VAL_UPDT_ID")]
    [StringLength(40)]
    [Unicode(false)]
    public string AttrValUpdtId { get; set; } = null!;

    [Column("ATTR_VAL_UPDT_DT", TypeName = "DATE")]
    public DateTime AttrValUpdtDt { get; set; }

    [InverseProperty("InventoryAttrValAttrVal")]
    public virtual ICollection<InventoryAttrVal> InventoryAttrVals { get; set; } = new List<InventoryAttrVal>();
}
