DROP PROCEDURE IF EXISTS wscpa_dw.sp_load_fact_event_registrations;

DELIMITER $$

CREATE PROCEDURE wscpa_dw.sp_load_fact_event_registrations()
BEGIN

    DELETE FROM wscpa_dw.fact_EventRegistrations;

    INSERT INTO wscpa_dw.fact_EventRegistrations
    (
        RegistrantsKey,
        EventsKey,
        RegistrationStatusesKey,
        RegistrationDatesKey,
        CompletionDatesKey,
        ResellersKey,
        RegistrantID,
        CancellationDate,
        CreditHoursEarnedAtEvent,
        FeesBilledTotal,
        FeesPaidTotal,
        FeesPaidDate,
        FeesBalanceDue,
        MilesFromHome,
        MilesFromWork,
        MilesFromPreferredAddress,
        DaysBeforeEvent,
        RegistrantAge,
        RegistrantAgeBracket
    )
    SELECT
        CAST(registrants_key AS SIGNED),
        CAST(events_key AS SIGNED),
        CAST(registration_statuses_key AS SIGNED),
        CAST(registration_dates_key AS SIGNED),
        CAST(completion_dates_key AS SIGNED),
        CAST(resellers_key AS SIGNED),
        CAST(registrant_id AS CHAR(20)),
        CAST(cancellation_date AS DATE),
        CAST(credit_hours_earned_at_event AS DECIMAL(6,2)),
        CAST(fees_billed_total AS DECIMAL(12,2)),
        CAST(fees_paid_total AS DECIMAL(12,2)),
        CAST(fees_paid_date AS DATE),
        CAST(fees_balance_due AS DECIMAL(12,2)),
        CAST(miles_from_home AS DECIMAL(9,2)),
        CAST(miles_from_work AS DECIMAL(9,2)),
        CAST(miles_from_preferred_address AS DECIMAL(9,2)),
        CAST(days_before_event AS SIGNED),
        CAST(registrant_age AS SIGNED),
        CAST(registrant_age_bracket AS CHAR(10))
    FROM wscpa_amnet.staging_event_registrations;

END$$

DELIMITER ;
