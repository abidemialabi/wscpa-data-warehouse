DROP TABLE IF EXISTS wscpa_amnet.staging_contributions;

CREATE TABLE wscpa_amnet.staging_contributions (
    contributors_key INT,
    transaction_dates_key CHAR(25),
    transaction_types_key INT,
    payment_methods_key INT,
    contribution_types_key INT,
    dues_years_key INT,
    contributor_id VARCHAR(20),
    contribution_amount DECIMAL(19,4),
    load_ts TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
