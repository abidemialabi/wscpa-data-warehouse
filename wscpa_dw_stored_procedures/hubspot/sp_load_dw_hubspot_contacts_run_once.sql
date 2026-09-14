-- Run-once upsert (no DELIMITER needed). Execute this directly in your client.
INSERT INTO wscpa_dw.dw_hubspot_contacts (
    hubspot_id, am_net_id, amnet_last_sync, company_size, cpa_exam_begin_date,
    cpa_exam_last_section_pass_date, cpa_exam_review_course_purchase_date,
    cpa_exam_section_attempt_number, cpa_exam_sections_passed, cpe_spend_current_year,
    cpe_spend_previous_fy, properties_created_date, date_passed_cpa_exam, email,
    fields_of_interest, first_conversion_date, firstname, hs_analytics_num_event_completions,
    hs_analytics_num_page_views, hs_analytics_num_visits, hs_email_click, hs_email_delivered,
    hs_email_last_click_date, hs_email_last_email_name, hs_email_open, hs_email_replied,
    hs_email_sends_since_last_engagement, hs_email_type, hs_email_confirmation_status,
    hs_last_sales_activity_timestamp, hs_lead_status, hs_object_id, hs_sales_email_last_clicked,
    hs_sales_email_last_opened, hs_sales_email_last_replied, hubspot_score, properties_last_modified_date,
    lastname, notes_last_contacted, notes_last_updated, created_at, updated_at, archived,
    hubspot_url, source_file, load_ts
  )
  SELECT * FROM (
  SELECT
    CASE WHEN json_data->>'$.id' REGEXP '^[0-9]+$' THEN CAST(json_data->>'$.id' AS UNSIGNED) ELSE NULL END AS hubspot_id,
    CASE WHEN LOWER(TRIM(json_data->>'$.properties.am_net_id')) IN ('','null','n/a','^n/a^','^null^') THEN NULL ELSE json_data->>'$.properties.am_net_id' END AS am_net_id,
    CASE WHEN json_data->>'$.properties.amnet_last_sync' REGEXP '^[0-9]{4}-[0-9]{2}-[0-9]{2}' THEN STR_TO_DATE(LEFT(REPLACE(json_data->>'$.properties.amnet_last_sync','Z',''),10), '%Y-%m-%d') ELSE NULL END AS amnet_last_sync,
    CASE WHEN LOWER(TRIM(json_data->>'$.properties.company_size')) IN ('','null','n/a','^n/a^','^null^') THEN NULL ELSE json_data->>'$.properties.company_size' END AS company_size,
    CASE WHEN LOWER(TRIM(json_data->>'$.properties.cpa_exam_begin_date')) IN ('','null','n/a','^n/a^','^null^') THEN NULL ELSE json_data->>'$.properties.cpa_exam_begin_date' END AS cpa_exam_begin_date,
    CASE WHEN LOWER(TRIM(json_data->>'$.properties.cpa_exam_last_section_pass_date')) IN ('','null','n/a','^n/a^','^null^') THEN NULL ELSE json_data->>'$.properties.cpa_exam_last_section_pass_date' END AS cpa_exam_last_section_pass_date,
    CASE WHEN LOWER(TRIM(json_data->>'$.properties.cpa_exam_review_course_purchase_date')) IN ('','null','n/a','^n/a^','^null^') THEN NULL ELSE json_data->>'$.properties.cpa_exam_review_course_purchase_date' END AS cpa_exam_review_course_purchase_date,
    CASE WHEN LOWER(TRIM(json_data->>'$.properties.cpa_exam_section_attempt_number')) IN ('','null','n/a','^n/a^','^null^') THEN NULL ELSE json_data->>'$.properties.cpa_exam_section_attempt_number' END AS cpa_exam_section_attempt_number,
    CASE WHEN LOWER(TRIM(json_data->>'$.properties.cpa_exam_sections_passed')) IN ('','null','n/a','^n/a^','^null^') THEN NULL ELSE json_data->>'$.properties.cpa_exam_sections_passed' END AS cpa_exam_sections_passed,
    CASE WHEN json_data->>'$.properties.cpe_spend_current_year' REGEXP '^[0-9]+(\\.[0-9]+)?$' THEN CAST(json_data->>'$.properties.cpe_spend_current_year' AS DECIMAL(19,2)) ELSE NULL END AS cpe_spend_current_year,
    CASE WHEN json_data->>'$.properties.cpe_spend_previous_fy' REGEXP '^[0-9]+(\\.[0-9]+)?$' THEN CAST(json_data->>'$.properties.cpe_spend_previous_fy' AS DECIMAL(19,2)) ELSE NULL END AS cpe_spend_previous_fy,
    CASE
      WHEN json_data->>'$.properties.createdate' REGEXP '^[0-9]{4}-[0-9]{2}-[0-9]{2}T[0-9]{2}:[0-9]{2}:[0-9]{2}'
        THEN STR_TO_DATE(LEFT(REPLACE(json_data->>'$.properties.createdate','Z',''),19), '%Y-%m-%dT%H:%i:%s')
      ELSE NULL
    END AS properties_created_date,
    CASE WHEN LOWER(TRIM(json_data->>'$.properties.date_passed_cpa_exam')) IN ('','null','n/a','^n/a^','^null^') THEN NULL ELSE json_data->>'$.properties.date_passed_cpa_exam' END AS date_passed_cpa_exam,
    CASE WHEN LOWER(TRIM(json_data->>'$.properties.email')) IN ('','null','n/a','^n/a^','^null^') THEN NULL ELSE json_data->>'$.properties.email' END AS email,
    CASE WHEN LOWER(TRIM(json_data->>'$.properties.fields_of_interest')) IN ('','null','n/a','^n/a^','^null^') THEN NULL ELSE REPLACE(json_data->>'$.properties.fields_of_interest',';',', ') END AS fields_of_interest,
    CASE WHEN LOWER(TRIM(json_data->>'$.properties.first_conversion_date')) IN ('','null','n/a','^n/a^','^null^') THEN NULL ELSE json_data->>'$.properties.first_conversion_date' END AS first_conversion_date,
    CASE WHEN LOWER(TRIM(json_data->>'$.properties.firstname')) IN ('','null','n/a','^n/a^','^null^') THEN NULL ELSE json_data->>'$.properties.firstname' END AS firstname,
    CASE WHEN json_data->>'$.properties.hs_analytics_num_event_completions' REGEXP '^-?[0-9]+' THEN CAST(json_data->>'$.properties.hs_analytics_num_event_completions' AS UNSIGNED) ELSE NULL END AS hs_analytics_num_event_completions,
    CASE WHEN json_data->>'$.properties.hs_analytics_num_page_views' REGEXP '^-?[0-9]+' THEN CAST(json_data->>'$.properties.hs_analytics_num_page_views' AS UNSIGNED) ELSE NULL END AS hs_analytics_num_page_views,
    CASE WHEN json_data->>'$.properties.hs_analytics_num_visits' REGEXP '^-?[0-9]+' THEN CAST(json_data->>'$.properties.hs_analytics_num_visits' AS UNSIGNED) ELSE NULL END AS hs_analytics_num_visits,
    CASE WHEN LOWER(TRIM(json_data->>'$.properties.hs_email_click')) IN ('','null','n/a','^n/a^','^null^') THEN NULL ELSE json_data->>'$.properties.hs_email_click' END AS hs_email_click,
    CASE WHEN json_data->>'$.properties.hs_email_delivered' REGEXP '^-?[0-9]+' THEN CAST(json_data->>'$.properties.hs_email_delivered' AS UNSIGNED) ELSE NULL END AS hs_email_delivered,
    CASE WHEN LOWER(TRIM(json_data->>'$.properties.hs_email_last_click_date')) IN ('','null','n/a','^n/a^','^null^') THEN NULL ELSE json_data->>'$.properties.hs_email_last_click_date' END AS hs_email_last_click_date,
    CASE WHEN LOWER(TRIM(json_data->>'$.properties.hs_email_last_email_name')) IN ('','null','n/a','^n/a^','^null^') THEN NULL ELSE json_data->>'$.properties.hs_email_last_email_name' END AS hs_email_last_email_name,
    CASE WHEN json_data->>'$.properties.hs_email_open' REGEXP '^-?[0-9]+' THEN CAST(json_data->>'$.properties.hs_email_open' AS UNSIGNED) ELSE NULL END AS hs_email_open,
    CASE WHEN LOWER(TRIM(json_data->>'$.properties.hs_email_replied')) IN ('','null','n/a','^n/a^','^null^') THEN NULL ELSE json_data->>'$.properties.hs_email_replied' END AS hs_email_replied,
    CASE WHEN json_data->>'$.properties.hs_email_sends_since_last_engagement' REGEXP '^-?[0-9]+' THEN CAST(json_data->>'$.properties.hs_email_sends_since_last_engagement' AS UNSIGNED) ELSE NULL END AS hs_email_sends_since_last_engagement,
    CASE WHEN LOWER(TRIM(json_data->>'$.properties.hs_email_type')) IN ('','null','n/a','^n/a^','^null^') THEN NULL ELSE json_data->>'$.properties.hs_email_type' END AS hs_email_type,
    CASE WHEN LOWER(TRIM(json_data->>'$.properties.hs_emailconfirmationstatus')) IN ('','null','n/a','^n/a^','^null^') THEN NULL ELSE json_data->>'$.properties.hs_emailconfirmationstatus' END AS hs_email_confirmation_status,
    CASE WHEN json_data->>'$.properties.hs_last_sales_activity_timestamp' REGEXP '^[0-9]{4}-[0-9]{2}-[0-9]{2}T[0-9]{2}:[0-9]{2}:[0-9]{2}' THEN STR_TO_DATE(LEFT(REPLACE(json_data->>'$.properties.hs_last_sales_activity_timestamp','Z',''),19), '%Y-%m-%dT%H:%i:%s') ELSE NULL END AS hs_last_sales_activity_timestamp,
    CASE WHEN LOWER(TRIM(json_data->>'$.properties.hs_lead_status')) IN ('','null','n/a','^n/a^','^null^') THEN NULL ELSE json_data->>'$.properties.hs_lead_status' END AS hs_lead_status,
    CASE WHEN json_data->>'$.properties.hs_object_id' REGEXP '^[0-9]+$' THEN CAST(json_data->>'$.properties.hs_object_id' AS UNSIGNED) ELSE NULL END AS hs_object_id,
    CASE WHEN LOWER(TRIM(json_data->>'$.properties.hs_sales_email_last_clicked')) IN ('','null','n/a','^n/a^','^null^') THEN NULL ELSE json_data->>'$.properties.hs_sales_email_last_clicked' END AS hs_sales_email_last_clicked,
    CASE WHEN LOWER(TRIM(json_data->>'$.properties.hs_sales_email_last_opened')) IN ('','null','n/a','^n/a^','^null^') THEN NULL ELSE json_data->>'$.properties.hs_sales_email_last_opened' END AS hs_sales_email_last_opened,
    CASE WHEN LOWER(TRIM(json_data->>'$.properties.hs_sales_email_last_replied')) IN ('','null','n/a','^n/a^','^null^') THEN NULL ELSE json_data->>'$.properties.hs_sales_email_last_replied' END AS hs_sales_email_last_replied,
    CASE WHEN LOWER(TRIM(json_data->>'$.properties.hubspotscore')) IN ('','null','n/a','^n/a^','^null^') THEN NULL ELSE json_data->>'$.properties.hubspotscore' END AS hubspot_score,
    CASE
      WHEN json_data->>'$.properties.lastmodifieddate' REGEXP '^[0-9]{4}-[0-9]{2}-[0-9]{2}T[0-9]{2}:[0-9]{2}:[0-9]{2}'
        THEN STR_TO_DATE(LEFT(REPLACE(json_data->>'$.properties.lastmodifieddate','Z',''),19), '%Y-%m-%dT%H:%i:%s')
      ELSE NULL
    END AS properties_last_modified_date,
    CASE WHEN LOWER(TRIM(json_data->>'$.properties.lastname')) IN ('','null','n/a','^n/a^','^null^') THEN NULL ELSE json_data->>'$.properties.lastname' END AS lastname,
    CASE WHEN LOWER(TRIM(json_data->>'$.properties.notes_last_contacted')) IN ('','null','n/a','^n/a^','^null^') THEN NULL ELSE json_data->>'$.properties.notes_last_contacted' END AS notes_last_contacted,
    CASE WHEN LOWER(TRIM(json_data->>'$.properties.notes_last_updated')) IN ('','null','n/a','^n/a^','^null^') THEN NULL ELSE json_data->>'$.properties.notes_last_updated' END AS notes_last_updated,
    CASE
      WHEN json_data->>'$.createdAt' REGEXP '^[0-9]{4}-[0-9]{2}-[0-9]{2}T[0-9]{2}:[0-9]{2}:[0-9]{2}'
        THEN STR_TO_DATE(LEFT(REPLACE(json_data->>'$.createdAt','Z',''),19), '%Y-%m-%dT%H:%i:%s')
      ELSE NULL
    END AS created_at,
    CASE
      WHEN json_data->>'$.updatedAt' REGEXP '^[0-9]{4}-[0-9]{2}-[0-9]{2}T[0-9]{2}:[0-9]{2}:[0-9]{2}'
        THEN STR_TO_DATE(LEFT(REPLACE(json_data->>'$.updatedAt','Z',''),19), '%Y-%m-%dT%H:%i:%s')
      ELSE NULL
    END AS updated_at,
    CASE WHEN LOWER(json_data->>'$.archived') IN ('1','true') THEN 1 WHEN LOWER(json_data->>'$.archived') IN ('0','false') THEN 0 ELSE NULL END AS archived,
    CASE WHEN LOWER(TRIM(json_data->>'$.url')) IN ('','null','n/a','^n/a^','^null^') THEN NULL ELSE json_data->>'$.url' END AS hubspot_url,
    source_file,
    CURRENT_TIMESTAMP AS load_ts
  FROM wscpa_hubspot.staging_contacts
  ) AS src
  ON DUPLICATE KEY UPDATE
    am_net_id = src.am_net_id,
    amnet_last_sync = src.amnet_last_sync,
    company_size = src.company_size,
    cpa_exam_begin_date = src.cpa_exam_begin_date,
    cpa_exam_last_section_pass_date = src.cpa_exam_last_section_pass_date,
    cpa_exam_review_course_purchase_date = src.cpa_exam_review_course_purchase_date,
    cpa_exam_section_attempt_number = src.cpa_exam_section_attempt_number,
    cpa_exam_sections_passed = src.cpa_exam_sections_passed,
    cpe_spend_current_year = src.cpe_spend_current_year,
    cpe_spend_previous_fy = src.cpe_spend_previous_fy,
    properties_created_date = src.properties_created_date,
    date_passed_cpa_exam = src.date_passed_cpa_exam,
    email = src.email,
    fields_of_interest = src.fields_of_interest,
    first_conversion_date = src.first_conversion_date,
    firstname = src.firstname,
    hs_analytics_num_event_completions = src.hs_analytics_num_event_completions,
    hs_analytics_num_page_views = src.hs_analytics_num_page_views,
    hs_analytics_num_visits = src.hs_analytics_num_visits,
    hs_email_click = src.hs_email_click,
    hs_email_delivered = src.hs_email_delivered,
    hs_email_last_click_date = src.hs_email_last_click_date,
    hs_email_last_email_name = src.hs_email_last_email_name,
    hs_email_open = src.hs_email_open,
    hs_email_replied = src.hs_email_replied,
    hs_email_sends_since_last_engagement = src.hs_email_sends_since_last_engagement,
    hs_email_type = src.hs_email_type,
    hs_email_confirmation_status = src.hs_email_confirmation_status,
    hs_last_sales_activity_timestamp = src.hs_last_sales_activity_timestamp,
    hs_lead_status = src.hs_lead_status,
    hs_object_id = src.hs_object_id,
    hs_sales_email_last_clicked = src.hs_sales_email_last_clicked,
    hs_sales_email_last_opened = src.hs_sales_email_last_opened,
    hs_sales_email_last_replied = src.hs_sales_email_last_replied,
    hubspot_score = src.hubspot_score,
    properties_last_modified_date = src.properties_last_modified_date,
    lastname = src.lastname,
    notes_last_contacted = src.notes_last_contacted,
    notes_last_updated = src.notes_last_updated,
    created_at = src.created_at,
    updated_at = src.updated_at,
    archived = src.archived,
    hubspot_url = src.hubspot_url,
    source_file = src.source_file,
    load_ts = src.load_ts;
