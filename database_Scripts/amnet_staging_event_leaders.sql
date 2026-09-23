DROP TABLE IF EXISTS wscpa_amnet.staging_event_leaders;

CREATE TABLE wscpa_amnet.staging_event_leaders(
    events_key INT,
    leaders_key INT,
    event_sessions_key INT,
    leader_id VARCHAR(20),
    honorarium_amount DECIMAL(19,4),
    knowledge_rating_avg DECIMAL(5,2),
    presentation_rating_avg DECIMAL(5,2),
    material_rating_avg DECIMAL(5,2),
    leader_relevance_rating_avg DECIMAL(5,2),
    overall_leader_rating_avg DECIMAL(5,2),
    load_ts TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
