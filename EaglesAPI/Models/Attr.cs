using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using Microsoft.EntityFrameworkCore;

namespace Eagles.EF.Models;

[Table("ATTR")]
public partial class Attr
{
    [Key]
    [Column("ATTR_ID")]
    [StringLength(32)]
    [Unicode(false)]
    public string AttrId { get; set; } = null!;

    [Column("ATTR_NAME")]
    [StringLength(200)]
    [Unicode(false)]
    public string AttrName { get; set; } = null!;

    [Column("ATTR_DATATYPE")]
    [StringLength(20)]
    [Unicode(false)]
    public string AttrDatatype { get; set; } = null!;

    [Column("ATTR_LENGTH")]
    [Precision(9)]
    public int AttrLength { get; set; }

    [Column("ATTR_PRECISION")]
    [Precision(9)]
    public int? AttrPrecision { get; set; }

    [Column("ATTR_CRTD_ID")]
    [StringLength(40)]
    [Unicode(false)]
    public string AttrCrtdId { get; set; } = null!;

    [Column("ATTR_CRTD_DT", TypeName = "DATE")]
    public DateTime AttrCrtdDt { get; set; }

    [Column("ATTR_UPDT_ID")]
    [StringLength(40)]
    [Unicode(false)]
    public string AttrUpdtId { get; set; } = null!;

    [Column("ATTR_UPDT_DT", TypeName = "DATE")]
    public DateTime AttrUpdtDt { get; set; }

    [InverseProperty("ProductAttrAttr")]
    public virtual ICollection<ProductAttr> ProductAttrs { get; set; } = new List<ProductAttr>();
}
