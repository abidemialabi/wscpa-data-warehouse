DROP TABLE IF EXISTS wscpa_amnet.staging_committee_meeting_attendance;

CREATE TABLE wscpa_amnet.staging_committee_meeting_attendance (
    committee_meetings_key INT,
    members_key INT,
    meeting_dates_key CHAR(25),
    attendance_statuses_key INT,
    member_id VARCHAR(20),
    load_ts TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
