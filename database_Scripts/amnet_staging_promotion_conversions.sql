DROP TABLE IF EXISTS wscpa_amnet.staging_promotion_conversions;

CREATE TABLE wscpa_amnet.staging_promotion_conversions (
    individuals_key INT,
    communications_key INT,
    engagement_opportunities_key INT,
    conversion_dates_key CHAR(25),
    individual_id VARCHAR(20),
    days_until_conversion INT,
    conversion_count INT,
    load_ts TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
