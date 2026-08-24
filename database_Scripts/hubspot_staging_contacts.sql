DROP TABLE IF EXISTS wscpa_hubspot.staging_contacts;

CREATE TABLE wscpa_hubspot.staging_contacts (
    json_data LONGTEXT,
    source_file VARCHAR(500),
    load_ts TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
