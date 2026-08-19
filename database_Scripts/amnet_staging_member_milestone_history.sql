DROP TABLE IF EXISTS wscpa_amnet.staging_member_milestone_history;

CREATE TABLE wscpa_amnet.staging_member_milestone_history (
    members_key INT,
    milestones_key INT,
    milestone_dates_key VARCHAR(20),
    dues_years_key INT,
    member_id VARCHAR(20),
    load_ts TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
