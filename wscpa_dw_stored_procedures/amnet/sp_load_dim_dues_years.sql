DROP PROCEDURE IF EXISTS wscpa_dw.sp_load_dim_dues_years;

DELIMITER $$

CREATE PROCEDURE wscpa_dw.sp_load_dim_dues_years()
BEGIN

    DELETE FROM wscpa_dw.dim_DuesYears;

    INSERT INTO wscpa_dw.dim_DuesYears
    (
        DuesYearsKey,
        DuesYearName,
        DuesYearBeginDate,
        DuesYearEndDate
    )
    SELECT
        CAST(dues_years_key AS SIGNED),
        CAST(dues_year_name AS CHAR(4)),
        CAST(dues_year_begin_date AS DATE),
        CAST(dues_year_end_date AS DATE)
    FROM wscpa_amnet.staging_dues_years;

END$$

DELIMITER ;
