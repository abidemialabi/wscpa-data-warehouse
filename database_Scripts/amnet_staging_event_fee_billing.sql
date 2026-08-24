DROP TABLE IF EXISTS wscpa_amnet.staging_event_fee_billing;

CREATE TABLE wscpa_amnet.staging_event_fee_billing (
    events_key INT,
    registrants_key INT,
    transaction_types_key INT,
    event_fee_types_key INT,
    transaction_dates_key CHAR(25),
    registrant_id VARCHAR(20),
    fee_amount DECIMAL(19,4),
    member_savings DECIMAL(19,4),
    general_ledger_accounts_key INT,
    load_ts TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
