DROP PROCEDURE IF EXISTS wscpa_dw.sp_load_fact_calendar_month_individual_snapshots;

DELIMITER $$

CREATE PROCEDURE wscpa_dw.sp_load_fact_calendar_month_individual_snapshots()
BEGIN

    INSERT INTO wscpa_dw.fact_CalendarMonthIndividualSnapshots
    (
        MonthsKey,
        IndividualsKey,
        EmployersKey,
        PriorMonthIndividualsKey,
        PriorDuesYearIndividualsKey,
        MemberStatusChangeReasonsKey,
        IndividualID,
        CMAge,
        CMAgeBracket,
        CMMemberChangeCount,
        CMMemberStatusChangeCount,
        CMBillingClassChangeCount,
        CMMonthsCertified,
        CMCreditHoursEarned,
        CMDuesGrossBillingTotal,
        CMDuesAdjustmentsTotal,
        CMDuesNetBillingTotal,
        CMDuesGrossPaymentsTotal,
        CMDuesRefundsTotal,
        CMDuesNetPaymentsTotal,
        CMContributionTotal,
        CMContributionCount,
        CMCommitteeMembershipCount,
        CMCommitteeAttendanceCount,
        CMEventFeeTotal,
        CMEventPaymentTotal,
        CMEventRegistrationCount,
        CMEventAttendanceCount,
        CMProductSalesQuantity,
        CMProductExtendedNetPriceTotal,
        CMProductExtendedItemCostTotal,
        CMProductMargin,
        CMVolunteerAssignmentCount
    )
    SELECT
        CAST(months_key AS SIGNED) AS MonthsKey,
        CAST(individuals_key AS SIGNED) AS IndividualsKey,
        CAST(employers_key AS SIGNED) AS EmployersKey,
        CAST(prior_month_data_key AS SIGNED) AS PriorMonthIndividualsKey,
        CAST(prior_dues_year_data_key AS SIGNED) AS PriorDuesYearIndividualsKey,
        CAST(member_status_change_reasons_key AS SIGNED) AS MemberStatusChangeReasonsKey,
        CAST(individual_id AS CHAR(20)) AS IndividualID,
        CAST(cm_age AS SIGNED) AS CMAge,
        CAST(cm_age_bracket AS CHAR(10)) AS CMAgeBracket,
        CAST(cm_member_change_count AS SIGNED) AS CMMemberChangeCount,
        CAST(cm_member_status_change_count AS SIGNED) AS CMMemberStatusChangeCount,
        CAST(cm_billing_class_change_count AS SIGNED) AS CMBillingClassChangeCount,
        CAST(cm_months_certified AS SIGNED) AS CMMonthsCertified,
        CAST(cm_credit_hours_earned AS DECIMAL(6,2)) AS CMCreditHoursEarned,
        CAST(cm_dues_gross_billing AS DECIMAL(12,2)) AS CMDuesGrossBillingTotal,
        CAST(cm_dues_adjustments AS DECIMAL(12,2)) AS CMDuesAdjustmentsTotal,
        CAST(cm_dues_net_billing AS DECIMAL(12,2)) AS CMDuesNetBillingTotal,
        CAST(cm_dues_gross_payments AS DECIMAL(12,2)) AS CMDuesGrossPaymentsTotal,
        CAST(cm_dues_refunds AS DECIMAL(12,2)) AS CMDuesRefundsTotal,
        CAST(cm_dues_net_payments AS DECIMAL(12,2)) AS CMDuesNetPaymentsTotal,
        CAST(cm_contribution_total AS DECIMAL(12,2)) AS CMContributionTotal,
        CAST(cm_contribution_count AS SIGNED) AS CMContributionCount,
        CAST(cm_committee_membership_count AS SIGNED) AS CMCommitteeMembershipCount,
        CAST(cm_committee_attendance_count AS SIGNED) AS CMCommitteeAttendanceCount,
        CAST(cm_event_fee_total AS DECIMAL(12,2)) AS CMEventFeeTotal,
        CAST(cm_event_payment_total AS DECIMAL(12,2)) AS CMEventPaymentTotal,
        CAST(cm_event_registration_count AS SIGNED) AS CMEventRegistrationCount,
        CAST(cm_event_attendance_count AS SIGNED) AS CMEventAttendanceCount,
        CAST(cm_product_sales_quantity AS SIGNED) AS CMProductSalesQuantity,
        CAST(cm_product_extended_net_price_total AS DECIMAL(12,2)) AS CMProductExtendedNetPriceTotal,
        CAST(cm_product_extended_item_cost_total AS DECIMAL(12,2)) AS CMProductExtendedItemCostTotal,
        CAST(cm_product_margin AS DECIMAL(12,2)) AS CMProductMargin,
        CAST(cm_volunteer_assignment_count AS SIGNED) AS CMVolunteerAssignmentCount
    FROM wscpa_amnet.staging_calendar_month_individual_snapshots

    ) AS src

    ON DUPLICATE KEY UPDATE
        EmployersKey = src.EmployersKey,
        PriorMonthIndividualsKey = src.PriorMonthIndividualsKey,
        PriorDuesYearIndividualsKey = src.PriorDuesYearIndividualsKey,
        MemberStatusChangeReasonsKey = src.MemberStatusChangeReasonsKey,
        IndividualID = src.IndividualID,
        CMAge = src.CMAge,
        CMAgeBracket = src.CMAgeBracket,
        CMMemberChangeCount = src.CMMemberChangeCount,
        CMMemberStatusChangeCount = src.CMMemberStatusChangeCount,
        CMBillingClassChangeCount = src.CMBillingClassChangeCount,
        CMMonthsCertified = src.CMMonthsCertified,
        CMCreditHoursEarned = src.CMCreditHoursEarned,
        CMDuesGrossBillingTotal = src.CMDuesGrossBillingTotal,
        CMDuesAdjustmentsTotal = src.CMDuesAdjustmentsTotal,
        CMDuesNetBillingTotal = src.CMDuesNetBillingTotal,
        CMDuesGrossPaymentsTotal = src.CMDuesGrossPaymentsTotal,
        CMDuesRefundsTotal = src.CMDuesRefundsTotal,
        CMDuesNetPaymentsTotal = src.CMDuesNetPaymentsTotal,
        CMContributionTotal = src.CMContributionTotal,
        CMContributionCount = src.CMContributionCount,
        CMCommitteeMembershipCount = src.CMCommitteeMembershipCount,
        CMCommitteeAttendanceCount = src.CMCommitteeAttendanceCount,
        CMEventFeeTotal = src.CMEventFeeTotal,
        CMEventPaymentTotal = src.CMEventPaymentTotal,
        CMEventRegistrationCount = src.CMEventRegistrationCount,
        CMEventAttendanceCount = src.CMEventAttendanceCount,
        CMProductSalesQuantity = src.CMProductSalesQuantity,
        CMProductExtendedNetPriceTotal = src.CMProductExtendedNetPriceTotal,
        CMProductExtendedItemCostTotal = src.CMProductExtendedItemCostTotal,
        CMProductMargin = src.CMProductMargin,
        CMVolunteerAssignmentCount = src.CMVolunteerAssignmentCount;

END$$

DELIMITER ;
