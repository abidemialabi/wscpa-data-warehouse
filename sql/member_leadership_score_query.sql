-- Member leadership score query
-- This query assigns leadership points based on committee service,
-- event leadership, and recent contribution activity over the rolling 12-month window.
-- Each metric is scored once per member, even if the member qualifies multiple times.

WITH committee_score_base AS (
    SELECT
        mc.individuals_key,
        mc.individual_id,
        mc.committee_type,
        mc.committee_position,
        mc.begin_date,
        CASE
            WHEN LOWER(TRIM(mc.committee_type)) = 'board of directors' THEN 100
            WHEN LOWER(TRIM(mc.committee_position)) IN (
                'co-chair',
                'chair',
                'event committee chair',
                'advocacy committee chair',
                'outreach committee chair',
                'vice chair'
            ) THEN 75
            WHEN mc.committee_position IS NOT NULL THEN 10
            ELSE 0
        END AS committee_score,
        CASE
            WHEN LOWER(TRIM(mc.committee_type)) = 'board of directors' THEN 'board_of_directors'
            WHEN LOWER(TRIM(mc.committee_position)) IN (
                'co-chair',
                'chair',
                'event committee chair',
                'advocacy committee chair',
                'outreach committee chair',
                'vice chair'
            ) THEN 'committee_leadership'
            WHEN mc.committee_position IS NOT NULL THEN 'committee_service'
            ELSE NULL
        END AS leadership_metric
    FROM wscpa_dw.dw_member_committees mc
    WHERE mc.begin_date >= DATE_SUB(CURDATE(), INTERVAL 12 MONTH)
      AND mc.begin_date <= CURDATE()
),
committee_metric_scores AS (
    SELECT
        individual_id,
        leadership_metric,
        MAX(committee_score) AS leadership_score
    FROM committee_score_base
    WHERE leadership_metric IS NOT NULL
    GROUP BY individual_id, leadership_metric
),
event_leader_score AS (
    SELECT DISTINCT
        me.individual_id,
        'event_leadership' AS leadership_metric,
        10 AS leadership_score
    FROM wscpa_amnet.staging_event_leaders sel
    INNER JOIN wscpa_dw.dw_member_events me
        ON sel.events_key = me.events_key
       AND LOWER(TRIM(sel.leader_id)) = LOWER(TRIM(me.individual_id))
    WHERE me.event_begin_date >= DATE_SUB(CURDATE(), INTERVAL 12 MONTH)
      AND me.event_begin_date <= CURDATE()
),
member_contribution_score AS (
    SELECT
        ms.individual_id,
        'member_contribution' AS leadership_metric,
        10 AS leadership_score
    FROM wscpa_dw.dw_member_summary ms
    WHERE COALESCE(ms.total_contribution_amount, 0) > 0
      AND (
            NULLIF(TRIM(ms.last_contribution_date), '') IS NULL
            OR (
                CASE
                    WHEN REGEXP_LIKE(TRIM(ms.last_contribution_date), '^[0-9]{4}-[0-9]{2}-[0-9]{2}$') THEN STR_TO_DATE(TRIM(ms.last_contribution_date), '%Y-%m-%d')
                    WHEN REGEXP_LIKE(TRIM(ms.last_contribution_date), '^[0-9]{1,2}/[0-9]{1,2}/[0-9]{4}$') THEN STR_TO_DATE(TRIM(ms.last_contribution_date), '%m/%d/%Y')
                    ELSE NULL
                END
            ) >= DATE_SUB(CURDATE(), INTERVAL 12 MONTH)
      )
),
final_scores AS (
    SELECT
        individual_id,
        leadership_metric,
        leadership_score
    FROM committee_metric_scores

    UNION ALL

    SELECT
        individual_id,
        leadership_metric,
        leadership_score
    FROM event_leader_score

    UNION ALL

    SELECT
        individual_id,
        leadership_metric,
        leadership_score
    FROM member_contribution_score
)
SELECT
    individual_id,
    leadership_metric,
    leadership_score
FROM final_scores
ORDER BY
    individual_id,
    leadership_metric;
