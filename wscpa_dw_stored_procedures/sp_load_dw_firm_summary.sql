-- Stored procedure to upsert consolidated firm summary
DROP PROCEDURE IF EXISTS wscpa_dw.sp_load_dw_firm_summary;
DELIMITER $$
CREATE PROCEDURE wscpa_dw.sp_load_dw_firm_summary()
BEGIN
  INSERT INTO wscpa_dw.dw_firm_summary (
    firms_key, firm_name, firm_city, firm_state, firm_zip, general_business_type,
    specific_business_type, entity_type, firm_pays_dues_yn, person_in_charge, firms_row_effective_date,
    number_of_employees, member_count, member_penetration_rate, member_growth_decline, employee_renewal_rate,
    aggregated_dues_paid, current_dues_balance, distinct_events_attended, employee_event_registrations,
    total_cpe_hours_attended, total_event_fees_paid, last_event_date, in_house_training_purchase,
    comm_subscription_preferences, comm_engagement, activity_by_engagement_dimension, key_contacts,
    committee_participation_count, employee_committee_count, last_committee_activity_date,
    employee_volunteer_assignments, employees_with_volunteer_activity, last_volunteer_assignment_date,
    total_in_house_training_purchase, total_purchase_transactions, total_employee_contributions,
    pac_contributions, foundation_contributions, employee_community_activity_count, employees_with_community_activity,
    last_community_activity_date, latest_firm_engagement_score, total_engagement_event_registrations,
    total_engagement_committee_attendance, total_engagement_contributions, total_engagement_volunteer_activity,
    total_engagement_log_activity, load_ts
  )
  WITH latest_firm_rows AS (
    SELECT
        f.*,
        ROW_NUMBER() OVER (
            PARTITION BY
                LOWER(TRIM(COALESCE(f.firm_name, ''))),
                LOWER(TRIM(COALESCE(f.firm_city, ''))),
                LOWER(TRIM(COALESCE(f.firm_state, ''))),
                LOWER(TRIM(COALESCE(f.firm_zip, '')))
            ORDER BY
                CASE
                    WHEN NULLIF(TRIM(f.firms_row_effective_date), '') IS NULL
                        OR TRIM(f.firms_row_effective_date) IN ('0', 'N/A', '^N/A^')
                        THEN '1900-01-01 00:00:00'
                    WHEN REGEXP_LIKE(TRIM(f.firms_row_effective_date), '^[0-9]{8}$')
                        THEN STR_TO_DATE(TRIM(f.firms_row_effective_date), '%Y%m%d')
                    WHEN REGEXP_LIKE(TRIM(f.firms_row_effective_date), '^[0-9]{4}-[0-9]{2}-[0-9]{2} [0-9]{2}:[0-9]{2}:[0-9]{2}$')
                        THEN STR_TO_DATE(TRIM(f.firms_row_effective_date), '%Y-%m-%d %H:%i:%s')
                    WHEN REGEXP_LIKE(TRIM(f.firms_row_effective_date), '^[0-9]{4}-[0-9]{2}-[0-9]{2}$')
                        THEN STR_TO_DATE(TRIM(f.firms_row_effective_date), '%Y-%m-%d')
                    WHEN REGEXP_LIKE(TRIM(f.firms_row_effective_date), '^[0-9]{1,2}/[0-9]{1,2}/[0-9]{4}$')
                        THEN STR_TO_DATE(TRIM(f.firms_row_effective_date), '%m/%d/%Y')
                    WHEN REGEXP_LIKE(TRIM(f.firms_row_effective_date), '^[0-9]{4}/[0-9]{2}/[0-9]{2}$')
                        THEN STR_TO_DATE(TRIM(f.firms_row_effective_date), '%Y/%m/%d')
                    ELSE '1900-01-01 00:00:00'
                END DESC,
                f.load_ts DESC
        ) AS rn
    FROM wscpa_amnet.staging_firms f
  ),
  current_firm_rows AS (
    SELECT * FROM latest_firm_rows WHERE rn = 1
  ),
  latest_employee_rows AS (
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
  firm_employee_base AS (
    SELECT
        i.employers_key AS firms_key,
        i.individual_id,
        LOWER(TRIM(i.email_address)) AS employee_email,
        i.full_name,
        i.member_yn,
        i.member_status,
        i.member_type,
        i.license_status,
        i.certification_status,
        i.email_opt_in,
        i.email_opt_out,
        i.fields_of_interest_list,
        i.areas_of_expertise_list,
        i.volunteer_status,
        i.volunteer_committed_yn,
        i.title,
        i.position_description,
        i.joined_date,
        i.termination_date,
        i.individuals_row_effective_date
    FROM latest_employee_rows i
    WHERE i.rn = 1
  ),
  firm_employee_counts AS (
    SELECT
        firms_key,
        COUNT(*) AS number_of_employees,
        SUM(CASE WHEN LOWER(TRIM(member_yn)) = 'y' OR LOWER(TRIM(member_status)) LIKE '%member%' THEN 1 ELSE 0 END) AS member_count,
        SUM(CASE WHEN LOWER(TRIM(member_yn)) = 'y' OR LOWER(TRIM(member_status)) LIKE '%member%' THEN 1 ELSE 0 END) / NULLIF(COUNT(*), 0) AS member_penetration_rate,
        COUNT(DISTINCT CASE WHEN LOWER(TRIM(member_status)) NOT IN ('', 'n/a', '^n/a^', 'not a member', 'inactive') THEN member_status END) AS distinct_member_status_count
    FROM firm_employee_base
    GROUP BY firms_key
  ),
  firm_dues_summary AS (
    SELECT
        i.firms_key,
        SUM(CAST(REPLACE(REPLACE(REPLACE(COALESCE(dy.dy_dues_net_payments, '0'), '$', ''), ',', ''), ' ', '') AS DECIMAL(19,4))) AS aggregated_dues_paid,
        SUM(CAST(REPLACE(REPLACE(REPLACE(COALESCE(dy.dy_dues_balance, '0'), '$', ''), ',', ''), ' ', '') AS DECIMAL(19,4))) AS current_dues_balance,
        SUM(CASE WHEN NULLIF(TRIM(dy.dy_last_payment_date), '') IS NOT NULL AND TRIM(dy.dy_last_payment_date) NOT IN ('0', 'N/A', '^N/A^') THEN 1 ELSE 0 END) AS employees_with_renewal_payment,
        COUNT(*) AS dues_snapshot_count
    FROM wscpa_amnet.staging_dues_year_individual_snapshots dy
    JOIN firm_employee_base i
        ON i.individual_id = dy.individual_id
    GROUP BY i.firms_key
  ),
  firm_event_summary AS (
    SELECT
        i.firms_key,
        COUNT(DISTINCT r.events_key) AS distinct_events_attended,
        COUNT(*) AS employee_event_registrations,
        SUM(COALESCE(r.credit_hours_earned_at_event, 0)) AS total_cpe_hours_attended,
        SUM(COALESCE(r.fees_paid_total, 0)) AS total_event_fees_paid,
        MAX(COALESCE(e.begin_dates_key, e.end_dates_key)) AS last_event_date
    FROM wscpa_amnet.staging_event_registrations r
    JOIN firm_employee_base i
        ON i.individual_id = r.registrant_id
    LEFT JOIN wscpa_amnet.staging_events e
        ON r.events_key = e.events_key
    GROUP BY i.firms_key
  ),
  firm_committee_summary AS (
    SELECT
      i.firms_key,
      COUNT(DISTINCT c.committees_key) AS committee_participation_count,
      COUNT(DISTINCT c.member_id) AS employee_committee_count,
      MAX(COALESCE(a.meeting_dates_key, c.begin_dates_key)) AS last_committee_activity_date
    FROM wscpa_amnet.staging_committee_members c
    JOIN firm_employee_base i
      ON i.individual_id = c.member_id
    LEFT JOIN wscpa_amnet.staging_committee_meeting_attendance a
      ON c.member_id = a.member_id
    GROUP BY i.firms_key
    ),
    firm_volunteer_summary AS (
    SELECT
      i.firms_key,
      COUNT(*) AS employee_volunteer_assignments,
      COUNT(DISTINCT i.individual_id) AS employees_with_volunteer_activity,
      MAX(COALESCE(v.begin_dates_key, v.end_dates_key)) AS last_volunteer_assignment_date
    FROM wscpa_amnet.staging_volunteer_assignments v
    JOIN firm_employee_base i
      ON i.individual_id = v.volunteer_id
    GROUP BY i.firms_key
    ),
    firm_purchase_summary AS (
    SELECT
      i.firms_key,
      SUM(COALESCE(ps.extended_net_price, 0)) AS total_in_house_training_purchase,
      COUNT(*) AS total_purchase_transactions,
      COUNT(DISTINCT i.individual_id) AS employees_with_purchases
    FROM wscpa_amnet.staging_product_sales ps
    JOIN firm_employee_base i
      ON i.individual_id = ps.purchaser_id
    GROUP BY i.firms_key
    ),
    firm_contribution_summary AS (
    SELECT
      i.firms_key,
      SUM(COALESCE(c.contribution_amount, 0)) AS total_employee_contributions,
      COUNT(*) AS employee_contribution_count,
      NULL AS pac_contributions,
      NULL AS foundation_contributions
    FROM wscpa_amnet.staging_contributions c
    JOIN firm_employee_base i
      ON i.individual_id = c.contributor_id
    GROUP BY i.firms_key
    ),
    firm_community_summary AS (
    SELECT
      i.firms_key,
      COUNT(*) AS employee_community_activity_count,
      COUNT(DISTINCT i.individual_id) AS employees_with_community_activity,
      MAX(COALESCE(l.add_dates_key, p.conversion_dates_key)) AS last_community_activity_date
    FROM (
      SELECT contact_id AS individual_id, add_dates_key, NULL AS conversion_dates_key
      FROM wscpa_amnet.staging_log_history
      UNION ALL
      SELECT individual_id, NULL AS add_dates_key, conversion_dates_key
      FROM wscpa_amnet.staging_promotion_conversions
    ) x
    JOIN firm_employee_base i
      ON i.individual_id = x.individual_id
    LEFT JOIN wscpa_amnet.staging_log_history l
      ON x.individual_id = l.contact_id
    LEFT JOIN wscpa_amnet.staging_promotion_conversions p
      ON x.individual_id = p.individual_id
    GROUP BY i.firms_key
    ),
    firm_engagement_summary AS (
      SELECT
          i.firms_key,
          MAX(CASE WHEN REGEXP_LIKE(TRIM(COALESCE(ep.engagement_score, '')), '^[-]?[0-9]+(\.[0-9]+)?$') THEN CAST(TRIM(ep.engagement_score) AS DECIMAL(9,2)) ELSE NULL END) AS latest_firm_engagement_score,
          SUM(CASE WHEN REGEXP_LIKE(TRIM(COALESCE(ep.ep_event_registration_count, '')), '^[0-9]+$') THEN CAST(ep.ep_event_registration_count AS SIGNED) ELSE 0 END) AS total_engagement_event_registrations,
          SUM(CASE WHEN REGEXP_LIKE(TRIM(COALESCE(ep.ep_committee_attendance_count, '')), '^[0-9]+$') THEN CAST(ep.ep_committee_attendance_count AS SIGNED) ELSE 0 END) AS total_engagement_committee_attendance,
          SUM(CASE WHEN REGEXP_LIKE(TRIM(COALESCE(ep.ep_contribution_count, '')), '^[0-9]+$') THEN CAST(ep.ep_contribution_count AS SIGNED) ELSE 0 END) AS total_engagement_contributions,
          SUM(CASE WHEN REGEXP_LIKE(TRIM(COALESCE(ep.ep_volunteer_assignment_count, '')), '^[0-9]+$') THEN CAST(ep.ep_volunteer_assignment_count AS SIGNED) ELSE 0 END) AS total_engagement_volunteer_activity,
          SUM(CASE WHEN REGEXP_LIKE(TRIM(COALESCE(ep.ep_log_engagement_count, '')), '^[0-9]+$') THEN CAST(ep.ep_log_engagement_count AS SIGNED) ELSE 0 END) AS total_engagement_log_activity
      FROM wscpa_amnet.staging_engagement_period_snapshots ep
      JOIN firm_employee_base i
          ON i.individual_id = ep.individual_id
      GROUP BY i.firms_key
    )
  SELECT * FROM (
  SELECT
    f.firms_key,
    f.firm_name,
    f.firm_city,
    f.firm_state,
    f.firm_zip,
    f.general_business_type,
    f.specific_business_type,
    f.entity_type,
    f.firm_pays_dues_yn,
    f.person_in_charge,
    f.firms_row_effective_date,
    fec.number_of_employees,
    fec.member_count,
    fec.member_penetration_rate,
    NULL AS member_growth_decline,
    CASE
        WHEN fec.member_count IS NULL OR fec.member_count = 0 THEN NULL
        ELSE (CASE WHEN d.employees_with_renewal_payment IS NULL THEN 0 ELSE d.employees_with_renewal_payment END / fec.member_count)
    END AS employee_renewal_rate,
    d.aggregated_dues_paid,
    d.current_dues_balance,
    esh.distinct_events_attended,
    esh.employee_event_registrations,
    esh.total_cpe_hours_attended,
    esh.total_event_fees_paid,
    esh.last_event_date,
    NULL AS in_house_training_purchase,
    NULL AS comm_subscription_preferences,
    NULL AS comm_engagement,
    NULL AS activity_by_engagement_dimension,
    NULL AS key_contacts,
    cmt.committee_participation_count,
    cmt.employee_committee_count,
    cmt.last_committee_activity_date,
    v.employee_volunteer_assignments,
    v.employees_with_volunteer_activity,
    v.last_volunteer_assignment_date,
    ps.total_in_house_training_purchase,
    ps.total_purchase_transactions,
    csum.total_employee_contributions,
    csum.pac_contributions,
    csum.foundation_contributions,
    com.employee_community_activity_count,
    com.employees_with_community_activity,
    com.last_community_activity_date,
    eng.latest_firm_engagement_score,
    eng.total_engagement_event_registrations,
    eng.total_engagement_committee_attendance,
    eng.total_engagement_contributions,
    eng.total_engagement_volunteer_activity,
    eng.total_engagement_log_activity,
    CURRENT_TIMESTAMP AS load_ts
  FROM current_firm_rows f
  LEFT JOIN firm_employee_counts fec
    ON f.firms_key = fec.firms_key
  LEFT JOIN firm_dues_summary d
    ON f.firms_key = d.firms_key
  LEFT JOIN firm_event_summary esh
    ON f.firms_key = esh.firms_key
  LEFT JOIN firm_committee_summary cmt
    ON f.firms_key = cmt.firms_key
  LEFT JOIN firm_volunteer_summary v
    ON f.firms_key = v.firms_key
  LEFT JOIN firm_purchase_summary ps
    ON f.firms_key = ps.firms_key
  LEFT JOIN firm_contribution_summary csum
    ON f.firms_key = csum.firms_key
  LEFT JOIN firm_community_summary com
    ON f.firms_key = com.firms_key
  LEFT JOIN firm_engagement_summary eng
    ON f.firms_key = eng.firms_key
  ) AS src

  ON DUPLICATE KEY UPDATE
    firm_name = src.firm_name,
    firm_city = src.firm_city,
    firm_state = src.firm_state,
    firm_zip = src.firm_zip,
    general_business_type = src.general_business_type,
    specific_business_type = src.specific_business_type,
    entity_type = src.entity_type,
    firm_pays_dues_yn = src.firm_pays_dues_yn,
    person_in_charge = src.person_in_charge,
    firms_row_effective_date = src.firms_row_effective_date,
    number_of_employees = src.number_of_employees,
    member_count = src.member_count,
    member_penetration_rate = src.member_penetration_rate,
    member_growth_decline = src.member_growth_decline,
    employee_renewal_rate = src.employee_renewal_rate,
    aggregated_dues_paid = src.aggregated_dues_paid,
    current_dues_balance = src.current_dues_balance,
    distinct_events_attended = src.distinct_events_attended,
    employee_event_registrations = src.employee_event_registrations,
    total_cpe_hours_attended = src.total_cpe_hours_attended,
    total_event_fees_paid = src.total_event_fees_paid,
    last_event_date = src.last_event_date,
    in_house_training_purchase = src.in_house_training_purchase,
    comm_subscription_preferences = src.comm_subscription_preferences,
    comm_engagement = src.comm_engagement,
    activity_by_engagement_dimension = src.activity_by_engagement_dimension,
    key_contacts = src.key_contacts,
    committee_participation_count = src.committee_participation_count,
    employee_committee_count = src.employee_committee_count,
    last_committee_activity_date = src.last_committee_activity_date,
    employee_volunteer_assignments = src.employee_volunteer_assignments,
    employees_with_volunteer_activity = src.employees_with_volunteer_activity,
    last_volunteer_assignment_date = src.last_volunteer_assignment_date,
    total_in_house_training_purchase = src.total_in_house_training_purchase,
    total_purchase_transactions = src.total_purchase_transactions,
    total_employee_contributions = src.total_employee_contributions,
    pac_contributions = src.pac_contributions,
    foundation_contributions = src.foundation_contributions,
    employee_community_activity_count = src.employee_community_activity_count,
    employees_with_community_activity = src.employees_with_community_activity,
    last_community_activity_date = src.last_community_activity_date,
    latest_firm_engagement_score = src.latest_firm_engagement_score,
    total_engagement_event_registrations = src.total_engagement_event_registrations,
    total_engagement_committee_attendance = src.total_engagement_committee_attendance,
    total_engagement_contributions = src.total_engagement_contributions,
    total_engagement_volunteer_activity = src.total_engagement_volunteer_activity,
    total_engagement_log_activity = src.total_engagement_log_activity,
    load_ts = src.load_ts;

END$$
DELIMITER ;
