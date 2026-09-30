WITH event_division_points_map AS (
    SELECT 'Webcast (Group Internet Based)' AS event_division, 'CPE Learning event' AS event_type_category, 2.5 AS points
    UNION ALL SELECT 'Conference (Group Internet Based)', 'CPE Learning event', 2.5
    UNION ALL SELECT 'Webinar (Group Internet Based)', 'CPE Learning event', 2.5
    UNION ALL SELECT 'Seminar (Group Live)', 'CPE Learning event', 2.5
    UNION ALL SELECT 'Networking Event', 'Networking or social event', 10
    UNION ALL SELECT 'In-House Training', 'CPE Learning event', 2.5
    UNION ALL SELECT 'Chapter Event (Group Live)', 'CPE Learning event', 2.5
    UNION ALL SELECT 'Conference (Group Live)', 'In-person conference', 10
    UNION ALL SELECT 'Self Study', 'CPE Learning event', 2.5
    UNION ALL SELECT 'Resource Group (Group Internet)', 'CPE Learning event', 2.5
    UNION ALL SELECT 'Committees (Group Internet)', 'CPE Learning event', 2.5
    UNION ALL SELECT 'Flexcast', 'CPE Learning event', 2.5
    UNION ALL SELECT 'Committees', 'Non CPE event.', 2.5
),
member_event_category_scores AS (
    SELECT
        me.individuals_key,
        me.individual_id,
        CASE
            WHEN LOWER(me.event_name) LIKE '%cohort%' THEN 'Cohort event'
            WHEN map.event_type_category IS NOT NULL THEN map.event_type_category
            ELSE 'Unmapped'
        END AS event_type_category,
        CASE
            WHEN LOWER(me.event_name) LIKE '%cohort%' THEN 10
            ELSE COALESCE(map.points, 0)
        END AS member_education_score
    FROM wscpa_dw.dw_member_events me
    LEFT JOIN event_division_points_map map
        ON TRIM(me.event_division) = TRIM(map.event_division)
    WHERE
        me.event_begin_date >= DATE_SUB(CURDATE(), INTERVAL 12 MONTH)
        AND me.event_begin_date <= CURDATE()
)
SELECT
    individuals_key,
    individual_id,
    event_type_category,
    MAX(member_education_score) AS member_education_score
FROM member_event_category_scores
GROUP BY
    individuals_key,
    individual_id,
    event_type_category
ORDER BY
    individual_id,
    event_type_category;
