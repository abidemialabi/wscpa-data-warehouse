DROP PROCEDURE IF EXISTS wscpa_dw.sp_load_dim_credit_earning_methods;

DELIMITER $$

CREATE PROCEDURE wscpa_dw.sp_load_dim_credit_earning_methods()
BEGIN

    DELETE FROM wscpa_dw.dim_CreditEarningMethods;

    INSERT INTO wscpa_dw.dim_CreditEarningMethods
    (
        CreditEarningMethodsKey,
        CreditEarningMethod
    )
    SELECT
        CAST(credit_earning_methods_key AS SIGNED),
        CAST(credit_earning_method AS CHAR(50))
    FROM wscpa_amnet.staging_credit_earning_methods;

END$$

DELIMITER ;
