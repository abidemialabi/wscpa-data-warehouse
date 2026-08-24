DROP TABLE IF EXISTS wscpa_amnet.staging_product_sales;

CREATE TABLE wscpa_amnet.staging_product_sales (
    orders_key INT,
    invoice_number VARCHAR(20),
    credit_memo_number VARCHAR(20),
    products_key INT,
    purchasers_key INT,
    transaction_dates_key CHAR(25),
    purchaser_id VARCHAR(20),
    quantity SMALLINT,
    extended_net_price DECIMAL(19,4),
    extended_item_cost DECIMAL(19,4),
    margin DECIMAL(19,4),
    state_tax DECIMAL(19,4),
    local_tax DECIMAL(19,4),
    shipping_fee DECIMAL(19,4),
    member_savings DECIMAL(19,4),
    events_key INT,
    general_ledger_accounts_key INT,
    subscription_begin_dates_key CHAR(25),
    subscription_end_dates_key CHAR(25),
    load_ts TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (
        orders_key,
        invoice_number,
        credit_memo_number,
        products_key,
        events_key
    )
);
