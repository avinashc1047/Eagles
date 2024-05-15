using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using Microsoft.EntityFrameworkCore;

namespace Eagles.EF.Models;

[Table("PRODUCT")]
public partial class Product
{
    [Key]
    [Column("PRODUCT_ID")]
    [StringLength(32)]
    [Unicode(false)]
    public string ProductId { get; set; } = null!;

    [Column("PRODUCT_NAME")]
    [StringLength(200)]
    [Unicode(false)]
    public string ProductName { get; set; } = null!;

    [Column("PRODUCT_DESC")]
    [StringLength(2000)]
    [Unicode(false)]
    public string ProductDesc { get; set; } = null!;

    [Column("PRODUCT_PRODUCT_STATUS_ID")]
    [StringLength(32)]
    [Unicode(false)]
    public string ProductProductStatusId { get; set; } = null!;

    [Column("PRODUCT_CRTD_ID")]
    [StringLength(40)]
    [Unicode(false)]
    public string ProductCrtdId { get; set; } = null!;

    [Column("PRODUCT_CRTD_DT", TypeName = "DATE")]
    public DateTime ProductCrtdDt { get; set; }

    [Column("PRODUCT_UPDT_ID")]
    [StringLength(40)]
    [Unicode(false)]
    public string ProductUpdtId { get; set; } = null!;

    [Column("PRODUCT_UPDT_DT", TypeName = "DATE")]
    public DateTime ProductUpdtDt { get; set; }

    [InverseProperty("InventoryProduct")]
    public virtual ICollection<Inventory> Inventories { get; set; } = new List<Inventory>();

    [InverseProperty("ProductAttrProduct")]
    public virtual ICollection<ProductAttr> ProductAttrs { get; set; } = new List<ProductAttr>();

    [InverseProperty("ProductPriceProduct")]
    public virtual ICollection<ProductPrice> ProductPrices { get; set; } = new List<ProductPrice>();

    [ForeignKey("ProductProductStatusId")]
    [InverseProperty("Products")]
    public virtual ProductStatus ProductProductStatus { get; set; } = null!;
}
