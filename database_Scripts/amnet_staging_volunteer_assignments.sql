DROP TABLE IF EXISTS wscpa_amnet.staging_volunteer_assignments;

CREATE TABLE wscpa_amnet.staging_volunteer_assignments (
    volunteer_opportunities_key INT,
    volunteers_key INT,
    firms_key INT,
    begin_dates_key CHAR(25),
    end_dates_key CHAR(25),
    volunteer_id VARCHAR(20),
    load_ts TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
