DROP TABLE IF EXISTS wscpa_amnet.staging_event_sessions;

CREATE TABLE wscpa_amnet.staging_event_sessions (
    event_sessions_key INT PRIMARY KEY,
    event_codeyr VARCHAR(32),
    session_date VARCHAR(255),
    session_code VARCHAR(16),
    session_description VARCHAR(255),
    session_scope VARCHAR(64),
    session_type VARCHAR(64),
    session_status VARCHAR(128),
    session_track VARCHAR(128),
    yellowbook_session_yn VARCHAR(10),
    attest_and_compilation_session_yn VARCHAR(10),
    certified_financial_planner_session_yn VARCHAR(10),
    session_fields_of_study_list VARCHAR(512),
    session_topics_list VARCHAR(512),
    load_ts TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
