DROP TABLE IF EXISTS wscpa_hubspot.staging_associations;

CREATE TABLE wscpa_hubspot.staging_associations (
    json_data LONGTEXT,
    source_file VARCHAR(500),
    load_ts TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
