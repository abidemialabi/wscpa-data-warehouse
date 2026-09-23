-- Stored procedure to upsert member event data
DROP PROCEDURE IF EXISTS wscpa_dw.sp_load_dw_member_events;

DELIMITER $$

CREATE PROCEDURE wscpa_dw.sp_load_dw_member_events()
BEGIN

    INSERT INTO wscpa_dw.dw_member_events (
        individuals_key,
        individual_id,
        full_name,
        events_key,
        event_name,
        registration_date,
        cancellation_date,
        event_begin_date,
        event_end_date,
        completion_date,
        registration_statuses_key,
        event_status,
        event_division,
        event_fields_of_study_list,
        event_topics_list,
        event_level,
        event_city,
        event_has_sessions_yn,
        load_ts
    )

    SELECT *
    FROM (
        SELECT
            i.individuals_key,
            i.individual_id,
            i.full_name,
            e.events_key,
            e.event_name,
            rd.full_date AS registration_date,
            er.cancellation_date,
            bd.full_date AS event_begin_date,
            ed.full_date AS event_end_date,
            cd.full_date AS completion_date,
            er.registration_statuses_key,
            e.event_status,
            e.event_division,
            e.event_fields_of_study_list,
            e.event_topics_list,
            e.event_level,
            e.event_city,
            e.event_has_sessions_yn,
            CURRENT_TIMESTAMP AS load_ts

        FROM wscpa_amnet.staging_event_registrations er

        INNER JOIN wscpa_amnet.staging_individuals i
            ON CAST(er.registrants_key AS CHAR) = i.individuals_key

        INNER JOIN wscpa_amnet.staging_events e
            ON er.events_key = e.events_key

        LEFT JOIN wscpa_amnet.staging_dates rd
            ON er.registration_dates_key COLLATE utf8mb4_unicode_ci
               = rd.dates_key COLLATE utf8mb4_unicode_ci

        LEFT JOIN wscpa_amnet.staging_dates bd
            ON e.begin_dates_key COLLATE utf8mb4_unicode_ci
               = bd.dates_key COLLATE utf8mb4_unicode_ci

        LEFT JOIN wscpa_amnet.staging_dates ed
            ON e.end_dates_key COLLATE utf8mb4_unicode_ci
               = ed.dates_key COLLATE utf8mb4_unicode_ci

        LEFT JOIN wscpa_amnet.staging_dates cd
            ON er.completion_dates_key COLLATE utf8mb4_unicode_ci
               = cd.dates_key COLLATE utf8mb4_unicode_ci

    ) AS src

    ON DUPLICATE KEY UPDATE
        individual_id = src.individual_id,
        full_name = src.full_name,
        event_name = src.event_name,
        registration_date = src.registration_date,
        cancellation_date = src.cancellation_date,
        event_begin_date = src.event_begin_date,
        event_end_date = src.event_end_date,
        completion_date = src.completion_date,
        registration_statuses_key = src.registration_statuses_key,
        event_status = src.event_status,
        event_division = src.event_division,
        event_fields_of_study_list = src.event_fields_of_study_list,
        event_topics_list = src.event_topics_list,
        event_level = src.event_level,
        event_city = src.event_city,
        event_has_sessions_yn = src.event_has_sessions_yn,
        load_ts = src.load_ts;

END$$

DELIMITER ;
