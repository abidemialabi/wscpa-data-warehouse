DROP TABLE IF EXISTS wscpa_amnet.staging_products;

CREATE TABLE wscpa_amnet.staging_products (
    products_key INT PRIMARY KEY,
    authors_key INT,
    vendors_key INT,
    product_code VARCHAR(32),
    product_name VARCHAR(512),
    product_type VARCHAR(64),
    product_format VARCHAR(128),
    product_categories_list VARCHAR(512),
    product_fields_of_study_list VARCHAR(512),
    product_fields_of_interest_list VARCHAR(512),
    product_skill_level VARCHAR(128),
    product_scope VARCHAR(64),
    product_availability VARCHAR(128),
    product_company VARCHAR(128),
    product_division VARCHAR(128),
    product_gl_account VARCHAR(64),
    product_vendor_code_1 VARCHAR(64),
    product_vendor_code_2 VARCHAR(64),
    firm_program_yn VARCHAR(25),
    load_ts TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
