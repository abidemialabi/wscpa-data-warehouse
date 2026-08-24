DROP TABLE IF EXISTS wscpa_amnet.staging_log_history;

CREATE TABLE wscpa_amnet.staging_log_history (
    contacts_key INT,
    log_entry_types_key INT,
    add_dates_key CHAR(25),
    follow_up_dates_key CHAR(25),
    contact_id VARCHAR(20),
    log_entry_note VARCHAR(128),
    log_entry_memo TEXT,
    load_ts TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
