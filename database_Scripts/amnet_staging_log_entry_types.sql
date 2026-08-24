DROP TABLE IF EXISTS wscpa_amnet.staging_log_entry_types;

CREATE TABLE wscpa_amnet.staging_log_entry_types (
    log_entry_types_key INT PRIMARY KEY,
    log_type VARCHAR(128),
    log_sub_type VARCHAR(128),
    engagement_yn VARCHAR(10),
    log_module VARCHAR(128),
    load_ts TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
