DROP PROCEDURE IF EXISTS wscpa_dw.sp_load_dim_products;

DELIMITER $$

CREATE PROCEDURE wscpa_dw.sp_load_dim_products()
BEGIN

    DELETE FROM wscpa_dw.dim_Products;

    INSERT INTO wscpa_dw.dim_Products
    (
        ProductsKey,
        AuthorsKey,
        VendorsKey,
        ProductCode,
        ProductName,
        ProductType,
        ProductFormat,
        ProductCategoriesList,
        ProductFieldsOfStudyList,
        ProductFieldsOfInterestList,
        ProductSkillLevel,
        ProductScope,
        ProductAvailability,
        ProductCompany,
        ProductDivision,
        ProductGLAccount,
        ProductVendorCode1,
        ProductVendorCode2
    )
    SELECT
        CAST(products_key AS SIGNED),
        CAST(authors_key AS SIGNED),
        CAST(vendors_key AS SIGNED),
        CAST(product_code AS CHAR(15)),
        CAST(product_name AS CHAR(255)),
        CAST(product_type AS CHAR(25)),
        CAST(product_format AS CHAR(50)),
        CAST(product_categories_list AS CHAR),
        CAST(product_fields_of_study_list AS CHAR),
        CAST(product_fields_of_interest_list AS CHAR),
        CAST(product_skill_level AS CHAR(50)),
        CAST(product_scope AS CHAR(20)),
        CAST(product_availability AS CHAR(50)),
        CAST(product_company AS CHAR(50)),
        CAST(product_division AS CHAR(50)),
        CAST(product_gl_account AS CHAR(14)),
        CAST(product_vendor_code_1 AS CHAR(100)),
        CAST(product_vendor_code_2 AS CHAR(100))
    FROM wscpa_amnet.staging_products;

END$$

DELIMITER ;
