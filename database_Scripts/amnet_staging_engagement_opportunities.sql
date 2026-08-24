DROP TABLE IF EXISTS wscpa_amnet.staging_engagement_opportunities;

CREATE TABLE wscpa_amnet.staging_engagement_opportunities (
    engagement_opportunities_key INT PRIMARY KEY,
    engagement_type VARCHAR(128),
    engagement_opportunity VARCHAR(255),
    engagement_category_1 VARCHAR(128),
    engagement_category_2 VARCHAR(128),
    load_ts TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
