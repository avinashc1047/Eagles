-- Avinash Chouhan
-- PS6

-- Tables
CREATE TABLE attr_val (
    attr_val_id      VARCHAR2(32) NOT NULL,
    attr_val_val     VARCHAR2(4000) NOT NULL,
    attr_val_crtd_id VARCHAR2(40) NOT NULL,
    attr_val_crtd_dt DATE NOT NULL,
    attr_val_updt_id VARCHAR2(40) NOT NULL,
    attr_val_updt_dt DATE NOT NULL,
    CONSTRAINT attr_val_pk PRIMARY KEY ( attr_val_id ) ENABLE
);

CREATE OR REPLACE TRIGGER trg01_attr_val BEFORE
    INSERT OR UPDATE ON attr_val
    FOR EACH ROW
BEGIN
    IF inserting THEN
        :new.attr_val_crtd_id := user;
        :new.attr_val_crtd_dt := sysdate;
    END IF;

    :new.attr_val_updt_id := user;
    :new.attr_val_updt_dt := sysdate;
END;
/

CREATE OR REPLACE TRIGGER trg02_attr_val BEFORE
    INSERT OR UPDATE ON attr_val
    FOR EACH ROW
BEGIN
    IF inserting THEN
        :new.attr_val_id := sys_guid();
    ELSE
        :new.attr_val_id := :old.attr_val_id;
    END IF;
END;
/

CREATE TABLE attr (
    attr_id        VARCHAR2(32) NOT NULL,
    attr_name      VARCHAR2(200) NOT NULL,
    attr_datatype  VARCHAR2(20) NOT NULL,
    attr_length    NUMBER(9) NOT NULL,
    attr_precision NUMBER(9),
    attr_crtd_id   VARCHAR2(40) NOT NULL,
    attr_crtd_dt   DATE NOT NULL,
    attr_updt_id   VARCHAR2(40) NOT NULL,
    attr_updt_dt   DATE NOT NULL,
    CONSTRAINT attr_pk PRIMARY KEY ( attr_id ) ENABLE
);

CREATE OR REPLACE TRIGGER trg01_attr BEFORE
    INSERT OR UPDATE ON attr
    FOR EACH ROW
BEGIN
    IF inserting THEN
        :new.attr_crtd_id := user;
        :new.attr_crtd_dt := sysdate;
    END IF;

    :new.attr_updt_id := user;
    :new.attr_updt_dt := sysdate;
END;
/

CREATE OR REPLACE TRIGGER trg02_attr BEFORE
    INSERT OR UPDATE ON attr
    FOR EACH ROW
BEGIN
    IF inserting THEN
        :new.attr_id := sys_guid();
    ELSE
        :new.attr_id := :old.attr_id;
    END IF;
END;
/

CREATE TABLE product_attr (
    product_attr_id         VARCHAR2(32) NOT NULL,
    product_attr_product_id VARCHAR2(32) NOT NULL,
    product_acct_req_ind    NUMBER(1) NOT NULL,
    product_attr_attr_id    VARCHAR2(32) NOT NULL,
    product_attr_crtd_id    VARCHAR2(40) NOT NULL,
    product_attr_crtd_dt    DATE NOT NULL,
    product_attr_updt_id    VARCHAR2(40) NOT NULL,
    product_attr_updt_dt    DATE NOT NULL,
    CONSTRAINT product_attr_pk PRIMARY KEY ( product_attr_id ) ENABLE
);

ALTER TABLE product_attr
    ADD CONSTRAINT product_attr_fk1 FOREIGN KEY ( product_attr_product_id )
        REFERENCES product ( product_id )
    ENABLE;

ALTER TABLE product_attr
    ADD CONSTRAINT product_attr_fk2 FOREIGN KEY ( product_attr_attr_id )
        REFERENCES attr ( attr_id )
    ENABLE;

CREATE OR REPLACE TRIGGER trg01_product_attr BEFORE
    INSERT OR UPDATE ON product_attr
    FOR EACH ROW
BEGIN
    IF inserting THEN
        :new.product_attr_crtd_id := user;
        :new.product_attr_crtd_dt := sysdate;
    END IF;

    :new.product_attr_updt_id := user;
    :new.product_attr_updt_dt := sysdate;
END;
/

CREATE OR REPLACE TRIGGER trg02_product_attr BEFORE
    INSERT OR UPDATE ON product_attr
    FOR EACH ROW
BEGIN
    IF inserting THEN
        :new.product_attr_id := sys_guid();
    ELSE
        :new.product_attr_id := :old.product_attr_id;
    END IF;
END;
/

CREATE TABLE inventory_attr_val (
    inventory_attr_val_id              VARCHAR2(32) NOT NULL,
    inventory_attr_val_inventory_id    VARCHAR2(32) NOT NULL,
    inventory_attr_val_product_attr_id VARCHAR2(32) NOT NULL,
    inventory_attr_val_attr_val_id     VARCHAR2(32) NOT NULL,
    inventory_attr_val_crtd_id         VARCHAR2(40) NOT NULL,
    inventory_attr_val_crtd_dt         DATE NOT NULL,
    inventory_attr_val_updt_id         VARCHAR2(40) NOT NULL,
    inventory_attr_val_updt_dt         DATE NOT NULL,
    CONSTRAINT inventory_attr_val_pk PRIMARY KEY ( inventory_attr_val_id ) ENABLE
);

ALTER TABLE inventory_attr_val
    ADD CONSTRAINT inventory_attr_val_fk1 FOREIGN KEY ( inventory_attr_val_inventory_id )
        REFERENCES inventory ( inventory_id )
    ENABLE;

ALTER TABLE inventory_attr_val
    ADD CONSTRAINT inventory_attr_val_fk2 FOREIGN KEY ( inventory_attr_val_product_attr_id )
        REFERENCES product_attr ( product_attr_id )
    ENABLE;

ALTER TABLE inventory_attr_val
    ADD CONSTRAINT inventory_attr_val_fk3 FOREIGN KEY ( inventory_attr_val_attr_val_id )
        REFERENCES attr_val ( attr_val_id )
    ENABLE;

ALTER TABLE inventory DROP COLUMN inventory_serial_nbr;

CREATE OR REPLACE TRIGGER trg01_inventory_attr_val BEFORE
    INSERT OR UPDATE ON inventory_attr_val
    FOR EACH ROW
BEGIN
    IF inserting THEN
        :new.inventory_attr_val_crtd_id := user;
        :new.inventory_attr_val_crtd_dt := sysdate;
    END IF;

    :new.inventory_attr_val_updt_id := user;
    :new.inventory_attr_val_updt_dt := sysdate;
END;
/

CREATE OR REPLACE TRIGGER trg02_inventory_attr_val BEFORE
    INSERT OR UPDATE ON inventory_attr_val
    FOR EACH ROW
BEGIN
    IF inserting THEN
        :new.inventory_attr_val_id := sys_guid();
    ELSE
        :new.inventory_attr_val_id := :old.inventory_attr_val_id;
    END IF;
END;
/

-- inventory triggers
CREATE OR REPLACE TRIGGER trg01_inventory BEFORE
    INSERT OR UPDATE ON inventory
    FOR EACH ROW
BEGIN
    IF inserting THEN
        :new.inventory_crtd_id := user;
        :new.inventory_crtd_dt := sysdate;
    END IF;

    :new.inventory_updt_id := user;
    :new.inventory_updt_dt := sysdate;
END;
/

CREATE OR REPLACE TRIGGER trg02_inventory BEFORE
    INSERT OR UPDATE ON inventory
    FOR EACH ROW
BEGIN
    IF inserting THEN
        :new.inventory_id := sys_guid();
    ELSE
        :new.inventory_id := :old.inventory_id;
    END IF;
END;
/

-- Packages
-- Product Status
CREATE OR REPLACE PACKAGE pkg_product_status AS
    FUNCTION getorcreate_product_status (
        product_status_desc_in product_status.product_status_desc%TYPE
    ) RETURN VARCHAR2;

    FUNCTION insert_product_status (
        product_status_desc_in product_status.product_status_desc%TYPE
    ) RETURN VARCHAR2;

END pkg_product_status;
/

CREATE OR REPLACE PACKAGE BODY pkg_product_status AS

    FUNCTION getorcreate_product_status (
        product_status_desc_in product_status.product_status_desc%TYPE
    ) RETURN VARCHAR2 AS
        v_key   product_status.product_status_id%TYPE;
        v_count NUMBER(3);
    BEGIN
        SELECT
            COUNT(*)
        INTO v_count
        FROM
            product_status
        WHERE
            product_status_desc = product_status_desc_in;

        IF v_count = 1 THEN
            SELECT
                product_status_id
            INTO v_key
            FROM
                product_status
            WHERE
                product_status_desc = product_status_desc_in;

            RETURN v_key;
        END IF;

        RETURN insert_product_status(product_status_desc_in);
    END getorcreate_product_status;

    FUNCTION insert_product_status (
        product_status_desc_in product_status.product_status_desc%TYPE
    ) RETURN VARCHAR2 AS
        v_key product_status.product_status_id%TYPE;
    BEGIN
        INSERT INTO product_status ( product_status_desc ) VALUES ( product_status_desc_in ) RETURNING product_status_id INTO v_key;

        RETURN v_key;
    END insert_product_status;

END pkg_product_status;
/

-- Product
CREATE OR REPLACE PACKAGE pkg_product AS
    FUNCTION insert_product_attr (
        product_attr_product_id_in product_attr.product_attr_product_id%TYPE,
        product_acct_req_ind_in    product_attr.product_acct_req_ind%TYPE,
        product_attr_attr_id_in    product_attr.product_attr_attr_id%TYPE
    ) RETURN VARCHAR2;

    FUNCTION insert_full_product (
        product_name_in           product.product_name%TYPE,
        product_desc_in           product.product_desc%TYPE,
        product_status_desc_in    product_status.product_status_desc%TYPE,
        product_price_eff_date_in product_price.product_price_eff_date%TYPE,
        product_price_price_in    product_price.product_price_price%TYPE
    ) RETURN VARCHAR2;

    PROCEDURE associate_product_attr (
        product_id_in           product.product_id%TYPE,
        attr_name_in            attr.attr_name%TYPE,
        attr_datatype_in        attr.attr_datatype%TYPE,
        attr_length_in          attr.attr_length%TYPE,
        attr_precision_in       attr.attr_precision%TYPE,
        product_attr_req_ind_in product_attr.product_acct_req_ind%TYPE
    );

END pkg_product;
/

CREATE OR REPLACE PACKAGE BODY pkg_product AS

    FUNCTION insert_product_attr (
        product_attr_product_id_in product_attr.product_attr_product_id%TYPE,
        product_acct_req_ind_in    product_attr.product_acct_req_ind%TYPE,
        product_attr_attr_id_in    product_attr.product_attr_attr_id%TYPE
    ) RETURN VARCHAR2 AS
        v_key product_attr.product_attr_id%TYPE;
    BEGIN
        INSERT INTO product_attr (
            product_attr_product_id,
            product_acct_req_ind,
            product_attr_attr_id
        ) VALUES (
            product_attr_product_id_in,
            product_acct_req_ind_in,
            product_attr_attr_id_in
        ) RETURNING product_attr_id INTO v_key;

        RETURN v_key;
    END insert_product_attr;

    PROCEDURE insert_product_price (
        product_price_product_id_in IN product_price.product_price_id%TYPE,
        product_price_eff_date_in   IN product_price.product_price_eff_date%TYPE,
        product_price_price_in      IN product_price.product_price_price%TYPE
    ) AS
    BEGIN
        INSERT INTO product_price (
            product_price_product_id,
            product_price_eff_date,
            product_price_price
        ) VALUES (
            product_price_product_id_in,
            product_price_eff_date_in,
            product_price_price_in
        );

    END insert_product_price;

    FUNCTION insert_product (
        product_name_in              product.product_name%TYPE,
        product_desc_in              product.product_desc%TYPE,
        product_product_status_id_in product.product_product_status_id%TYPE
    ) RETURN VARCHAR2 AS
        v_key product.product_id%TYPE;
    BEGIN
        INSERT INTO product (
            product_name,
            product_desc,
            product_product_status_id
        ) VALUES (
            product_name_in,
            product_desc_in,
            product_product_status_id_in
        ) RETURNING product_id INTO v_key;

        RETURN v_key;
    END insert_product;

    FUNCTION insert_full_product (
        product_name_in           product.product_name%TYPE,
        product_desc_in           product.product_desc%TYPE,
        product_status_desc_in    product_status.product_status_desc%TYPE,
        product_price_eff_date_in product_price.product_price_eff_date%TYPE,
        product_price_price_in    product_price.product_price_price%TYPE
    ) RETURN VARCHAR2 AS
        v_product_status_id product_status.product_status_id%TYPE;
        v_product_id        product.product_id%TYPE;
    BEGIN
        v_product_status_id := pkg_product_status.getorcreate_product_status(product_status_desc_in);
        v_product_id := insert_product(product_name_in, product_desc_in, v_product_status_id);
        insert_product_price(v_product_id, product_price_eff_date_in, product_price_price_in);
        RETURN v_product_id;
    END insert_full_product;

    PROCEDURE associate_product_attr (
        product_id_in           product.product_id%TYPE,
        attr_name_in            attr.attr_name%TYPE,
        attr_datatype_in        attr.attr_datatype%TYPE,
        attr_length_in          attr.attr_length%TYPE,
        attr_precision_in       attr.attr_precision%TYPE,
        product_attr_req_ind_in product_attr.product_acct_req_ind%TYPE
    ) AS
        v_attr_id         attr.attr_id%TYPE;
        v_product_attr_id product_attr.product_attr_id%TYPE;
    BEGIN
        v_attr_id := pkg_attr.getorcreate_attr(attr_name_in, attr_datatype_in, attr_length_in, attr_precision_in);
        v_product_attr_id := insert_product_attr(product_id_in, product_attr_req_ind_in, v_attr_id);
    END associate_product_attr;

END pkg_product;
/

-- Attribute
CREATE OR REPLACE PACKAGE pkg_attr AS
    FUNCTION getorcreate_attr (
        attr_name_in      attr.attr_name%TYPE,
        attr_datatype_in  attr.attr_datatype%TYPE,
        attr_length_in    attr.attr_length%TYPE,
        attr_precision_in attr.attr_precision%TYPE
    ) RETURN VARCHAR2;

    FUNCTION insert_attr (
        attr_name_in      attr.attr_name%TYPE,
        attr_datatype_in  attr.attr_datatype%TYPE,
        attr_length_in    attr.attr_length%TYPE,
        attr_precision_in attr.attr_precision%TYPE
    ) RETURN VARCHAR2;

END pkg_attr;
/

CREATE OR REPLACE PACKAGE BODY pkg_attr AS

    FUNCTION getorcreate_attr (
        attr_name_in      attr.attr_name%TYPE,
        attr_datatype_in  attr.attr_datatype%TYPE,
        attr_length_in    attr.attr_length%TYPE,
        attr_precision_in attr.attr_precision%TYPE
    ) RETURN VARCHAR2 AS
        v_key   attr.attr_id%TYPE;
        v_count NUMBER(3);
    BEGIN
        SELECT
            COUNT(*)
        INTO v_count
        FROM
            attr
        WHERE
                attr_name = attr_name_in
            AND upper(attr_datatype) = upper(attr_datatype_in)
            AND attr_length = attr_length_in
            AND attr_precision = attr_precision_in;

        IF v_count = 1 THEN
            SELECT
                attr_id
            INTO v_key
            FROM
                attr
            WHERE
                    attr_name = attr_name_in
                AND upper(attr_datatype) = upper(attr_datatype_in)
                AND attr_length = attr_length_in
                AND attr_precision = attr_precision_in;

            RETURN v_key;
        END IF;

        v_key := pkg_attr.insert_attr(attr_name_in, attr_datatype_in, attr_length_in, attr_precision_in);
        RETURN v_key;
    END getorcreate_attr;

    FUNCTION insert_attr (
        attr_name_in      attr.attr_name%TYPE,
        attr_datatype_in  attr.attr_datatype%TYPE,
        attr_length_in    attr.attr_length%TYPE,
        attr_precision_in attr.attr_precision%TYPE
    ) RETURN VARCHAR2 AS
        v_key attr.attr_id%TYPE;
    BEGIN
        INSERT INTO attr (
            attr_name,
            attr_datatype,
            attr_length,
            attr_precision
        ) VALUES (
            attr_name_in,
            upper(attr_datatype_in),
            attr_length_in,
            attr_precision_in
        ) RETURNING attr_id INTO v_key;

        RETURN v_key;
    END insert_attr;

END pkg_attr;
/

-- Attribute Value
CREATE OR REPLACE PACKAGE pkg_attr_val AS
    FUNCTION getorcreate_attr_val_id (
        attr_val_val_in attr_val.attr_val_val%TYPE
    ) RETURN VARCHAR2;

    FUNCTION insert_attr_val (
        attr_val_val_in attr_val.attr_val_val%TYPE
    ) RETURN VARCHAR2;

END pkg_attr_val;
/

CREATE OR REPLACE PACKAGE BODY pkg_attr_val AS

    FUNCTION getorcreate_attr_val_id (
        attr_val_val_in attr_val.attr_val_val%TYPE
    ) RETURN VARCHAR2 AS
        v_attr_val_id attr_val.attr_val_id%TYPE;
        v_count       NUMBER(3);
    BEGIN
        SELECT
            COUNT(*)
        INTO v_count
        FROM
            attr_val
        WHERE
            attr_val_val = attr_val_val_in;

        IF v_count = 1 THEN
            SELECT
                attr_val_id
            INTO v_attr_val_id
            FROM
                attr_val
            WHERE
                attr_val_val = attr_val_val_in;

            RETURN v_attr_val_id;
        END IF;

        v_attr_val_id := pkg_attr_val.insert_attr_val(attr_val_val_in);
        RETURN v_attr_val_id;
    END getorcreate_attr_val_id;

    FUNCTION insert_attr_val (
        attr_val_val_in attr_val.attr_val_val%TYPE
    ) RETURN VARCHAR2 AS
        v_attr_val_id attr_val.attr_val_id%TYPE;
    BEGIN
        INSERT INTO attr_val ( attr_val_val ) VALUES ( attr_val_val_in ) RETURNING attr_val_id INTO v_attr_val_id;

        RETURN v_attr_val_id;
    END insert_attr_val;

END pkg_attr_val;
/

-- Inventory
CREATE OR REPLACE PACKAGE pkg_inventory AS
    FUNCTION insert_full_inventory (
        product_name_in           product.product_name%TYPE,
        product_desc_in           product.product_desc%TYPE,
        product_status_desc_in    product_status.product_status_desc%TYPE,
        product_price_eff_date_in product_price.product_price_eff_date%TYPE,
        product_price_price_in    product_price.product_price_price%TYPE
    ) RETURN VARCHAR2;

    PROCEDURE assoc_inv_attr_val (
        attr_val_val_in           attr_val.attr_val_val%TYPE,
        product_name_in           product.product_name%TYPE,
        product_desc_in           product.product_desc%TYPE,
        product_status_desc_in    product_status.product_status_desc%TYPE,
        product_price_eff_date_in product_price.product_price_eff_date%TYPE,
        product_price_price_in    product_price.product_price_price%TYPE,
        product_acct_req_id_in    product_attr.product_acct_req_ind%TYPE,
        attr_name_in              attr.attr_name%TYPE,
        attr_datatype_in          attr.attr_datatype%TYPE,
        attr_length_in            attr.attr_length%TYPE,
        attr_precision_in         attr.attr_precision%TYPE,
        v_inv_id_in               inventory.inventory_id%TYPE
    );

END pkg_inventory;
/

CREATE OR REPLACE PACKAGE BODY pkg_inventory AS

    FUNCTION insert_inv_attr_val (
        inv_attr_val_inv_id_in          inventory_attr_val.inventory_attr_val_inventory_id%TYPE,
        inv_attr_val_product_attr_id_in inventory_attr_val.inventory_attr_val_product_attr_id%TYPE,
        inv_attr_val_attr_val_id_in     inventory_attr_val.inventory_attr_val_attr_val_id%TYPE
    ) RETURN VARCHAR2 AS
        v_inv_attr_val_id inventory_attr_val.inventory_attr_val_id%TYPE;
    BEGIN
        INSERT INTO inventory_attr_val (
            inventory_attr_val_inventory_id,
            inventory_attr_val_product_attr_id,
            inventory_attr_val_attr_val_id
        ) VALUES (
            inv_attr_val_inv_id_in,
            inv_attr_val_product_attr_id_in,
            inv_attr_val_attr_val_id_in
        ) RETURNING inventory_attr_val_id INTO v_inv_attr_val_id;

        RETURN v_inv_attr_val_id;
    END insert_inv_attr_val;

    FUNCTION getorcreate_product_id (
        product_name_in           product.product_name%TYPE,
        product_desc_in           product.product_desc%TYPE,
        product_status_desc_in    product_status.product_status_desc%TYPE,
        product_price_eff_date_in product_price.product_price_eff_date%TYPE,
        product_price_price_in    product_price.product_price_price%TYPE
    ) RETURN VARCHAR2 AS
        v_product_id product.product_id%TYPE;
        v_count      NUMBER(3);
    BEGIN
        SELECT
            COUNT(*)
        INTO v_count
        FROM
            product
        WHERE
            product_name = product_name_in;

        IF v_count = 1 THEN
            SELECT
                product_id
            INTO v_product_id
            FROM
                product
            WHERE
                product_name = product_name_in;

            RETURN v_product_id;
        END IF;

        RETURN pkg_product.insert_full_product(product_name_in, product_desc_in, product_status_desc_in, product_price_eff_date_in, product_price_price_in
        );
    END getorcreate_product_id;

    FUNCTION getorcreate_product_attr_id (
        product_id_in           product_attr.product_attr_product_id%TYPE,
        attr_id_in              product_attr.product_attr_attr_id%TYPE,
        product_acct_req_ind_in product_attr.product_acct_req_ind%TYPE
    ) RETURN VARCHAR2 AS
        v_product_attr_id product_attr.product_attr_id%TYPE;
        v_count           NUMBER(3);
    BEGIN
        SELECT
            COUNT(*)
        INTO v_count
        FROM
            product_attr
        WHERE
                product_attr_product_id = product_id_in
            AND product_attr_attr_id = attr_id_in
            AND product_acct_req_ind_in = product_acct_req_ind;

        IF v_count = 1 THEN
            SELECT
                product_attr_id
            INTO v_product_attr_id
            FROM
                product_attr
            WHERE
                    product_attr_product_id = product_id_in
                AND product_attr_attr_id = attr_id_in
                AND product_acct_req_ind_in = product_acct_req_ind;

            RETURN v_product_attr_id;
        END IF;

        RETURN pkg_product.insert_product_attr(product_id_in, product_acct_req_ind_in, attr_id_in);
    END getorcreate_product_attr_id;

    FUNCTION insert_inventory_basic (
        inv_product_id_in product.product_id%TYPE
    ) RETURN VARCHAR2 AS
        v_inv_id inventory.inventory_id%TYPE;
    BEGIN
        INSERT INTO inventory ( inventory_product_id ) VALUES ( inv_product_id_in ) RETURNING inventory_id INTO v_inv_id;

        RETURN v_inv_id;
    END insert_inventory_basic;

    FUNCTION insert_full_inventory (
        product_name_in           product.product_name%TYPE,
        product_desc_in           product.product_desc%TYPE,
        product_status_desc_in    product_status.product_status_desc%TYPE,
        product_price_eff_date_in product_price.product_price_eff_date%TYPE,
        product_price_price_in    product_price.product_price_price%TYPE
    ) RETURN VARCHAR2 AS
        v_product_id product.product_id%TYPE;
        v_inv_id     inventory.inventory_id%TYPE;
    BEGIN
        v_product_id := pkg_inventory.getorcreate_product_id(product_name_in, product_desc_in, product_status_desc_in, product_price_eff_date_in
        , product_price_price_in);
        v_inv_id := insert_inventory_basic(v_product_id);
        RETURN v_inv_id;
    END insert_full_inventory;

    PROCEDURE assoc_inv_attr_val (
        attr_val_val_in           attr_val.attr_val_val%TYPE,
        product_name_in           product.product_name%TYPE,
        product_desc_in           product.product_desc%TYPE,
        product_status_desc_in    product_status.product_status_desc%TYPE,
        product_price_eff_date_in product_price.product_price_eff_date%TYPE,
        product_price_price_in    product_price.product_price_price%TYPE,
        product_acct_req_id_in    product_attr.product_acct_req_ind%TYPE,
        attr_name_in              attr.attr_name%TYPE,
        attr_datatype_in          attr.attr_datatype%TYPE,
        attr_length_in            attr.attr_length%TYPE,
        attr_precision_in         attr.attr_precision%TYPE,
        v_inv_id_in               inventory.inventory_id%TYPE
    ) AS

        v_attr_val_id     attr_val.attr_val_id%TYPE;
        v_inv_attr_val_id inventory_attr_val.inventory_attr_val_id%TYPE;
        v_product_id      product_attr.product_attr_product_id%TYPE;
        v_attr_id         product_attr.product_attr_attr_id%TYPE;
        v_product_attr_id product_attr.product_attr_id%TYPE;
    BEGIN
        v_attr_val_id := pkg_attr_val.getorcreate_attr_val_id(attr_val_val_in);
        v_product_id := pkg_inventory.getorcreate_product_id(product_name_in, product_desc_in, product_status_desc_in, product_price_eff_date_in
        , product_price_price_in);
        v_attr_id := pkg_attr.getorcreate_attr(attr_name_in, attr_datatype_in, attr_length_in, attr_precision_in);
        v_product_attr_id := pkg_inventory.getorcreate_product_attr_id(v_product_id, v_attr_id, product_acct_req_id_in);
        v_inv_attr_val_id := insert_inv_attr_val(v_inv_id_in, v_product_attr_id, v_attr_val_id);
    END assoc_inv_attr_val;

END pkg_inventory;
/

-- Insert Products
DECLARE v_product VARCHAR2(40);
BEGIN
    v_product := pkg_product.insert_full_product('Iphone', 'Iphone', 'NEW', to_date('2022-01-01', 'yyyy-mm-dd'), 850);
    pkg_product.associate_product_attr(v_product, 'Battery', 'NUMBER', '10000', NULL, 1);
    pkg_product.associate_product_attr(v_product, 'Model', 'VARCHAR2', '5', NULL, 1);
    pkg_product.associate_product_attr(v_product, 'Color', 'VARCHAR2', '10', NULL, 1);
    pkg_product.associate_product_attr(v_product, 'Processor', 'VARCHAR2', '10', NULL, 1);
    pkg_product.associate_product_attr(v_product, 'Size', 'VARCHAR2', '10', NULL, 1);
    
    v_product := pkg_product.insert_full_product('Ipad', 'Ipad', 'NEW', to_date('2022-01-01', 'yyyy-mm-dd'), 1150);
    pkg_product.associate_product_attr(v_product, 'Battery', 'NUMBER', '10000', NULL, 1);
    pkg_product.associate_product_attr(v_product, 'Model', 'VARCHAR2', '5', NULL, 1);
    pkg_product.associate_product_attr(v_product, 'Color', 'VARCHAR2', '10', NULL, 1);
    pkg_product.associate_product_attr(v_product, 'Processor', 'VARCHAR2', '10', NULL, 1);
    pkg_product.associate_product_attr(v_product, 'Size', 'VARCHAR2', '10', NULL, 1);
    
    v_product := pkg_product.insert_full_product('MacBook', 'MacBook', 'NEW', to_date('2022-01-01', 'yyyy-mm-dd'), 1500);
    pkg_product.associate_product_attr(v_product, 'Battery', 'NUMBER', '10000', NULL, 1);
    pkg_product.associate_product_attr(v_product, 'Model', 'VARCHAR2', '5', NULL, 1);
    pkg_product.associate_product_attr(v_product, 'Color', 'VARCHAR2', '10', NULL, 1);
    pkg_product.associate_product_attr(v_product, 'Processor', 'VARCHAR2', '10', NULL, 1);
    pkg_product.associate_product_attr(v_product, 'Size', 'VARCHAR2', '10', NULL, 1);
END;
/

-- Insert Inventory
DECLARE v_inventory_id  VARCHAR2(40);
BEGIN
    --iphone inventory
    v_inventory_id := pkg_inventory.insert_full_inventory('Iphone', 'Iphone', 'NEW', to_date('2022-01-01', 'yyyy-mm-dd'), 850);
    pkg_inventory.assoc_inv_attr_val(3750, 'Iphone', 'Iphone', 'NEW', to_date('2022-01-01', 'yyyy-mm-dd'), 850, 1, 'Battery', 'NUMBER', '10000', NULL, v_inventory_id);
    pkg_inventory.assoc_inv_attr_val('15', 'Iphone', 'Iphone', 'NEW', to_date('2022-01-01', 'yyyy-mm-dd'), 850, 1, 'Model', 'VARCHAR2', '5', NULL, v_inventory_id);
    pkg_inventory.assoc_inv_attr_val('Silver', 'Iphone', 'Iphone', 'NEW', to_date('2022-01-01', 'yyyy-mm-dd'), 850, 1, 'Color', 'VARCHAR2', '10', NULL, v_inventory_id);
    pkg_inventory.assoc_inv_attr_val('A16', 'Iphone', 'Iphone', 'NEW', to_date('2022-01-01', 'yyyy-mm-dd'), 850, 1, 'Processor', 'VARCHAR2', '10', NULL, v_inventory_id);
    pkg_inventory.assoc_inv_attr_val('Pro', 'Iphone', 'Iphone', 'NEW', to_date('2022-01-01', 'yyyy-mm-dd'), 850, 1, 'Size', 'VARCHAR2', '10', NULL, v_inventory_id);
    
    v_inventory_id := pkg_inventory.insert_full_inventory('Iphone', 'Iphone', 'NEW', to_date('2022-01-01', 'yyyy-mm-dd'), 850);
    pkg_inventory.assoc_inv_attr_val(3750, 'Iphone', 'Iphone', 'NEW', to_date('2022-01-01', 'yyyy-mm-dd'), 850, 1, 'Battery', 'NUMBER', '10000', NULL, v_inventory_id);
    pkg_inventory.assoc_inv_attr_val('15', 'Iphone', 'Iphone', 'NEW', to_date('2022-01-01', 'yyyy-mm-dd'), 850, 1, 'Model', 'VARCHAR2', '5', NULL, v_inventory_id);
    pkg_inventory.assoc_inv_attr_val('Black', 'Iphone', 'Iphone', 'NEW', to_date('2022-01-01', 'yyyy-mm-dd'), 850, 1, 'Color', 'VARCHAR2', '10', NULL, v_inventory_id);
    pkg_inventory.assoc_inv_attr_val('A16', 'Iphone', 'Iphone', 'NEW', to_date('2022-01-01', 'yyyy-mm-dd'), 850, 1, 'Processor', 'VARCHAR2', '10', NULL, v_inventory_id);
    pkg_inventory.assoc_inv_attr_val('Pro', 'Iphone', 'Iphone', 'NEW', to_date('2022-01-01', 'yyyy-mm-dd'), 850, 1, 'Size', 'VARCHAR2', '10', NULL, v_inventory_id);

    v_inventory_id := pkg_inventory.insert_full_inventory('Iphone', 'Iphone', 'NEW', to_date('2022-01-01', 'yyyy-mm-dd'), 850);
    pkg_inventory.assoc_inv_attr_val(3750, 'Iphone', 'Iphone', 'NEW', to_date('2022-01-01', 'yyyy-mm-dd'), 850, 1, 'Battery', 'NUMBER', '10000', NULL, v_inventory_id);
    pkg_inventory.assoc_inv_attr_val('15', 'Iphone', 'Iphone', 'NEW', to_date('2022-01-01', 'yyyy-mm-dd'), 850, 1, 'Model', 'VARCHAR2', '5', NULL, v_inventory_id);
    pkg_inventory.assoc_inv_attr_val('Red', 'Iphone', 'Iphone', 'NEW', to_date('2022-01-01', 'yyyy-mm-dd'), 850, 1, 'Color', 'VARCHAR2', '10', NULL, v_inventory_id);
    pkg_inventory.assoc_inv_attr_val('A16', 'Iphone', 'Iphone', 'NEW', to_date('2022-01-01', 'yyyy-mm-dd'), 850, 1, 'Processor', 'VARCHAR2', '10', NULL, v_inventory_id);
    pkg_inventory.assoc_inv_attr_val('Pro', 'Iphone', 'Iphone', 'NEW', to_date('2022-01-01', 'yyyy-mm-dd'), 850, 1, 'Size', 'VARCHAR2', '10', NULL, v_inventory_id);

    v_inventory_id := pkg_inventory.insert_full_inventory('Iphone', 'Iphone', 'NEW', to_date('2022-01-01', 'yyyy-mm-dd'), 850);
    pkg_inventory.assoc_inv_attr_val(3750, 'Iphone', 'Iphone', 'NEW', to_date('2022-01-01', 'yyyy-mm-dd'), 850, 1, 'Battery', 'NUMBER', '10000', NULL, v_inventory_id);
    pkg_inventory.assoc_inv_attr_val('15', 'Iphone', 'Iphone', 'NEW', to_date('2022-01-01', 'yyyy-mm-dd'), 850, 1, 'Model', 'VARCHAR2', '5', NULL, v_inventory_id);
    pkg_inventory.assoc_inv_attr_val('Gold', 'Iphone', 'Iphone', 'NEW', to_date('2022-01-01', 'yyyy-mm-dd'), 850, 1, 'Color', 'VARCHAR2', '10', NULL, v_inventory_id);
    pkg_inventory.assoc_inv_attr_val('A16', 'Iphone', 'Iphone', 'NEW', to_date('2022-01-01', 'yyyy-mm-dd'), 850, 1, 'Processor', 'VARCHAR2', '10', NULL, v_inventory_id);
    pkg_inventory.assoc_inv_attr_val('Pro', 'Iphone', 'Iphone', 'NEW', to_date('2022-01-01', 'yyyy-mm-dd'), 850, 1, 'Size', 'VARCHAR2', '10', NULL, v_inventory_id);

    v_inventory_id := pkg_inventory.insert_full_inventory('Iphone', 'Iphone', 'NEW', to_date('2022-01-01', 'yyyy-mm-dd'), 850);
    pkg_inventory.assoc_inv_attr_val(3300, 'Iphone', 'Iphone', 'NEW', to_date('2022-01-01', 'yyyy-mm-dd'), 850, 1, 'Battery', 'NUMBER', '10000', NULL, v_inventory_id);
    pkg_inventory.assoc_inv_attr_val('12', 'Iphone', 'Iphone', 'NEW', to_date('2022-01-01', 'yyyy-mm-dd'), 850, 1, 'Model', 'VARCHAR2', '5', NULL, v_inventory_id);
    pkg_inventory.assoc_inv_attr_val('Yellow', 'Iphone', 'Iphone', 'NEW', to_date('2022-01-01', 'yyyy-mm-dd'), 850, 1, 'Color', 'VARCHAR2', '10', NULL, v_inventory_id);
    pkg_inventory.assoc_inv_attr_val('A12', 'Iphone', 'Iphone', 'NEW', to_date('2022-01-01', 'yyyy-mm-dd'), 850, 1, 'Processor', 'VARCHAR2', '10', NULL, v_inventory_id);
    pkg_inventory.assoc_inv_attr_val('Mini', 'Iphone', 'Iphone', 'NEW', to_date('2022-01-01', 'yyyy-mm-dd'), 850, 1, 'Size', 'VARCHAR2', '10', NULL, v_inventory_id);

    v_inventory_id := pkg_inventory.insert_full_inventory('Iphone', 'Iphone', 'NEW', to_date('2022-01-01', 'yyyy-mm-dd'), 850);
    pkg_inventory.assoc_inv_attr_val(3300, 'Iphone', 'Iphone', 'NEW', to_date('2022-01-01', 'yyyy-mm-dd'), 850, 1, 'Battery', 'NUMBER', '10000', NULL, v_inventory_id);
    pkg_inventory.assoc_inv_attr_val('13', 'Iphone', 'Iphone', 'NEW', to_date('2022-01-01', 'yyyy-mm-dd'), 850, 1, 'Model', 'VARCHAR2', '5', NULL, v_inventory_id);
    pkg_inventory.assoc_inv_attr_val('Green', 'Iphone', 'Iphone', 'NEW', to_date('2022-01-01', 'yyyy-mm-dd'), 850, 1, 'Color', 'VARCHAR2', '10', NULL, v_inventory_id);
    pkg_inventory.assoc_inv_attr_val('A13', 'Iphone', 'Iphone', 'NEW', to_date('2022-01-01', 'yyyy-mm-dd'), 850, 1, 'Processor', 'VARCHAR2', '10', NULL, v_inventory_id);
    pkg_inventory.assoc_inv_attr_val('Mini', 'Iphone', 'Iphone', 'NEW', to_date('2022-01-01', 'yyyy-mm-dd'), 850, 1, 'Size', 'VARCHAR2', '10', NULL, v_inventory_id);

    --ipad inventory
    v_inventory_id := pkg_inventory.insert_full_inventory('Ipad', 'Ipad', 'NEW', to_date('2022-01-01', 'yyyy-mm-dd'), 1150);
    pkg_inventory.assoc_inv_attr_val(5000, 'Ipad', 'Ipad', 'NEW', to_date('2022-01-01', 'yyyy-mm-dd'), 1150, 1, 'Battery', 'NUMBER', '10000', NULL, v_inventory_id);
    pkg_inventory.assoc_inv_attr_val('2024', 'Ipad', 'Ipad', 'NEW', to_date('2022-01-01', 'yyyy-mm-dd'), 1150, 1, 'Model', 'VARCHAR2', '5', NULL, v_inventory_id);
    pkg_inventory.assoc_inv_attr_val('Silver', 'Ipad', 'Ipad', 'NEW', to_date('2022-01-01', 'yyyy-mm-dd'), 1150, 1, 'Color', 'VARCHAR2', '10', NULL, v_inventory_id);
    pkg_inventory.assoc_inv_attr_val('A17', 'Ipad', 'Ipad', 'NEW', to_date('2022-01-01', 'yyyy-mm-dd'), 1150, 1, 'Processor', 'VARCHAR2', '10', NULL, v_inventory_id);
    pkg_inventory.assoc_inv_attr_val('Pro', 'Ipad', 'Ipad', 'NEW', to_date('2022-01-01', 'yyyy-mm-dd'), 1150, 1, 'Size', 'VARCHAR2', '10', NULL, v_inventory_id);

    v_inventory_id := pkg_inventory.insert_full_inventory('Ipad', 'Ipad', 'NEW', to_date('2022-01-01', 'yyyy-mm-dd'), 1150);
    pkg_inventory.assoc_inv_attr_val(4500, 'Ipad', 'Ipad', 'NEW', to_date('2022-01-01', 'yyyy-mm-dd'), 1150, 1, 'Battery', 'NUMBER', '10000', NULL, v_inventory_id);
    pkg_inventory.assoc_inv_attr_val('2023', 'Ipad', 'Ipad', 'NEW', to_date('2022-01-01', 'yyyy-mm-dd'), 1150, 1, 'Model', 'VARCHAR2', '5', NULL, v_inventory_id);
    pkg_inventory.assoc_inv_attr_val('Gold', 'Ipad', 'Ipad', 'NEW', to_date('2022-01-01', 'yyyy-mm-dd'), 1150, 1, 'Color', 'VARCHAR2', '10', NULL, v_inventory_id);
    pkg_inventory.assoc_inv_attr_val('A16', 'Ipad', 'Ipad', 'NEW', to_date('2022-01-01', 'yyyy-mm-dd'), 1150, 1, 'Processor', 'VARCHAR2', '10', NULL, v_inventory_id);
    pkg_inventory.assoc_inv_attr_val('Air', 'Ipad', 'Ipad', 'NEW', to_date('2022-01-01', 'yyyy-mm-dd'), 1150, 1, 'Size', 'VARCHAR2', '10', NULL, v_inventory_id);

    v_inventory_id := pkg_inventory.insert_full_inventory('Ipad', 'Ipad', 'NEW', to_date('2022-01-01', 'yyyy-mm-dd'), 1150);
    pkg_inventory.assoc_inv_attr_val(5000, 'Ipad', 'Ipad', 'NEW', to_date('2022-01-01', 'yyyy-mm-dd'), 1150, 1, 'Battery', 'NUMBER', '10000', NULL, v_inventory_id);
    pkg_inventory.assoc_inv_attr_val('2022', 'Ipad', 'Ipad', 'NEW', to_date('2022-01-01', 'yyyy-mm-dd'), 1150, 1, 'Model', 'VARCHAR2', '5', NULL, v_inventory_id);
    pkg_inventory.assoc_inv_attr_val('Black', 'Ipad', 'Ipad', 'NEW', to_date('2022-01-01', 'yyyy-mm-dd'), 1150, 1, 'Color', 'VARCHAR2', '10', NULL, v_inventory_id);
    pkg_inventory.assoc_inv_attr_val('A17', 'Ipad', 'Ipad', 'NEW', to_date('2022-01-01', 'yyyy-mm-dd'), 1150, 1, 'Processor', 'VARCHAR2', '10', NULL, v_inventory_id);
    pkg_inventory.assoc_inv_attr_val('Pro', 'Ipad', 'Ipad', 'NEW', to_date('2022-01-01', 'yyyy-mm-dd'), 1150, 1, 'Size', 'VARCHAR2', '10', NULL, v_inventory_id);

    v_inventory_id := pkg_inventory.insert_full_inventory('Ipad', 'Ipad', 'NEW', to_date('2022-01-01', 'yyyy-mm-dd'), 1150);
    pkg_inventory.assoc_inv_attr_val(4500, 'Ipad', 'Ipad', 'NEW', to_date('2022-01-01', 'yyyy-mm-dd'), 1150, 1, 'Battery', 'NUMBER', '10000', NULL, v_inventory_id);
    pkg_inventory.assoc_inv_attr_val('2022', 'Ipad', 'Ipad', 'NEW', to_date('2022-01-01', 'yyyy-mm-dd'), 1150, 1, 'Model', 'VARCHAR2', '5', NULL, v_inventory_id);
    pkg_inventory.assoc_inv_attr_val('Blue', 'Ipad', 'Ipad', 'NEW', to_date('2022-01-01', 'yyyy-mm-dd'), 1150, 1, 'Color', 'VARCHAR2', '10', NULL, v_inventory_id);
    pkg_inventory.assoc_inv_attr_val('A15', 'Ipad', 'Ipad', 'NEW', to_date('2022-01-01', 'yyyy-mm-dd'), 1150, 1, 'Processor', 'VARCHAR2', '10', NULL, v_inventory_id);
    pkg_inventory.assoc_inv_attr_val('Air', 'Ipad', 'Ipad', 'NEW', to_date('2022-01-01', 'yyyy-mm-dd'), 1150, 1, 'Size', 'VARCHAR2', '10', NULL, v_inventory_id);
 
    v_inventory_id := pkg_inventory.insert_full_inventory('Ipad', 'Ipad', 'NEW', to_date('2022-01-01', 'yyyy-mm-dd'), 1150);
    pkg_inventory.assoc_inv_attr_val(3500, 'Ipad', 'Ipad', 'NEW', to_date('2022-01-01', 'yyyy-mm-dd'), 1150, 1, 'Battery', 'NUMBER', '10000', NULL, v_inventory_id);
    pkg_inventory.assoc_inv_attr_val('2022', 'Ipad', 'Ipad', 'NEW', to_date('2022-01-01', 'yyyy-mm-dd'), 1150, 1, 'Model', 'VARCHAR2', '5', NULL, v_inventory_id);
    pkg_inventory.assoc_inv_attr_val('Gray', 'Ipad', 'Ipad', 'NEW', to_date('2022-01-01', 'yyyy-mm-dd'), 1150, 1, 'Color', 'VARCHAR2', '10', NULL, v_inventory_id);
    pkg_inventory.assoc_inv_attr_val('A13', 'Ipad', 'Ipad', 'NEW', to_date('2022-01-01', 'yyyy-mm-dd'), 1150, 1, 'Processor', 'VARCHAR2', '10', NULL, v_inventory_id);
    pkg_inventory.assoc_inv_attr_val('Mini', 'Ipad', 'Ipad', 'NEW', to_date('2022-01-01', 'yyyy-mm-dd'), 1150, 1, 'Size', 'VARCHAR2', '10', NULL, v_inventory_id);
       
    --macbook inventory
    v_inventory_id := pkg_inventory.insert_full_inventory('MacBook', 'MacBook', 'NEW', to_date('2022-01-01', 'yyyy-mm-dd'), 1500);
    pkg_inventory.assoc_inv_attr_val(7000, 'MacBook', 'MacBook', 'NEW', to_date('2022-01-01', 'yyyy-mm-dd'), 1500, 1, 'Battery', 'NUMBER', '10000', NULL, v_inventory_id);
    pkg_inventory.assoc_inv_attr_val('2022', 'MacBook', 'MacBook', 'NEW', to_date('2022-01-01', 'yyyy-mm-dd'), 1500, 1, 'Model', 'VARCHAR2', '5', NULL, v_inventory_id);
    pkg_inventory.assoc_inv_attr_val('Gray', 'MacBook', 'MacBook', 'NEW', to_date('2022-01-01', 'yyyy-mm-dd'), 1500, 1, 'Color', 'VARCHAR2', '10', NULL, v_inventory_id);
    pkg_inventory.assoc_inv_attr_val('A15', 'MacBook', 'MacBook', 'NEW', to_date('2022-01-01', 'yyyy-mm-dd'), 1500, 1, 'Processor', 'VARCHAR2', '10', NULL, v_inventory_id);
    pkg_inventory.assoc_inv_attr_val('Air', 'MacBook', 'MacBook', 'NEW', to_date('2022-01-01', 'yyyy-mm-dd'), 1500, 1, 'Size', 'VARCHAR2', '10', NULL, v_inventory_id);

    v_inventory_id := pkg_inventory.insert_full_inventory('MacBook', 'MacBook', 'NEW', to_date('2022-01-01', 'yyyy-mm-dd'), 1500);
    pkg_inventory.assoc_inv_attr_val(7000, 'MacBook', 'MacBook', 'NEW', to_date('2022-01-01', 'yyyy-mm-dd'), 1500, 1, 'Battery', 'NUMBER', '10000', NULL, v_inventory_id);
    pkg_inventory.assoc_inv_attr_val('2022', 'MacBook', 'MacBook', 'NEW', to_date('2022-01-01', 'yyyy-mm-dd'), 1500, 1, 'Model', 'VARCHAR2', '5', NULL, v_inventory_id);
    pkg_inventory.assoc_inv_attr_val('Silver', 'MacBook', 'MacBook', 'NEW', to_date('2022-01-01', 'yyyy-mm-dd'), 1500, 1, 'Color', 'VARCHAR2', '10', NULL, v_inventory_id);
    pkg_inventory.assoc_inv_attr_val('A15', 'MacBook', 'MacBook', 'NEW', to_date('2022-01-01', 'yyyy-mm-dd'), 1500, 1, 'Processor', 'VARCHAR2', '10', NULL, v_inventory_id);
    pkg_inventory.assoc_inv_attr_val('Air', 'MacBook', 'MacBook', 'NEW', to_date('2022-01-01', 'yyyy-mm-dd'), 1500, 1, 'Size', 'VARCHAR2', '10', NULL, v_inventory_id);

    v_inventory_id := pkg_inventory.insert_full_inventory('MacBook', 'MacBook', 'NEW', to_date('2022-01-01', 'yyyy-mm-dd'), 1500);
    pkg_inventory.assoc_inv_attr_val(7000, 'MacBook', 'MacBook', 'NEW', to_date('2022-01-01', 'yyyy-mm-dd'), 1500, 1, 'Battery', 'NUMBER', '10000', NULL, v_inventory_id);
    pkg_inventory.assoc_inv_attr_val('2023', 'MacBook', 'MacBook', 'NEW', to_date('2022-01-01', 'yyyy-mm-dd'), 1500, 1, 'Model', 'VARCHAR2', '5', NULL, v_inventory_id);
    pkg_inventory.assoc_inv_attr_val('Gray', 'MacBook', 'MacBook', 'NEW', to_date('2022-01-01', 'yyyy-mm-dd'), 1500, 1, 'Color', 'VARCHAR2', '10', NULL, v_inventory_id);
    pkg_inventory.assoc_inv_attr_val('A16', 'MacBook', 'MacBook', 'NEW', to_date('2022-01-01', 'yyyy-mm-dd'), 1500, 1, 'Processor', 'VARCHAR2', '10', NULL, v_inventory_id);
    pkg_inventory.assoc_inv_attr_val('Air', 'MacBook', 'MacBook', 'NEW', to_date('2022-01-01', 'yyyy-mm-dd'), 1500, 1, 'Size', 'VARCHAR2', '10', NULL, v_inventory_id);

    v_inventory_id := pkg_inventory.insert_full_inventory('MacBook', 'MacBook', 'NEW', to_date('2022-01-01', 'yyyy-mm-dd'), 1500);
    pkg_inventory.assoc_inv_attr_val(7000, 'MacBook', 'MacBook', 'NEW', to_date('2022-01-01', 'yyyy-mm-dd'), 1500, 1, 'Battery', 'NUMBER', '10000', NULL, v_inventory_id);
    pkg_inventory.assoc_inv_attr_val('2022', 'MacBook', 'MacBook', 'NEW', to_date('2022-01-01', 'yyyy-mm-dd'), 1500, 1, 'Model', 'VARCHAR2', '5', NULL, v_inventory_id);
    pkg_inventory.assoc_inv_attr_val('Gray', 'MacBook', 'MacBook', 'NEW', to_date('2022-01-01', 'yyyy-mm-dd'), 1500, 1, 'Color', 'VARCHAR2', '10', NULL, v_inventory_id);
    pkg_inventory.assoc_inv_attr_val('A15', 'MacBook', 'MacBook', 'NEW', to_date('2022-01-01', 'yyyy-mm-dd'), 1500, 1, 'Processor', 'VARCHAR2', '10', NULL, v_inventory_id);
    pkg_inventory.assoc_inv_attr_val('Air', 'MacBook', 'MacBook', 'NEW', to_date('2022-01-01', 'yyyy-mm-dd'), 1500, 1, 'Size', 'VARCHAR2', '10', NULL, v_inventory_id);

    v_inventory_id := pkg_inventory.insert_full_inventory('MacBook', 'MacBook', 'NEW', to_date('2022-01-01', 'yyyy-mm-dd'), 1500);
    pkg_inventory.assoc_inv_attr_val(7000, 'MacBook', 'MacBook', 'NEW', to_date('2022-01-01', 'yyyy-mm-dd'), 1500, 1, 'Battery', 'NUMBER', '10000', NULL, v_inventory_id);
    pkg_inventory.assoc_inv_attr_val('2024', 'MacBook', 'MacBook', 'NEW', to_date('2022-01-01', 'yyyy-mm-dd'), 1500, 1, 'Model', 'VARCHAR2', '5', NULL, v_inventory_id);
    pkg_inventory.assoc_inv_attr_val('Gray', 'MacBook', 'MacBook', 'NEW', to_date('2022-01-01', 'yyyy-mm-dd'), 1500, 1, 'Color', 'VARCHAR2', '10', NULL, v_inventory_id);
    pkg_inventory.assoc_inv_attr_val('A17', 'MacBook', 'MacBook', 'NEW', to_date('2022-01-01', 'yyyy-mm-dd'), 1500, 1, 'Processor', 'VARCHAR2', '10', NULL, v_inventory_id);
    pkg_inventory.assoc_inv_attr_val('Air', 'MacBook', 'MacBook', 'NEW', to_date('2022-01-01', 'yyyy-mm-dd'), 1500, 1, 'Size', 'VARCHAR2', '10', NULL, v_inventory_id);
    
    v_inventory_id := pkg_inventory.insert_full_inventory('MacBook', 'MacBook', 'NEW', to_date('2022-01-01', 'yyyy-mm-dd'), 1500);
    pkg_inventory.assoc_inv_attr_val(9000, 'MacBook', 'MacBook', 'NEW', to_date('2022-01-01', 'yyyy-mm-dd'), 1500, 1, 'Battery', 'NUMBER', '10000', NULL, v_inventory_id);
    pkg_inventory.assoc_inv_attr_val('2024', 'MacBook', 'MacBook', 'NEW', to_date('2022-01-01', 'yyyy-mm-dd'), 1500, 1, 'Model', 'VARCHAR2', '5', NULL, v_inventory_id);
    pkg_inventory.assoc_inv_attr_val('Gray', 'MacBook', 'MacBook', 'NEW', to_date('2022-01-01', 'yyyy-mm-dd'), 1500, 1, 'Color', 'VARCHAR2', '10', NULL, v_inventory_id);
    pkg_inventory.assoc_inv_attr_val('A17', 'MacBook', 'MacBook', 'NEW', to_date('2022-01-01', 'yyyy-mm-dd'), 1500, 1, 'Processor', 'VARCHAR2', '10', NULL, v_inventory_id);
    pkg_inventory.assoc_inv_attr_val('Pro', 'MacBook', 'MacBook', 'NEW', to_date('2022-01-01', 'yyyy-mm-dd'), 1500, 1, 'Size', 'VARCHAR2', '10', NULL, v_inventory_id);

    v_inventory_id := pkg_inventory.insert_full_inventory('MacBook', 'MacBook', 'NEW', to_date('2022-01-01', 'yyyy-mm-dd'), 1500);
    pkg_inventory.assoc_inv_attr_val(9000, 'MacBook', 'MacBook', 'NEW', to_date('2022-01-01', 'yyyy-mm-dd'), 1500, 1, 'Battery', 'NUMBER', '10000', NULL, v_inventory_id);
    pkg_inventory.assoc_inv_attr_val('2024', 'MacBook', 'MacBook', 'NEW', to_date('2022-01-01', 'yyyy-mm-dd'), 1500, 1, 'Model', 'VARCHAR2', '5', NULL, v_inventory_id);
    pkg_inventory.assoc_inv_attr_val('Silver', 'MacBook', 'MacBook', 'NEW', to_date('2022-01-01', 'yyyy-mm-dd'), 1500, 1, 'Color', 'VARCHAR2', '10', NULL, v_inventory_id);
    pkg_inventory.assoc_inv_attr_val('A17', 'MacBook', 'MacBook', 'NEW', to_date('2022-01-01', 'yyyy-mm-dd'), 1500, 1, 'Processor', 'VARCHAR2', '10', NULL, v_inventory_id);
    pkg_inventory.assoc_inv_attr_val('Pro', 'MacBook', 'MacBook', 'NEW', to_date('2022-01-01', 'yyyy-mm-dd'), 1500, 1, 'Size', 'VARCHAR2', '10', NULL, v_inventory_id);

    v_inventory_id := pkg_inventory.insert_full_inventory('MacBook', 'MacBook', 'NEW', to_date('2022-01-01', 'yyyy-mm-dd'), 1500);
    pkg_inventory.assoc_inv_attr_val(10000, 'MacBook', 'MacBook', 'NEW', to_date('2022-01-01', 'yyyy-mm-dd'), 1500, 1, 'Battery', 'NUMBER', '10000', NULL, v_inventory_id);
    pkg_inventory.assoc_inv_attr_val('2024', 'MacBook', 'MacBook', 'NEW', to_date('2022-01-01', 'yyyy-mm-dd'), 1500, 1, 'Model', 'VARCHAR2', '5', NULL, v_inventory_id);
    pkg_inventory.assoc_inv_attr_val('Gray', 'MacBook', 'MacBook', 'NEW', to_date('2022-01-01', 'yyyy-mm-dd'), 1500, 1, 'Color', 'VARCHAR2', '10', NULL, v_inventory_id);
    pkg_inventory.assoc_inv_attr_val('A17Max', 'MacBook', 'MacBook', 'NEW', to_date('2022-01-01', 'yyyy-mm-dd'), 1500, 1, 'Processor', 'VARCHAR2', '10', NULL, v_inventory_id);
    pkg_inventory.assoc_inv_attr_val('Pro Max', 'MacBook', 'MacBook', 'NEW', to_date('2022-01-01', 'yyyy-mm-dd'), 1500, 1, 'Size', 'VARCHAR2', '10', NULL, v_inventory_id);

    v_inventory_id := pkg_inventory.insert_full_inventory('MacBook', 'MacBook', 'NEW', to_date('2022-01-01', 'yyyy-mm-dd'), 1500);
    pkg_inventory.assoc_inv_attr_val(10000, 'MacBook', 'MacBook', 'NEW', to_date('2022-01-01', 'yyyy-mm-dd'), 1500, 1, 'Battery', 'NUMBER', '10000', NULL, v_inventory_id);
    pkg_inventory.assoc_inv_attr_val('2022', 'MacBook', 'MacBook', 'NEW', to_date('2022-01-01', 'yyyy-mm-dd'), 1500, 1, 'Model', 'VARCHAR2', '5', NULL, v_inventory_id);
    pkg_inventory.assoc_inv_attr_val('Gray', 'MacBook', 'MacBook', 'NEW', to_date('2022-01-01', 'yyyy-mm-dd'), 1500, 1, 'Color', 'VARCHAR2', '10', NULL, v_inventory_id);
    pkg_inventory.assoc_inv_attr_val('A15Max', 'MacBook', 'MacBook', 'NEW', to_date('2022-01-01', 'yyyy-mm-dd'), 1500, 1, 'Processor', 'VARCHAR2', '10', NULL, v_inventory_id);
    pkg_inventory.assoc_inv_attr_val('Pro Max', 'MacBook', 'MacBook', 'NEW', to_date('2022-01-01', 'yyyy-mm-dd'), 1500, 1, 'Size', 'VARCHAR2', '10', NULL, v_inventory_id);
END;
/