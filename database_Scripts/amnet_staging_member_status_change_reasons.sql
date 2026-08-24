DROP TABLE IF EXISTS wscpa_amnet.staging_member_status_change_reasons;

CREATE TABLE wscpa_amnet.staging_member_status_change_reasons (
    member_status_change_reasons_key INT PRIMARY KEY,
    member_status_change_reason VARCHAR(64),
    load_ts TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
