DROP TABLE IF EXISTS wscpa_amnet.staging_dues_years;

CREATE TABLE wscpa_amnet.staging_dues_years (
    dues_years_key INT PRIMARY KEY,
    dues_year_name VARCHAR(20),
    dues_year_begin_date DATE,
    dues_year_end_date DATE,
    load_ts TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
