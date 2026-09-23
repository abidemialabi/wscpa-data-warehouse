-- Create table for member committee activity
CREATE TABLE IF NOT EXISTS wscpa_dw.dw_member_committees (
    individuals_key              VARCHAR(20) NOT NULL,
    individual_id                VARCHAR(20) NULL,
    full_name                    VARCHAR(255) NULL,
    committees_key               INT NOT NULL,
    committee_code               CHAR(8) NULL,
    committee_name               VARCHAR(88) NULL,
    committee_type               VARCHAR(50) NULL,
    committee_status             VARCHAR(10) NULL,
    committee_positions_key      INT NULL,
    committee_position           VARCHAR(50) NULL,
    begin_date                   DATE NOT NULL,
    end_date                     DATE NOT NULL,
    load_ts                      TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (
        individuals_key,
        committees_key,
        begin_date,
        end_date
    ),
    INDEX ix_dw_member_committees_individual_id (individual_id),
    INDEX ix_dw_member_committees_committee (committees_key)
) ENGINE=InnoDB;
