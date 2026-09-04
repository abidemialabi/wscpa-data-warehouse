DROP PROCEDURE IF EXISTS wscpa_dw.sp_load_fact_member_milestone_history;

DELIMITER $$

CREATE PROCEDURE wscpa_dw.sp_load_fact_member_milestone_history()
BEGIN

    DELETE FROM wscpa_dw.fact_MemberMilestoneHistory;

    INSERT INTO wscpa_dw.fact_MemberMilestoneHistory
    (
        MembersKey,
        MilestonesKey,
        DuesYearsKey,
        MilestoneDatesKey,
        MemberID
    )
    SELECT
        CAST(members_key AS SIGNED),
        CAST(milestones_key AS SIGNED),
        CAST(dues_years_key AS SIGNED),
        CAST(milestone_dates_key AS SIGNED),
        CAST(member_id AS CHAR(20))
    FROM wscpa_amnet.staging_member_milestone_history;

END$$

DELIMITER ;
