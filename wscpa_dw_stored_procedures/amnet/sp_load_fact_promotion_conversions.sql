DROP PROCEDURE IF EXISTS wscpa_dw.sp_load_fact_promotion_conversions;

DELIMITER $$

CREATE PROCEDURE wscpa_dw.sp_load_fact_promotion_conversions()
BEGIN

    DELETE FROM wscpa_dw.fact_PromotionConversions;

    INSERT INTO wscpa_dw.fact_PromotionConversions
    (
        IndividualsKey,
        CommunicationsKey,
        EngagementOpportunitiesKey,
        ConversionDatesKey,
        IndividualID,
        DaysUntilConversion,
        ConversionCount
    )
    SELECT
        CAST(individuals_key AS SIGNED),
        CAST(communications_key AS SIGNED),
        CAST(engagement_opportunities_key AS SIGNED),
        CAST(conversion_dates_key AS SIGNED),
        CAST(individual_id AS CHAR(20)),
        CAST(days_until_conversion AS SIGNED),
        CAST(conversion_count AS SIGNED)
    FROM wscpa_amnet.staging_promotion_conversions;

END$$

DELIMITER ;
