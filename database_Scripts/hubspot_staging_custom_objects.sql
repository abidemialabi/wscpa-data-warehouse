DROP TABLE IF EXISTS wscpa_hubspot.staging_custom_objects;

CREATE TABLE wscpa_hubspot.staging_custom_objects (
    json_data LONGTEXT,
    source_file VARCHAR(500),
    load_ts TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
