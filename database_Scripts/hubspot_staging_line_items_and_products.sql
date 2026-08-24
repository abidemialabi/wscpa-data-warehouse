DROP TABLE IF EXISTS wscpa_hubspot.staging_line_items_and_products;

CREATE TABLE wscpa_hubspot.staging_line_items_and_products (
    json_data LONGTEXT,
    source_file VARCHAR(500),
    load_ts TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
