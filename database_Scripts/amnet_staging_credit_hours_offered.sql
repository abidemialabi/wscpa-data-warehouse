DROP TABLE IF EXISTS wscpa_amnet.staging_credit_hours_offered;

CREATE TABLE wscpa_amnet.staging_credit_hours_offered (
    credit_sources_key INT,
    credit_categories_key INT,
    credit_hours_offered DECIMAL(5,2),
    load_ts TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
