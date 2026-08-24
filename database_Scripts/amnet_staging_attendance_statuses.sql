DROP TABLE IF EXISTS wscpa_amnet.staging_attendance_statuses;

CREATE TABLE wscpa_amnet.staging_attendance_statuses (
    attendance_statuses_key INT PRIMARY KEY,
    attendance_status VARCHAR(128),
    load_ts TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
