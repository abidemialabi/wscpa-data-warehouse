DROP TABLE IF EXISTS wscpa_hubspot.staging_engagements;

CREATE TABLE wscpa_hubspot.staging_engagements (
    json_data LONGTEXT,
    source_file VARCHAR(500),
    load_ts TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
