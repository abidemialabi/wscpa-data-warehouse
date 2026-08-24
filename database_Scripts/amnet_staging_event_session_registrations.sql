DROP TABLE IF EXISTS wscpa_amnet.staging_event_session_registrations;

CREATE TABLE wscpa_amnet.staging_event_session_registrations (
    events_key INT,
    event_sessions_key INT,
    registrants_key INT,
    guests_key INT,
    registrant_id VARCHAR(20),
    load_ts TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
