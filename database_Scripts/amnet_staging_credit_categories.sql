DROP TABLE IF EXISTS wscpa_amnet.staging_credit_categories;

CREATE TABLE wscpa_amnet.staging_credit_categories (
    credit_categories_key INT PRIMARY KEY,
    credit_category VARCHAR(128),
    cpe_qualified_yn VARCHAR(10),
    load_ts TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
