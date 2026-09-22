-- Stored procedure to upsert member committee data
DROP PROCEDURE IF EXISTS wscpa_dw.sp_load_dw_member_committees;

DELIMITER $$

CREATE PROCEDURE wscpa_dw.sp_load_dw_member_committees()
BEGIN

    INSERT INTO wscpa_dw.dw_member_committees (
        individuals_key,
        individual_id,
        full_name,
        committees_key,
        committee_code,
        committee_name,
        committee_type,
        committee_status,
        committee_positions_key,
        committee_position,
        begin_date,
        end_date,
        load_ts
    )

    SELECT *
    FROM (
        SELECT
            i.individuals_key,
            i.individual_id,
            i.full_name,
            c.committees_key,
            c.committee_code,
            c.committee_name,
            c.committee_type,
            c.committee_status,
            cm.committee_positions_key,
            cp.committee_position,
            bd.full_date AS begin_date,
            ed.full_date AS end_date,
            CURRENT_TIMESTAMP AS load_ts

        FROM wscpa_amnet.staging_committee_members cm

        INNER JOIN wscpa_amnet.staging_individuals i
            ON CAST(cm.members_key AS CHAR) = i.individuals_key

        INNER JOIN wscpa_amnet.staging_committees c
            ON cm.committees_key = c.committees_key

        INNER JOIN wscpa_amnet.staging_committee_positions cp
            ON cm.committee_positions_key = cp.committee_positions_key

        INNER JOIN wscpa_amnet.staging_dates bd
            ON cm.begin_dates_key COLLATE utf8mb4_unicode_ci
               = bd.dates_key COLLATE utf8mb4_unicode_ci

        INNER JOIN wscpa_amnet.staging_dates ed
            ON cm.end_dates_key COLLATE utf8mb4_unicode_ci
               = ed.dates_key COLLATE utf8mb4_unicode_ci

    ) AS src

    ON DUPLICATE KEY UPDATE
        individual_id = src.individual_id,
        full_name = src.full_name,
        committee_code = src.committee_code,
        committee_name = src.committee_name,
        committee_type = src.committee_type,
        committee_status = src.committee_status,
        committee_positions_key = src.committee_positions_key,
        committee_position = src.committee_position,
        load_ts = src.load_ts;

END$$

DELIMITER ;
