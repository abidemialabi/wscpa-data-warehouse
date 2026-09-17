/*
  Consolidated member profile query
  - Uses email address as the stable member identifier
  - Pulls from AMNET staging tables where the relational data exists
  - Leaves a few attributes as NULL placeholders for HubSpot / Breezio / ML output
    that are not yet represented in the AMNET staging layer as structured columns
*/

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
),
member_committee_activity AS (
    SELECT
        c.member_id AS individual_id,
        COUNT(DISTINCT c.committees_key) AS committee_count,
        COUNT(DISTINCT a.member_id) AS committee_meeting_attendance_count,
        MAX(COALESCE(a.meeting_dates_key, c.begin_dates_key)) AS last_committee_activity_date
    FROM wscpa_amnet.staging_committee_members c
    LEFT JOIN wscpa_amnet.staging_committee_meeting_attendance a
        ON c.member_id = a.member_id
    GROUP BY c.member_id
),
member_credit_history AS (
    SELECT
        member_id AS individual_id,
        SUM(COALESCE(credit_hours_earned, 0)) AS total_credit_hours_earned,
        MAX(completion_dates_key) AS last_cpe_date,
        COUNT(*) AS credit_earning_events
    FROM wscpa_amnet.staging_credit_hours_earned
    GROUP BY member_id
),
member_contributions AS (
    SELECT
        contributor_id AS individual_id,
        SUM(COALESCE(contribution_amount, 0)) AS total_contribution_amount,
        COUNT(*) AS contribution_count,
        MAX(transaction_dates_key) AS last_contribution_date
    FROM wscpa_amnet.staging_contributions
    GROUP BY contributor_id
),
member_purchases AS (
    SELECT
        purchaser_id AS individual_id,
        SUM(COALESCE(extended_net_price, 0)) AS total_purchase_amount,
        COUNT(*) AS purchase_count,
        MAX(transaction_dates_key) AS last_purchase_date,
        SUM(COALESCE(quantity, 0)) AS total_units_purchased
    FROM wscpa_amnet.staging_product_sales
    GROUP BY purchaser_id
),
member_event_fees AS (
    SELECT
        registrant_id AS individual_id,
        SUM(COALESCE(fee_amount, 0)) AS total_event_fee_billing,
        SUM(COALESCE(fee_payment_amount, 0)) AS total_event_fee_payments
    FROM (
        SELECT registrant_id, fee_amount, NULL AS fee_payment_amount
        FROM wscpa_amnet.staging_event_fee_billing
        UNION ALL
        SELECT registrant_id, NULL AS fee_amount, fee_payment_amount
        FROM wscpa_amnet.staging_event_fee_payments) as x
    GROUP BY registrant_id
),
member_volunteer_activity AS (
    SELECT
        volunteer_id AS individual_id,
        COUNT(*) AS volunteer_assignment_count,
        MAX(COALESCE(begin_dates_key, end_dates_key)) AS last_volunteer_assignment_date
    FROM wscpa_amnet.staging_volunteer_assignments
    GROUP BY volunteer_id
),
member_engagement AS (
    SELECT
        individual_id,
        MAX(engagement_score) AS latest_engagement_score,
        MAX(engagement_period_end_date) AS last_engagement_period_end_date,
        MAX(ep_event_registration_count) AS ep_event_registration_count,
        MAX(ep_committee_attendance_count) AS ep_committee_attendance_count,
        MAX(ep_contribution_count) AS ep_contribution_count,
        MAX(ep_volunteer_assignment_count) AS ep_volunteer_assignment_count,
        MAX(ep_log_engagement_count) AS ep_log_engagement_count
    FROM wscpa_amnet.staging_engagement_period_snapshots
    GROUP BY individual_id
),
member_community AS (
    SELECT
        contact_id AS individual_id,
        COUNT(*) AS log_entry_count,
        MAX(add_dates_key) AS last_log_date
    FROM wscpa_amnet.staging_log_history
    WHERE NULLIF(TRIM(contact_id), '') IS NOT NULL
    GROUP BY contact_id
    UNION ALL
    SELECT
        individual_id,
        SUM(COALESCE(conversion_count, 0)) AS log_entry_count,
        MAX(conversion_dates_key) AS last_log_date
    FROM wscpa_amnet.staging_promotion_conversions
    WHERE NULLIF(TRIM(individual_id), '') IS NOT NULL
    GROUP BY individual_id
),
member_activity_summary AS (
    SELECT
        individual_id,
        SUM(COALESCE(log_entry_count, 0)) AS total_community_activity_count,
        MAX(last_log_date) AS last_activity_date
    FROM member_community
    GROUP BY individual_id
),
member_activity_recency AS (
    SELECT
        individual_id,
        CASE
            WHEN NULLIF(TRIM(last_activity_date), '') IS NULL OR TRIM(last_activity_date) IN ('0', 'N/A', '^N/A^') THEN NULL
            WHEN REGEXP_LIKE(TRIM(last_activity_date), '^[0-9]{8}$') THEN DATE(STR_TO_DATE(TRIM(last_activity_date), '%Y%m%d'))
            WHEN REGEXP_LIKE(TRIM(last_activity_date), '^[0-9]{4}-[0-9]{2}-[0-9]{2} [0-9]{2}:[0-9]{2}:[0-9]{2}$') THEN DATE(STR_TO_DATE(TRIM(last_activity_date), '%Y-%m-%d %H:%i:%s'))
            WHEN REGEXP_LIKE(TRIM(last_activity_date), '^[0-9]{4}-[0-9]{2}-[0-9]{2}$') THEN DATE(STR_TO_DATE(TRIM(last_activity_date), '%Y-%m-%d'))
            WHEN REGEXP_LIKE(TRIM(last_activity_date), '^[0-9]{1,2}/[0-9]{1,2}/[0-9]{4}$') THEN DATE(STR_TO_DATE(TRIM(last_activity_date), '%m/%d/%Y'))
            WHEN REGEXP_LIKE(TRIM(last_activity_date), '^[0-9]{4}/[0-9]{2}/[0-9]{2}$') THEN DATE(STR_TO_DATE(TRIM(last_activity_date), '%Y/%m/%d'))
            ELSE NULL
        END AS last_activity_date_parsed
    FROM member_activity_summary
),
member_milestones AS (
    SELECT
        member_id AS individual_id,
        MAX(milestone_dates_key) AS last_milestone_date,
        COUNT(*) AS milestone_count
    FROM wscpa_amnet.staging_member_milestone_history
    GROUP BY member_id
)
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
    ch.total_credit_hours_earned,
    ch.last_cpe_date,
    ch.credit_earning_events,
    p.total_purchase_amount,
    p.purchase_count,
    p.last_purchase_date,
    ef.total_event_fee_billing,
    ef.total_event_fee_payments,
    ca.committee_count,
    ca.committee_meeting_attendance_count,
    ca.last_committee_activity_date,
    va.volunteer_assignment_count,
    va.last_volunteer_assignment_date,
    cn.total_contribution_amount,
    cn.contribution_count,
    cn.last_contribution_date,
    e.latest_engagement_score,
    e.last_engagement_period_end_date,
    e.ep_event_registration_count,
    e.ep_committee_attendance_count,
    e.ep_contribution_count,
    e.ep_volunteer_assignment_count,
    e.ep_log_engagement_count,
    ac.total_community_activity_count,
    ac.last_activity_date,
    CASE
        WHEN ar.last_activity_date_parsed IS NULL THEN NULL
        ELSE TIMESTAMPDIFF(DAY, ar.last_activity_date_parsed, CURRENT_DATE)
    END AS days_since_last_activity,
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
    m.last_milestone_date,
    m.milestone_count
FROM member_base b
LEFT JOIN member_dues d
    ON b.individual_id = d.individual_id
LEFT JOIN member_event_history eh
    ON b.individual_id = eh.individual_id
LEFT JOIN member_committee_activity ca
    ON b.individual_id = ca.individual_id
LEFT JOIN member_credit_history ch
    ON b.individual_id = ch.individual_id
LEFT JOIN member_contributions cn
    ON b.individual_id = cn.individual_id
LEFT JOIN member_purchases p
    ON b.individual_id = p.individual_id
LEFT JOIN member_event_fees ef
    ON b.individual_id = ef.individual_id
LEFT JOIN member_volunteer_activity va
    ON b.individual_id = va.individual_id
LEFT JOIN member_engagement e
    ON b.individual_id = e.individual_id
LEFT JOIN member_activity_summary ac
    ON b.individual_id = ac.individual_id
LEFT JOIN member_activity_recency ar
    ON b.individual_id = ar.individual_id
LEFT JOIN member_milestones m
    ON b.individual_id = m.individual_id
ORDER BY b.member_email;
