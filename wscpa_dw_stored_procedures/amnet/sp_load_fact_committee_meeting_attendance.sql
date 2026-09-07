DROP PROCEDURE IF EXISTS wscpa_dw.sp_load_fact_committee_meeting_attendance;

DELIMITER $$

CREATE PROCEDURE wscpa_dw.sp_load_fact_committee_meeting_attendance()
BEGIN

    DELETE FROM wscpa_dw.fact_CommitteeMeetingAttendance;

    INSERT INTO wscpa_dw.fact_CommitteeMeetingAttendance
    (
        MembersKey,
        MeetingDatesKey,
        AttendanceStatusesKey,
        CommitteeMeetingsKey,
        MemberID
    )
    SELECT
        CAST(members_key AS SIGNED),
        CAST(meeting_dates_key AS SIGNED),
        CAST(attendance_statuses_key AS SIGNED),
        CAST(committee_meetings_key AS SIGNED),
        CAST(member_id AS CHAR(20))
    FROM wscpa_amnet.staging_committee_meeting_attendance;

END$$

DELIMITER ;
