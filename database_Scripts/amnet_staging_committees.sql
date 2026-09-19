DROP TABLE IF EXISTS wscpa_amnet.staging_committees


CREATE TABLE wscpa_amnet.staging_committees (
	committees_key INT NOT NULL,
	committee_code CHAR(8) NULL,
	committee_name VARCHAR(88) NULL,
	committee_type VARCHAR(50) NULL,
	committee_status VARCHAR(10) NULL,
	open_to_volunteers_yn VARCHAR(3) NULL,
	committee_chapter VARCHAR(50) NULL,
	chapter_membership_required_yn VARCHAR(3) NULL,
	technical_section VARCHAR(50) NULL,
	section_membership_required_yn VARCHAR(3) NULL,
	evaluation_date VARCHAR(25) NULL,
	time_commitment VARCHAR(50) NULL,
  PRIMARY KEY (committees_key)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;