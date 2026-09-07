DROP TABLE IF EXISTS wscpa_amnet.staging_event_registrations;

CREATE TABLE wscpa_amnet.staging_event_registrations (
    events_key INT,
    registrants_key INT,
    registration_statuses_key INT,
    registration_dates_key CHAR(25),
    cancellation_date VARCHAR(255),
    registrant_id VARCHAR(20),
    credit_hours_earned_at_event DECIMAL(5,2),
    fees_billed_total DECIMAL(19,4),
    fees_paid_total DECIMAL(19,4),
    fees_balance_due DECIMAL(19,4),
    miles_from_home VARCHAR(100),
    miles_from_work VARCHAR(100),
    miles_from_preferred_address VARCHAR(100),
    days_before_event SMALLINT,
    registrant_age VARCHAR(100),
    registrant_age_bracket VARCHAR(32),
    fees_paid_date VARCHAR(255),
    completion_dates_key CHAR(25),
    resellers_key INT,
    load_ts TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
