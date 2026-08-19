DROP TABLE IF EXISTS wscpa_amnet.staging_communications;

CREATE TABLE wscpa_amnet.staging_communications (
    communications_key INT PRIMARY KEY,
    communication_dates_key VARCHAR(20),
    begin_dates_key VARCHAR(20),
    end_dates_key VARCHAR(20),
    communication_title VARCHAR(128),
    communication_description TEXT,
    communication_method_list VARCHAR(512),
    promotion_title VARCHAR(128),
    promotion_description TEXT,
    promotion_category VARCHAR(128),
    promotion_subcategory VARCHAR(128),
    promotion_group_list VARCHAR(512),
    load_ts TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
