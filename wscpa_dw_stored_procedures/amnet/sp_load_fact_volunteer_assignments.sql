DROP PROCEDURE IF EXISTS wscpa_dw.sp_load_fact_volunteer_assignments;

DELIMITER $$

CREATE PROCEDURE wscpa_dw.sp_load_fact_volunteer_assignments()
BEGIN

    DELETE FROM wscpa_dw.fact_VolunteerAssignments;

    INSERT INTO wscpa_dw.fact_VolunteerAssignments
    (
        VolunteerOpportunitiesKey,
        VolunteersKey,
        FirmsKey,
        BeginDatesKey,
        EndDatesKey,
        VolunteerID
    )
    SELECT
        CAST(volunteer_opportunities_key AS SIGNED),
        CAST(volunteers_key AS SIGNED),
        CAST(firms_key AS SIGNED),
        CAST(begin_dates_key AS SIGNED),
        CAST(end_dates_key AS SIGNED),
        CAST(volunteer_id AS CHAR(20))
    FROM wscpa_amnet.staging_volunteer_assignments;

END$$

DELIMITER ;
