DROP TABLE IF EXISTS wscpa_amnet.staging_committee_positions;


CREATE TABLE wscpa_amnet.staging_committee_positions (
	committee_positions_key INT NOT NULL,
	committee_position VARCHAR(50) NULL,
  PRIMARY KEY (committee_positions_key)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;