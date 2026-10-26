CREATE OR REPLACE VIEW wscpa_dw.vw_member_activities AS

SELECT
    me.individual_id,
    'Attended Event' AS activity_type,
    me.event_name AS activity_title,
    CASE
        WHEN rs.registration_status = 'Registered'
             AND me.completion_date IS NOT NULL
        THEN 'Registered - Completed'
        ELSE rs.registration_status
    END AS activity_subtype,
    me.event_begin_date AS activity_date
FROM wscpa_dw.dw_member_events me
INNER JOIN wscpa_amnet.staging_registration_statuses rs
    ON me.registration_statuses_key = rs.registration_statuses_key
WHERE me.individual_id IS NOT NULL
  AND me.event_name IS NOT NULL
  AND me.event_begin_date >= DATE_SUB(CURDATE(), INTERVAL 12 MONTH)
  AND me.event_begin_date <= CURDATE()
  AND COALESCE(me.event_status, '') <> 'Cancelled'
  AND (
      rs.registration_status IN (
          'Arrived Late',
          'Left Early',
          'Arrived Late, Left Early',
          'Attended First Day Only',
          'Attended Second Day Only',
          'No Sign Out'
      )
      OR (
          rs.registration_status = 'Registered'
          AND me.completion_date IS NOT NULL
      )
  )

UNION ALL

SELECT
    p.user_external_id AS individual_id,
    'Community' AS activity_type,
    p.title AS activity_title,
    p.post_type AS activity_subtype,
    p.creation_date AS activity_date
FROM wscpa_dw.dw_breezio_posts p
WHERE p.user_external_id IS NOT NULL
  AND p.creation_date >= DATE_SUB(CURDATE(), INTERVAL 12 MONTH)
  AND p.creation_date <= NOW()
  AND COALESCE(p.is_deleted, 0) = 0

UNION ALL

SELECT
    mc.individual_id,
    'Leadership' AS activity_type,
    CONCAT('Serves on ', mc.committee_name) AS activity_title,
    COALESCE(mc.committee_position, 'N/A') AS activity_subtype,
    MAX(mc.begin_date) AS activity_date
FROM wscpa_dw.dw_member_committees mc
WHERE mc.individual_id IS NOT NULL
  AND mc.committee_name IS NOT NULL
  AND mc.committee_status = 'Active'
  AND mc.begin_date >= DATE_SUB(CURDATE(), INTERVAL 12 MONTH)
  AND mc.begin_date <= CURDATE()
  AND (
      mc.end_date IS NULL
      OR mc.end_date >= CURDATE()
  )
GROUP BY
    mc.individual_id,
    mc.committee_name,
    COALESCE(mc.committee_position, 'N/A')

UNION ALL

SELECT
    me.individual_id,
    'Education' AS activity_type,
    CONCAT('Completed CPE: ', me.event_name) AS activity_title,
    me.event_division AS activity_subtype,
    me.completion_date AS activity_date
FROM wscpa_dw.dw_member_events me
WHERE me.individual_id IS NOT NULL
  AND me.event_name IS NOT NULL
  AND me.completion_date IS NOT NULL
  AND me.completion_date >= DATE_SUB(CURDATE(), INTERVAL 12 MONTH)
  AND me.completion_date <= CURDATE()
  AND COALESCE(me.event_status, '') <> 'Cancelled'
  AND TRIM(me.event_division) IN (
      'Webcast (Group Internet Based)',
      'Conference (Group Internet Based)',
      'Webinar (Group Internet Based)',
      'Seminar (Group Live)',
      'In-House Training',
      'Chapter Event (Group Live)',
      'Self Study',
      'Resource Group (Group Internet)',
      'Committees (Group Internet)',
      'Flexcast'
  );
