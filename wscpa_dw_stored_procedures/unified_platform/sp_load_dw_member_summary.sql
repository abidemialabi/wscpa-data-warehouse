-- Stored procedure to upsert consolidated member summary
DROP PROCEDURE IF EXISTS wscpa_dw.sp_load_dw_member_summary;
DELIMITER $$
CREATE PROCEDURE wscpa_dw.sp_load_dw_member_summary()
BEGIN
  INSERT INTO wscpa_dw.dw_member_summary (
    member_email, individuals_row_effective_date, full_name, member_status, member_type,
    license_status, certification_status, joined_date, reinstatement_date, termination_date,
    email_opt_in, email_opt_out, fields_of_interest_list, areas_of_expertise_list, firm_name,
    general_business_type, specific_business_type, entity_type, preferred_address, preferred_city,
    preferred_state, preferred_zip, home_phone, renewal_details, dues_balance,
    last_invoice_date, last_payment_date, consecutive_years_of_membership, cumulative_years_of_membership,
    event_registration_count, distinct_event_count, cpe_hours_at_events, last_event_date, first_event_date,
    total_credit_hours_earned, last_cpe_date, credit_earning_events, total_purchase_amount, purchase_count,
    last_purchase_date, total_event_fee_billing, total_event_fee_payments, committee_count, committee_meeting_attendance_count,
    last_committee_activity_date, volunteer_assignment_count, last_volunteer_assignment_date, total_contribution_amount,
    contribution_count, last_contribution_date, latest_engagement_score, last_engagement_period_end_date,
    ep_event_registration_count, ep_committee_attendance_count, ep_contribution_count, ep_volunteer_assignment_count,
    ep_log_engagement_count, total_community_activity_count, last_activity_date, days_since_last_activity,
    email_click_history, community_activity, declared_fields_of_interest, behavioral_fields_of_interest,
    next_best_action_recommendations, course_recommendations, donor_propensity, volunteer_propensity,
    lapse_risk, purchase_propensity, speaker_flag, author_flag, pac_contributions, foundation_contributions,
    last_milestone_date, milestone_count, load_ts
  )
  WITH latest_member_rows AS (
    SELECT
        i.*,
        ROW_NUMBER() OVER (
            PARTITION BY LOWER(TRIM(i.email_address))
            ORDER BY
                CASE
                    WHEN NULLIF(TRIM(i.individuals_row_effective_date), '') IS NULL
                        OR TRIM(i.individuals_row_effective_date) IN ('0', 'N/A', '^N/A^')
                        THEN '1900-01-01 00:00:00'
                    WHEN REGEXP_LIKE(TRIM(i.individuals_row_effective_date), '^[0-9]{8}$')
                        THEN STR_TO_DATE(TRIM(i.individuals_row_effective_date), '%Y%m%d')
                    WHEN REGEXP_LIKE(TRIM(i.individuals_row_effective_date), '^[0-9]{4}-[0-9]{2}-[0-9]{2} [0-9]{2}:[0-9]{2}:[0-9]{2}$')
                        THEN STR_TO_DATE(TRIM(i.individuals_row_effective_date), '%Y-%m-%d %H:%i:%s')
                    WHEN REGEXP_LIKE(TRIM(i.individuals_row_effective_date), '^[0-9]{4}-[0-9]{2}-[0-9]{2}$')
                        THEN STR_TO_DATE(TRIM(i.individuals_row_effective_date), '%Y-%m-%d')
                    WHEN REGEXP_LIKE(TRIM(i.individuals_row_effective_date), '^[0-9]{1,2}/[0-9]{1,2}/[0-9]{4}$')
                        THEN STR_TO_DATE(TRIM(i.individuals_row_effective_date), '%m/%d/%Y')
                    WHEN REGEXP_LIKE(TRIM(i.individuals_row_effective_date), '^[0-9]{4}/[0-9]{2}/[0-9]{2}$')
                        THEN STR_TO_DATE(TRIM(i.individuals_row_effective_date), '%Y/%m/%d')
                    ELSE '1900-01-01 00:00:00'
                END DESC,
                i.load_ts DESC
        ) AS rn
    FROM wscpa_amnet.staging_individuals i
    WHERE NULLIF(TRIM(i.email_address), '') IS NOT NULL
  ),
  member_base AS (
    SELECT
        LOWER(TRIM(i.email_address)) AS member_email,
        i.individual_id,
        i.individuals_row_effective_date,
        i.full_name,
        i.member_status,
        i.member_type,
        i.license_status,
        i.certification_status,
        i.joined_date,
        i.reinstatement_date,
        i.termination_date,
        CASE
            WHEN TRIM(COALESCE(i.email_opt_in, '')) IN ('', 'N/A', '^N/A^') THEN 'N/A'
            WHEN TRIM(i.email_opt_in) LIKE '%^%' THEN TRIM(BOTH ', ' FROM REPLACE(TRIM(i.email_opt_in), '^', ', '))
            ELSE TRIM(i.email_opt_in)
        END AS email_opt_in,
        CASE
            WHEN TRIM(COALESCE(i.email_opt_out, '')) IN ('', 'N/A', '^N/A^') THEN 'N/A'
            WHEN TRIM(i.email_opt_out) LIKE '%^%' THEN TRIM(BOTH ', ' FROM REPLACE(TRIM(i.email_opt_out), '^', ', '))
            ELSE TRIM(i.email_opt_out)
        END AS email_opt_out,
        CASE
            WHEN TRIM(COALESCE(i.fields_of_interest_list, '')) IN ('', 'N/A', '^N/A^') THEN 'N/A'
            WHEN TRIM(i.fields_of_interest_list) LIKE '%^%' THEN TRIM(BOTH ', ' FROM REPLACE(TRIM(i.fields_of_interest_list), '^', ', '))
            ELSE TRIM(i.fields_of_interest_list)
        END AS fields_of_interest_list,
        CASE
            WHEN TRIM(COALESCE(i.areas_of_expertise_list, '')) IN ('', 'N/A', '^N/A^') THEN 'N/A'
            WHEN TRIM(i.areas_of_expertise_list) LIKE '%^%' THEN TRIM(BOTH ', ' FROM REPLACE(TRIM(i.areas_of_expertise_list), '^', ', '))
            ELSE TRIM(i.areas_of_expertise_list)
        END AS areas_of_expertise_list,
        i.volunteer_status,
        i.volunteer_committed_yn,
        i.home_phone,
        i.preferred_address,
        i.preferred_city,
        i.preferred_state,
        i.preferred_zip,
        f.firm_name,
        f.general_business_type,
        f.specific_business_type,
        f.entity_type,
        f.firm_city,
        f.firm_state,
        f.firm_zip
    FROM latest_member_rows i
    LEFT JOIN wscpa_amnet.staging_firms f
        ON i.employers_key = f.firms_key
    WHERE i.rn = 1
  ),
  member_dues AS (
    SELECT
        individual_id,
        MAX(COALESCE(dy_last_invoice_date, dy_billing_date)) AS last_invoice_date,
        MAX(COALESCE(dy_last_payment_date, dy_billing_date)) AS last_payment_date,
        MAX(dy_dues_balance) AS dues_balance,
        MAX(dy_dues_net_billing) AS dues_net_billing,
        MAX(dy_dues_net_payments) AS dues_net_payments,
        MAX(dy_consecutive_years_of_membership) AS consecutive_years_of_membership,
        MAX(dy_cumulative_years_of_membership) AS cumulative_years_of_membership,
        MAX(dy_event_registration_count) AS dy_event_registration_count,
        MAX(dy_committee_membership_count) AS dy_committee_membership_count,
        MAX(dy_product_sales_quantity) AS dy_product_sales_quantity
    FROM wscpa_amnet.staging_dues_year_individual_snapshots
    GROUP BY individual_id
  ),
  member_event_history AS (
    SELECT
        r.registrant_id AS individual_id,
        COUNT(*) AS event_registration_count,
        COUNT(DISTINCT r.events_key) AS distinct_event_count,
        SUM(COALESCE(r.credit_hours_earned_at_event, 0)) AS cpe_hours_at_events,
        MAX(COALESCE(e.begin_dates_key, e.end_dates_key)) AS last_event_date,
        MIN(COALESCE(e.begin_dates_key, e.end_dates_key)) AS first_event_date
    FROM wscpa_amnet.staging_event_registrations r
    LEFT JOIN wscpa_amnet.staging_events e
        ON r.events_key = e.events_key
    GROUP BY r.registrant_id
  )
    SELECT * FROM (
    SELECT DISTINCT
    b.member_email,
    b.individuals_row_effective_date,
    b.full_name,
    b.member_status,
    b.member_type,
    b.license_status,
    b.certification_status,
    b.joined_date,
    b.reinstatement_date,
    b.termination_date,
    b.email_opt_in,
    b.email_opt_out,
    b.fields_of_interest_list,
    b.areas_of_expertise_list,
    b.firm_name,
    b.general_business_type,
    b.specific_business_type,
    b.entity_type,
    b.preferred_address,
    b.preferred_city,
    b.preferred_state,
    b.preferred_zip,
    b.home_phone,
    COALESCE(d.last_payment_date, b.joined_date) AS renewal_details,
    d.dues_balance,
    d.last_invoice_date,
    d.last_payment_date,
    d.consecutive_years_of_membership,
    d.cumulative_years_of_membership,
    eh.event_registration_count,
    eh.distinct_event_count,
    eh.cpe_hours_at_events,
    eh.last_event_date,
    eh.first_event_date,
    NULL AS total_credit_hours_earned,
    NULL AS last_cpe_date,
    NULL AS credit_earning_events,
    NULL AS total_purchase_amount,
    NULL AS purchase_count,
    NULL AS last_purchase_date,
    NULL AS total_event_fee_billing,
    NULL AS total_event_fee_payments,
    NULL AS committee_count,
    NULL AS committee_meeting_attendance_count,
    NULL AS last_committee_activity_date,
    NULL AS volunteer_assignment_count,
    NULL AS last_volunteer_assignment_date,
    NULL AS total_contribution_amount,
    NULL AS contribution_count,
    NULL AS last_contribution_date,
    NULL AS latest_engagement_score,
    NULL AS last_engagement_period_end_date,
    NULL AS ep_event_registration_count,
    NULL AS ep_committee_attendance_count,
    NULL AS ep_contribution_count,
    NULL AS ep_volunteer_assignment_count,
    NULL AS ep_log_engagement_count,
    NULL AS total_community_activity_count,
    NULL AS last_activity_date,
    NULL AS days_since_last_activity,
    NULL AS email_click_history,
    NULL AS community_activity,
    NULL AS declared_fields_of_interest,
    NULL AS behavioral_fields_of_interest,
    NULL AS next_best_action_recommendations,
    NULL AS course_recommendations,
    NULL AS donor_propensity,
    NULL AS volunteer_propensity,
    NULL AS lapse_risk,
    NULL AS purchase_propensity,
    NULL AS speaker_flag,
    NULL AS author_flag,
    NULL AS pac_contributions,
    NULL AS foundation_contributions,
    NULL AS last_milestone_date,
    NULL AS milestone_count,
    CURRENT_TIMESTAMP AS load_ts
  FROM member_base b
  LEFT JOIN member_dues d
    ON b.individual_id = d.individual_id
  LEFT JOIN member_event_history eh
    ON b.individual_id = eh.individual_id
    WHERE b.member_email IS NOT NULL
    ) AS src

    ON DUPLICATE KEY UPDATE
        individuals_row_effective_date = src.individuals_row_effective_date,
        full_name = src.full_name,
        member_status = src.member_status,
        member_type = src.member_type,
        license_status = src.license_status,
        certification_status = src.certification_status,
        joined_date = src.joined_date,
        reinstatement_date = src.reinstatement_date,
        termination_date = src.termination_date,
        email_opt_in = src.email_opt_in,
        email_opt_out = src.email_opt_out,
        fields_of_interest_list = src.fields_of_interest_list,
        areas_of_expertise_list = src.areas_of_expertise_list,
        firm_name = src.firm_name,
        general_business_type = src.general_business_type,
        specific_business_type = src.specific_business_type,
        entity_type = src.entity_type,
        preferred_address = src.preferred_address,
        preferred_city = src.preferred_city,
        preferred_state = src.preferred_state,
        preferred_zip = src.preferred_zip,
        home_phone = src.home_phone,
        renewal_details = src.renewal_details,
        dues_balance = src.dues_balance,
        last_invoice_date = src.last_invoice_date,
        last_payment_date = src.last_payment_date,
        consecutive_years_of_membership = src.consecutive_years_of_membership,
        cumulative_years_of_membership = src.cumulative_years_of_membership,
        event_registration_count = src.event_registration_count,
        distinct_event_count = src.distinct_event_count,
        cpe_hours_at_events = src.cpe_hours_at_events,
        last_event_date = src.last_event_date,
        first_event_date = src.first_event_date,
        total_credit_hours_earned = src.total_credit_hours_earned,
        last_cpe_date = src.last_cpe_date,
        credit_earning_events = src.credit_earning_events,
        total_purchase_amount = src.total_purchase_amount,
        purchase_count = src.purchase_count,
        last_purchase_date = src.last_purchase_date,
        total_event_fee_billing = src.total_event_fee_billing,
        total_event_fee_payments = src.total_event_fee_payments,
        committee_count = src.committee_count,
        committee_meeting_attendance_count = src.committee_meeting_attendance_count,
        last_committee_activity_date = src.last_committee_activity_date,
        volunteer_assignment_count = src.volunteer_assignment_count,
        last_volunteer_assignment_date = src.last_volunteer_assignment_date,
        total_contribution_amount = src.total_contribution_amount,
        contribution_count = src.contribution_count,
        last_contribution_date = src.last_contribution_date,
        latest_engagement_score = src.latest_engagement_score,
        last_engagement_period_end_date = src.last_engagement_period_end_date,
        ep_event_registration_count = src.ep_event_registration_count,
        ep_committee_attendance_count = src.ep_committee_attendance_count,
        ep_contribution_count = src.ep_contribution_count,
        ep_volunteer_assignment_count = src.ep_volunteer_assignment_count,
        ep_log_engagement_count = src.ep_log_engagement_count,
        total_community_activity_count = src.total_community_activity_count,
        last_activity_date = src.last_activity_date,
        days_since_last_activity = src.days_since_last_activity,
        email_click_history = src.email_click_history,
        community_activity = src.community_activity,
        declared_fields_of_interest = src.declared_fields_of_interest,
        behavioral_fields_of_interest = src.behavioral_fields_of_interest,
        next_best_action_recommendations = src.next_best_action_recommendations,
        course_recommendations = src.course_recommendations,
        donor_propensity = src.donor_propensity,
        volunteer_propensity = src.volunteer_propensity,
        lapse_risk = src.lapse_risk,
        purchase_propensity = src.purchase_propensity,
        speaker_flag = src.speaker_flag,
        author_flag = src.author_flag,
        pac_contributions = src.pac_contributions,
        foundation_contributions = src.foundation_contributions,
        last_milestone_date = src.last_milestone_date,
        milestone_count = src.milestone_count,
        load_ts = src.load_ts;

END$$
DELIMITER ;
