DROP TABLE IF EXISTS wscpa_amnet.staging_registration_statuses;

CREATE TABLE wscpa_amnet.staging_registration_statuses(
    registration_statuses_key INT,
    registration_status VARCHAR(255),
    registration_source VARCHAR(255),
    registration_marketing_source VARCHAR(255),
    load_ts TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
