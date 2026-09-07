DROP PROCEDURE IF EXISTS wscpa_dw.sp_load_fact_engagement_period_snapshots;

DELIMITER $$

CREATE PROCEDURE wscpa_dw.sp_load_fact_engagement_period_snapshots()
BEGIN

    INSERT INTO wscpa_dw.fact_EngagementPeriodSnapshots
    (
        IndividualsKey,
        MonthsKey,
        EngagementPeriodBeginDate,
        EngagementPeriodEndDate,
        EngagementScore,
        EPAge,
        EPAgeBracket,
        EPContributionCount,
        EPCommitteeMembershipCount,
        EPCommitteeAttendanceCount,
        EPEventRegistrationCount,
        EPProductSalesQuantity,
        EPVolunteerAssignmentCount,
        EPMembershipCount
    )
    SELECT
        CAST(individuals_key AS SIGNED),
        CAST(months_key AS SIGNED),
        CAST(engagement_period_begin_date AS DATE),
        CAST(engagement_period_end_date AS DATE),
        CAST(engagement_score AS DECIMAL(9,2)),
        CAST(ep_age AS SIGNED),
        CAST(ep_age_bracket AS CHAR(10)),
        CAST(ep_contribution_count AS SIGNED),
        CAST(ep_committee_membership_count AS SIGNED),
        CAST(ep_committee_attendance_count AS SIGNED),
        CAST(ep_event_registration_count AS SIGNED),
        CAST(ep_product_sales_quantity AS SIGNED),
        CAST(ep_volunteer_assignment_count AS SIGNED),
        CAST(ep_membership_count AS SIGNED)
    FROM wscpa_amnet.staging_engagement_period_snapshots

    ON DUPLICATE KEY UPDATE
        EngagementPeriodBeginDate = VALUES(EngagementPeriodBeginDate),
        EngagementPeriodEndDate = VALUES(EngagementPeriodEndDate),
        EngagementScore = VALUES(EngagementScore),
        EPAge = VALUES(EPAge),
        EPAgeBracket = VALUES(EPAgeBracket),
        EPContributionCount = VALUES(EPContributionCount),
        EPCommitteeMembershipCount = VALUES(EPCommitteeMembershipCount),
        EPCommitteeAttendanceCount = VALUES(EPCommitteeAttendanceCount),
        EPEventRegistrationCount = VALUES(EPEventRegistrationCount),
        EPProductSalesQuantity = VALUES(EPProductSalesQuantity),
        EPVolunteerAssignmentCount = VALUES(EPVolunteerAssignmentCount),
        EPMembershipCount = VALUES(EPMembershipCount);

END$$

DELIMITER ;
