-- Create table for member education score
CREATE TABLE IF NOT EXISTS wscpa_dw.dw_member_education_score (
    individuals_key              VARCHAR(20) NOT NULL,
    individual_id                VARCHAR(20) NULL,
    event_type_category         VARCHAR(128) NOT NULL,
    member_education_score       DECIMAL(10,2) NOT NULL DEFAULT 0,
    load_ts                      TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (individual_id, event_type_category),
    INDEX idx_dw_member_education_score_individuals_key (individuals_key)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
