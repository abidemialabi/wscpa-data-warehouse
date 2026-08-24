DROP TABLE IF EXISTS wscpa_breezio.staging_pages;

CREATE TABLE wscpa_breezio.staging_pages (
    json_data LONGTEXT,
    source_file VARCHAR(500),
    load_ts TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
