DROP TABLE IF EXISTS wscpa_amnet.staging_committee_members;

CREATE TABLE wscpa_amnet.staging_committee_members (
    committees_key INT,
    members_key INT,
    begin_dates_key CHAR(25),
    end_dates_key CHAR(25),
    committee_positions_key INT,
    member_id VARCHAR(20),
    load_ts TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
