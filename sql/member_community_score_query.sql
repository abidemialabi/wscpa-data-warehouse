-- Member community score query
-- Base logic for a future dw_member_community_scores table.
-- Each member should only receive one 10-point score for post activity and
-- one separate 10-point score for Hill Day, regardless of how many qualifying events/posts they have.

WITH
    recent_post_metrics AS (
        SELECT
            p.user_id,
            COUNT(*) AS post_count,
            SUM(COALESCE(p.view_count, 0)) AS post_views,
            SUM(COALESCE(p.notes_count, 0)) AS post_comments,
            SUM(COALESCE(p.vote_score, 0)) AS post_votes,
            SUM(
                COALESCE(p.followers_count, 0)
            ) AS post_followers
        FROM wscpa_dw.dw_breezio_posts p
        WHERE
            p.creation_date >= DATE_SUB(CURDATE(), INTERVAL 12 MONTH)
            AND p.creation_date <= NOW()
            AND COALESCE(p.is_deleted, 0) = 0
        GROUP BY
            p.user_id
    ),
    individuals_base as (
        SELECT DISTINCT
            individuals_key,
            individual_id,
            email_address
        FROM wscpa_amnet.staging_individuals
    ),
    member_breezio_map AS (
        SELECT DISTINCT
            si.individual_id,
            bu.id AS breezio_user_id,
            bu.posts_count,
            bu.view_count AS user_post_views,
            bu.comments_count AS user_post_comments,
            bu.votes_count AS user_post_votes,
            bu.followers_count AS user_post_followers
        FROM individuals_base si
            LEFT JOIN wscpa_dw.dw_breezio_users bu ON si.individual_id = bu.external_id
    ),
    member_community_base AS (
        SELECT
            m.individual_id,
            COALESCE(rpm.post_count, 0) AS post_count_total,
            COALESCE(rpm.post_views, 0) AS post_views_total,
            COALESCE(m.user_post_comments, 0) AS post_comments_total,
            COALESCE(rpm.post_votes, 0) AS post_votes_total,
            COALESCE(m.user_post_followers, 0) AS post_followers_total,
            CASE
                WHEN (
                    COALESCE(rpm.post_count, 0) + COALESCE(rpm.post_views, 0) + COALESCE(m.user_post_comments, 0) + COALESCE(rpm.post_votes, 0) + COALESCE(rpm.post_followers, 0) + COALESCE(m.user_post_followers, 0)
                ) > 0 THEN 10
                ELSE 0
            END AS community_score,
            'post_count' AS community_type
        FROM
            member_breezio_map m
            LEFT JOIN recent_post_metrics rpm ON rpm.user_id = m.breezio_user_id
    ),
    member_hill_day AS (
        SELECT
            me.individuals_key,
            me.individual_id,
            NULL AS email,
            0 AS post_count_total,
            0 AS post_views_total,
            0 AS post_comments_total,
            0 AS post_votes_total,
            0 AS post_followers_total,
            COUNT(*) * 2.5 AS community_score,
            'hill_day' AS community_type
        FROM wscpa_dw.dw_member_events me
        WHERE
            me.event_division = 'Special Events'
            AND me.event_begin_date >= DATE_SUB(CURDATE(), INTERVAL 12 MONTH)
            AND me.event_begin_date <= CURDATE()
        GROUP BY
            me.individuals_key,
            me.individual_id
    ),
    non_cpe_event_points_map AS (
        SELECT
            'Networking Event' AS event_division,
            'Networking or social event' AS community_type,
            2.5 AS points
        UNION ALL
        SELECT 'Conference (Group Live)', 'In-person conference', 2.5
        UNION ALL
        SELECT 'Committees', 'Non CPE event', 2.5
    ),
    member_non_cpe_events AS (
        SELECT
            me.individuals_key,
            me.individual_id,
            NULL AS email,
            0 AS post_count_total,
            0 AS post_views_total,
            0 AS post_comments_total,
            0 AS post_votes_total,
            0 AS post_followers_total,
            COUNT(*) * MAX(COALESCE(map.points, 0)) AS community_score,
            COALESCE(
                map.community_type,
                'Unmapped'
            ) AS community_type
        FROM
            wscpa_dw.dw_member_events me
            LEFT JOIN non_cpe_event_points_map map ON TRIM(me.event_division) = TRIM(map.event_division)
        WHERE
            LOWER(me.event_name) NOT LIKE '%cohort%'
            AND me.event_begin_date >= DATE_SUB(CURDATE(), INTERVAL 12 MONTH)
            AND me.event_begin_date <= CURDATE()
            AND map.event_division IS NOT NULL
        GROUP BY
            me.individuals_key,
            me.individual_id,
            COALESCE(
                map.community_type,
                'Unmapped'
            ),
            map.points
    )
SELECT
    individual_id,
    community_type,
    community_score,
    post_count_total,
    post_views_total,
    post_comments_total,
    post_votes_total,
    post_followers_total
FROM member_community_base
WHERE
    community_score > 0
UNION ALL
SELECT
    individual_id,
    community_type,
    community_score,
    post_count_total,
    post_views_total,
    post_comments_total,
    post_votes_total,
    post_followers_total
FROM member_hill_day
WHERE
    community_score > 0
UNION ALL
SELECT
    individual_id,
    community_type,
    community_score,
    post_count_total,
    post_views_total,
    post_comments_total,
    post_votes_total,
    post_followers_total
FROM member_non_cpe_events
WHERE
    community_score > 0
ORDER BY individual_id, community_type;