-- Extract HubSpot staging_contacts JSON into columns
-- Saves sourcefile and load_ts, converts common ISO dates and numeric fields

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
  CASE WHEN json_data->>'$.properties.cpe_spend_current_year' REGEXP '^[0-9]+(\.[0-9]+)?$' THEN CAST(json_data->>'$.properties.cpe_spend_current_year' AS DECIMAL(19,2)) ELSE NULL END AS cpe_spend_current_year,
  CASE WHEN json_data->>'$.properties.cpe_spend_previous_fy' REGEXP '^[0-9]+(\.[0-9]+)?$' THEN CAST(json_data->>'$.properties.cpe_spend_previous_fy' AS DECIMAL(19,2)) ELSE NULL END AS cpe_spend_previous_fy,
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
  load_ts
FROM wscpa_hubspot.staging_contacts;
