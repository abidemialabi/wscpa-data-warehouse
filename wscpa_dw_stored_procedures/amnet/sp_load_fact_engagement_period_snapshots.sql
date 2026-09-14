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
        CAST(individuals_key AS SIGNED) AS IndividualsKey,
        CAST(months_key AS SIGNED) AS MonthsKey,
        CAST(engagement_period_begin_date AS DATE) AS EngagementPeriodBeginDate,
        CAST(engagement_period_end_date AS DATE) AS EngagementPeriodEndDate,
        CAST(engagement_score AS DECIMAL(9,2)) AS EngagementScore,
        CAST(ep_age AS SIGNED) AS EPAge,
        CAST(ep_age_bracket AS CHAR(10)) AS EPAgeBracket,
        CAST(ep_contribution_count AS SIGNED) AS EPContributionCount,
        CAST(ep_committee_membership_count AS SIGNED) AS EPCommitteeMembershipCount,
        CAST(ep_committee_attendance_count AS SIGNED) AS EPCommitteeAttendanceCount,
        CAST(ep_event_registration_count AS SIGNED) AS EPEventRegistrationCount,
        CAST(ep_product_sales_quantity AS SIGNED) AS EPProductSalesQuantity,
        CAST(ep_volunteer_assignment_count AS SIGNED) AS EPVolunteerAssignmentCount,
        CAST(ep_membership_count AS SIGNED) AS EPMembershipCount
    FROM wscpa_amnet.staging_engagement_period_snapshots

    ) AS src

    ON DUPLICATE KEY UPDATE
        EngagementPeriodBeginDate = src.EngagementPeriodBeginDate,
        EngagementPeriodEndDate = src.EngagementPeriodEndDate,
        EngagementScore = src.EngagementScore,
        EPAge = src.EPAge,
        EPAgeBracket = src.EPAgeBracket,
        EPContributionCount = src.EPContributionCount,
        EPCommitteeMembershipCount = src.EPCommitteeMembershipCount,
        EPCommitteeAttendanceCount = src.EPCommitteeAttendanceCount,
        EPEventRegistrationCount = src.EPEventRegistrationCount,
        EPProductSalesQuantity = src.EPProductSalesQuantity,
        EPVolunteerAssignmentCount = src.EPVolunteerAssignmentCount,
        EPMembershipCount = src.EPMembershipCount;

END$$

DELIMITER ;
