DROP TABLE IF EXISTS wscpa_breezio.staging_organizations;

CREATE TABLE wscpa_breezio.staging_organizations (
    json_data LONGTEXT,
    source_file VARCHAR(500),
    load_ts TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
