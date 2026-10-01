WITH event_division_points_map AS (
    SELECT 'Webcast (Group Internet Based)' AS event_division, 'CPE Learning event' AS event_type_category
    UNION ALL SELECT 'Conference (Group Internet Based)', 'CPE Learning event'
    UNION ALL SELECT 'Webinar (Group Internet Based)', 'CPE Learning event'
    UNION ALL SELECT 'Seminar (Group Live)', 'CPE Learning event'
    UNION ALL SELECT 'In-House Training', 'CPE Learning event'
    UNION ALL SELECT 'Chapter Event (Group Live)', 'CPE Learning event'
    UNION ALL SELECT 'Self Study', 'CPE Learning event'
    UNION ALL SELECT 'Resource Group (Group Internet)', 'CPE Learning event'
    UNION ALL SELECT 'Committees (Group Internet)', 'CPE Learning event'
    UNION ALL SELECT 'Flexcast', 'CPE Learning event'
),
member_event_category_scores AS (
    SELECT
        me.individuals_key,
        me.individual_id,
        me.events_key,
        me.event_name,
        me.event_begin_date,
        me.event_division,
        me.credit_hours_earned_at_event,
        CASE
            WHEN map.event_type_category IS NOT NULL THEN map.event_type_category
            ELSE 'Unmapped'
        END AS event_type_category,
        CASE
            WHEN map.event_type_category IS NOT NULL THEN COALESCE(me.credit_hours_earned_at_event, 0) * 2.5
            ELSE 0
        END AS member_education_score
    FROM wscpa_dw.dw_member_events me
    LEFT JOIN event_division_points_map map
        ON TRIM(me.event_division) = TRIM(map.event_division)
    WHERE
        me.event_begin_date >= DATE_SUB(CURDATE(), INTERVAL 12 MONTH)
        AND me.event_begin_date <= CURDATE()
        AND map.event_type_category = 'CPE Learning event'
)
SELECT
    individuals_key,
    individual_id,
    events_key,
    event_name,
    event_begin_date,
    event_division,
    credit_hours_earned_at_event,
    event_type_category,
    member_education_score
FROM member_event_category_scores
ORDER BY
    individual_id,
    event_begin_date,
    events_key;
