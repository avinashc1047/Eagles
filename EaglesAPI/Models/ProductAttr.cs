using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using Microsoft.EntityFrameworkCore;

namespace Eagles.EF.Models;

[Table("PRODUCT_ATTR")]
public partial class ProductAttr
{
    [Key]
    [Column("PRODUCT_ATTR_ID")]
    [StringLength(32)]
    [Unicode(false)]
    public string ProductAttrId { get; set; } = null!;

    [Column("PRODUCT_ATTR_PRODUCT_ID")]
    [StringLength(32)]
    [Unicode(false)]
    public string ProductAttrProductId { get; set; } = null!;

    [Column("PRODUCT_ACCT_REQ_IND")]
    [Precision(1)]
    public bool ProductAcctReqInd { get; set; }

    [Column("PRODUCT_ATTR_ATTR_ID")]
    [StringLength(32)]
    [Unicode(false)]
    public string ProductAttrAttrId { get; set; } = null!;

    [Column("PRODUCT_ATTR_CRTD_ID")]
    [StringLength(40)]
    [Unicode(false)]
    public string ProductAttrCrtdId { get; set; } = null!;

    [Column("PRODUCT_ATTR_CRTD_DT", TypeName = "DATE")]
    public DateTime ProductAttrCrtdDt { get; set; }

    [Column("PRODUCT_ATTR_UPDT_ID")]
    [StringLength(40)]
    [Unicode(false)]
    public string ProductAttrUpdtId { get; set; } = null!;

    [Column("PRODUCT_ATTR_UPDT_DT", TypeName = "DATE")]
    public DateTime ProductAttrUpdtDt { get; set; }

    [InverseProperty("InventoryAttrValProductAttr")]
    public virtual ICollection<InventoryAttrVal> InventoryAttrVals { get; set; } = new List<InventoryAttrVal>();

    [ForeignKey("ProductAttrAttrId")]
    [InverseProperty("ProductAttrs")]
    public virtual Attr ProductAttrAttr { get; set; } = null!;

    [ForeignKey("ProductAttrProductId")]
    [InverseProperty("ProductAttrs")]
    public virtual Product ProductAttrProduct { get; set; } = null!;
}
