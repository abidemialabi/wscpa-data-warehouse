DROP PROCEDURE IF EXISTS wscpa_dw.sp_load_fact_committee_members;

DELIMITER $$

CREATE PROCEDURE wscpa_dw.sp_load_fact_committee_members()
BEGIN

    DELETE FROM wscpa_dw.fact_CommitteeMembers;

    INSERT INTO wscpa_dw.fact_CommitteeMembers
    (
        MembersKey,
        CommitteesKey,
        CommitteePositionsKey,
        BeginDatesKey,
        EndDatesKey,
        MemberID
    )
    SELECT
        CAST(members_key AS SIGNED),
        CAST(committees_key AS SIGNED),
        CAST(committee_positions_key AS SIGNED),
        CAST(begin_dates_key AS SIGNED),
        CAST(end_dates_key AS SIGNED),
        CAST(member_id AS CHAR(20))
    FROM wscpa_amnet.staging_committee_members;

END$$

DELIMITER ;
