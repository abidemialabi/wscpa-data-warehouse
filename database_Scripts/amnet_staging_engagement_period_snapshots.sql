DROP TABLE IF EXISTS wscpa_amnet.staging_engagement_period_snapshots;

CREATE TABLE wscpa_amnet.staging_engagement_period_snapshots (
    individuals_key INT,
    months_key INT,
    individual_id VARCHAR(20),
    engagement_period_begin_date VARCHAR(255),
    engagement_period_end_date VARCHAR(255),
    engagement_score VARCHAR(25),
    ep_age VARCHAR(25),
    ep_age_bracket VARCHAR(32),
    ep_contribution_count INT,
    ep_committee_membership_count INT,
    ep_committee_attendance_count INT,
    ep_event_registration_count INT,
    ep_product_sales_quantity INT,
    ep_volunteer_assignment_count INT,
    ep_membership_count INT,
    ep_log_engagement_count INT,
    load_ts TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
