DROP TABLE IF EXISTS wscpa_amnet.staging_credit_hours_earned;

CREATE TABLE wscpa_amnet.staging_credit_hours_earned (
    credit_sources_key INT,
    credit_earning_methods_key INT,
    credit_categories_key INT,
    completion_dates_key CHAR(25),
    members_key INT,
    member_id VARCHAR(20),
    credit_hours_earned DECIMAL(6,2),
    load_ts TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
