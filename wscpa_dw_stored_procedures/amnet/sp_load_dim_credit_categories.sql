DROP PROCEDURE IF EXISTS wscpa_dw.sp_load_dim_credit_categories;

DELIMITER $$

CREATE PROCEDURE wscpa_dw.sp_load_dim_credit_categories()
BEGIN

    DELETE FROM wscpa_dw.dim_CreditCategories;

    INSERT INTO wscpa_dw.dim_CreditCategories
    (
        CreditCategoriesKey,
        CreditCategory,
        CPEQualifiedYN
    )
    SELECT
        CAST(credit_categories_key AS SIGNED),
        CAST(credit_category AS CHAR(50)),
        CAST(cpe_qualified_yn AS CHAR(3))
    FROM wscpa_amnet.staging_credit_categories;

END$$

DELIMITER ;
