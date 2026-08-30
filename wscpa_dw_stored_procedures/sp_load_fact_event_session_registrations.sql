DROP PROCEDURE IF EXISTS wscpa_dw.sp_load_fact_event_session_registrations;

DELIMITER $$

CREATE PROCEDURE wscpa_dw.sp_load_fact_event_session_registrations()
BEGIN

    DELETE FROM wscpa_dw.fact_EventSessionRegistrations;

    INSERT INTO wscpa_dw.fact_EventSessionRegistrations
    (
        RegistrantsKey,
        GuestsKey,
        EventsKey,
        EventSessionsKey,
        RegistrantID
    )
    SELECT
        CAST(registrants_key AS SIGNED),
        CAST(guests_key AS SIGNED),
        CAST(events_key AS SIGNED),
        CAST(event_sessions_key AS SIGNED),
        CAST(registrant_id AS CHAR(20))
    FROM wscpa_amnet.staging_event_session_registrations;

END$$

DELIMITER ;
