-- Stored procedure to upsert consolidated member summary
DROP PROCEDURE IF EXISTS wscpa_dw.sp_load_dw_member_summary;

DELIMITER $$

CREATE PROCEDURE wscpa_dw.sp_load_dw_member_summary()
BEGIN
        INSERT INTO wscpa_dw.dw_member_summary (
        member_email, individual_id, individuals_row_effective_date, full_name, position_code, position_description,
        member_status, member_type,
        license_status, certification_status, joined_date, reinstatement_date, termination_date,
        email_opt_in, email_opt_out, fields_of_interest_list, areas_of_expertise_list, firm_name, firm_pays_dues_yn,
        general_business_type, specific_business_type, entity_type, preferred_address, preferred_city,
        preferred_state, preferred_zip, home_phone, renewal_date, dues_balance,
        last_invoice_date, last_payment_date, consecutive_years_of_membership, cumulative_years_of_membership,
        event_registration_count, distinct_event_count, cpe_hours_at_events, last_event_date, first_event_date,
        total_credit_hours_earned, last_cpe_date, credit_earning_events, total_purchase_amount, purchase_count,
        last_purchase_date, total_event_fee_billing, total_event_fee_payments, committee_count, committee_meeting_attendance_count,
        last_committee_activity_date, volunteer_assignment_count, last_volunteer_assignment_date, total_contribution_amount,
        contribution_count, last_contribution_date, latest_engagement_score, last_engagement_period_end_date,
        ep_event_registration_count, ep_committee_attendance_count, ep_contribution_count, ep_volunteer_assignment_count,
        ep_log_engagement_count, total_community_activity_count, last_activity_date, days_since_last_activity,
        last_milestone_date, milestone_count,
        am_net_id, amnet_last_sync, cpe_spend_current_year, cpe_spend_previous_fy, fields_of_interest,
        first_conversion_date, hs_analytics_num_page_views, hs_analytics_num_visits, hs_email_click,
        hs_email_delivered, hs_email_last_click_date, hs_email_last_email_name, hs_email_open,
        hs_email_sends_since_last_engagement,
        user_role,
        total_posts,
        total_post_views,
        total_post_comments,
        total_post_votes,
        total_followers,
        load_ts
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
    SELECT DISTINCT
        LOWER(TRIM(i.email_address)) AS member_email,
         i.individual_id,
        i.individuals_row_effective_date,
        i.full_name,
        i.position_code,
        i.position_description,
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
        f.firm_pays_dues_yn,
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
    ,
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
    ),
	hubspot_contact AS (
		SELECT DISTINCT
			am_net_id,
			amnet_last_sync,
			cpe_spend_current_year,
			cpe_spend_previous_fy,
			email,
			fields_of_interest,
			first_conversion_date,
			hs_analytics_num_page_views,
			hs_analytics_num_visits,
			hs_email_click,
			hs_email_delivered,
			hs_email_last_click_date,
			hs_email_last_email_name,
			hs_email_open,
			hs_email_sends_since_last_engagement
		FROM wscpa_dw.dw_hubspot_contacts 
	),
    user_posts AS (
        SELECT
            user_email,
            title AS user_role,
            SUM(posts_count) AS total_posts,
            SUM(view_count) AS total_post_views,
            SUM(comments_count) AS total_post_comments,
            SUM(votes_count) AS total_post_votes,
            SUM(followers_count) AS total_followers
        FROM wscpa_dw.dw_breezio_users
        WHERE NULLIF(TRIM(user_email), '') IS NOT NULL
        GROUP BY user_email, title
    )
    SELECT * 
	FROM 
	(
    SELECT DISTINCT
		b.member_email,
        b.individual_id,
        b.individuals_row_effective_date,
        b.full_name,
        b.position_code,
        b.position_description,
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
        b.firm_pays_dues_yn,
        b.general_business_type,
		b.specific_business_type,
		b.entity_type,
		b.preferred_address,
		b.preferred_city,
		b.preferred_state,
		b.preferred_zip,
		b.home_phone,
		COALESCE(d.last_payment_date, b.joined_date) AS renewal_date,
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
		NULLIF(TRIM(e.latest_engagement_score), '') AS latest_engagement_score,
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
		m.last_milestone_date,
		m.milestone_count,
		hc.am_net_id,
		hc.amnet_last_sync,
		hc.cpe_spend_current_year,
		hc.cpe_spend_previous_fy,
		hc.fields_of_interest,
		hc.first_conversion_date,
		hc.hs_analytics_num_page_views,
		hc.hs_analytics_num_visits,
		hc.hs_email_click,
		hc.hs_email_delivered,
		hc.hs_email_last_click_date,
		hc.hs_email_last_email_name,
        hc.hs_email_open,
        hc.hs_email_sends_since_last_engagement,
        up.user_role AS user_role,
        COALESCE(up.total_posts, 0) AS total_posts,
        COALESCE(up.total_post_views, 0) AS total_post_views,
        COALESCE(up.total_post_comments, 0) AS total_post_comments,
        COALESCE(up.total_post_votes, 0) AS total_post_votes,
        COALESCE(up.total_followers, 0) AS total_followers,
        CURRENT_TIMESTAMP AS load_ts
    FROM member_base b
	LEFT JOIN hubspot_contact hc
		ON LOWER(b.member_email) = LOWER(hc.email)
    LEFT JOIN user_posts up
        ON LOWER(b.member_email) = LOWER(up.user_email)
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
    WHERE b.member_email IS NOT NULL
	) AS src

    ON DUPLICATE KEY UPDATE
        individual_id = src.individual_id,
        individuals_row_effective_date = src.individuals_row_effective_date,
        full_name = src.full_name,
        position_code = src.position_code,
        position_description = src.position_description,
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
        firm_pays_dues_yn = src.firm_pays_dues_yn,
        general_business_type = src.general_business_type,
        specific_business_type = src.specific_business_type,
        entity_type = src.entity_type,
        preferred_address = src.preferred_address,
        preferred_city = src.preferred_city,
        preferred_state = src.preferred_state,
        preferred_zip = src.preferred_zip,
        home_phone = src.home_phone,
        renewal_date = src.renewal_date,
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
        last_milestone_date = src.last_milestone_date,
        milestone_count = src.milestone_count,
        am_net_id = src.am_net_id,
        amnet_last_sync = src.amnet_last_sync,
        cpe_spend_current_year = src.cpe_spend_current_year,
        cpe_spend_previous_fy = src.cpe_spend_previous_fy,
        fields_of_interest = src.fields_of_interest,
        first_conversion_date = src.first_conversion_date,
        hs_analytics_num_page_views = src.hs_analytics_num_page_views,
        hs_analytics_num_visits = src.hs_analytics_num_visits,
        hs_email_click = src.hs_email_click,
        hs_email_delivered = src.hs_email_delivered,
        hs_email_last_click_date = src.hs_email_last_click_date,
        hs_email_last_email_name = src.hs_email_last_email_name,
        hs_email_open = src.hs_email_open,
        hs_email_sends_since_last_engagement = src.hs_email_sends_since_last_engagement,
        user_role = src.user_role,
        total_posts = src.total_posts,
        total_post_views = src.total_post_views,
        total_post_comments = src.total_post_comments,
        total_post_votes = src.total_post_votes,
        total_followers = src.total_followers,
        load_ts = src.load_ts;

END$$

DELIMITER;
