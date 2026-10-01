-- Create table for member leadership score
CREATE TABLE IF NOT EXISTS wscpa_dw.dw_member_leadership_score (
    individual_id                VARCHAR(20) NOT NULL,
    leadership_metric            VARCHAR(64) NOT NULL,
    leadership_score             DECIMAL(10,2) NOT NULL DEFAULT 0,
    load_ts                      TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (individual_id, leadership_metric),
    INDEX idx_dw_member_leadership_score_individual_id (individual_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
