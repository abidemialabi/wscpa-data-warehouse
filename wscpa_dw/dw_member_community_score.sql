-- Create table for member community score
CREATE TABLE IF NOT EXISTS wscpa_dw.dw_member_community_score (
    individual_id                VARCHAR(20) NOT NULL,
    community_type               VARCHAR(50) NOT NULL,
    community_score              DECIMAL(10,2) NOT NULL DEFAULT 0,
    post_count_total             INT NULL DEFAULT 0,
    post_views_total             BIGINT NULL DEFAULT 0,
    post_comments_total          BIGINT NULL DEFAULT 0,
    post_votes_total             BIGINT NULL DEFAULT 0,
    post_followers_total         BIGINT NULL DEFAULT 0,
    load_ts                      TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (individual_id, community_type),
    INDEX idx_dw_member_community_score_individual_id (individual_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
