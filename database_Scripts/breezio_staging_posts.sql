DROP TABLE IF EXISTS wscpa_breezio.staging_posts;

CREATE TABLE wscpa_breezio.staging_posts (
    json_data LONGTEXT,
    source_file VARCHAR(500),
    load_ts TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
