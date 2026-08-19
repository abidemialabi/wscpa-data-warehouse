DROP TABLE IF EXISTS wscpa_amnet.staging_credit_earning_methods;

CREATE TABLE wscpa_amnet.staging_credit_earning_methods (
    credit_earning_methods_key INT PRIMARY KEY,
    credit_earning_method VARCHAR(64),
    load_ts TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
