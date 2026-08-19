DROP TABLE IF EXISTS wscpa_amnet.staging_cpe_bank_individual_snapshots;

CREATE TABLE wscpa_amnet.staging_cpe_bank_individual_snapshots (
    members_key INT,
    dues_years_key INT,
    begin_dates_key CHAR(25),
    end_dates_key CHAR(25),
    bank_dollars_purchased DECIMAL(19,4),
    bank_dollars_used DECIMAL(19,4),
    bank_dollars_balance DECIMAL(19,4),
    bank_hours_purchased DECIMAL(7,2),
    bank_hours_redeemed DECIMAL(7,2),
    bank_hours_remaining DECIMAL(7,2),
    bank_active_yn VARCHAR(10),
    total_registration_cost DECIMAL(19,4),
    total_margin DECIMAL(19,4),
    member_id VARCHAR(20),
    load_ts TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
