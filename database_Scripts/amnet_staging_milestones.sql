DROP TABLE IF EXISTS wscpa_amnet.staging_milestones;

CREATE TABLE wscpa_amnet.staging_milestones (
    milestones_key INT PRIMARY KEY,
    milestone VARCHAR(128),
    billing_class_change VARCHAR(255),
    old_billing_class VARCHAR(128),
    new_billing_class VARCHAR(128),
    member_type_change VARCHAR(255),
    old_member_type VARCHAR(128),
    new_member_type VARCHAR(128),
    load_ts TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
