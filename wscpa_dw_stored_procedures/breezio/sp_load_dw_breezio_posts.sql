DROP PROCEDURE IF EXISTS wscpa_dw.sp_load_dw_breezio_posts;

DELIMITER $$

CREATE PROCEDURE wscpa_dw.sp_load_dw_breezio_posts()
BEGIN

    DELETE FROM wscpa_dw.dw_breezio_posts;

    INSERT INTO wscpa_dw.dw_breezio_posts
    (
        id,
        user_id,
        root_folder_id,
        title,
        slug,
        subtitle,
        post_type,
        format,
        content_json,
        creation_date,
        modified_date,
        publish_date,
        last_activity_date,
        last_conference_date,
        status,
        is_deleted,
        is_featured,
        is_org_featured,
        hide_comments,
        version,
        source_id,
        source_json,
        score,
        view_count,
        is_private,
        organization_id,
        notes_count,
        metadata_json,
        vote_score,
        poster_id,
        portal_id,
        external_id,
        image_path,
        info_json,
        only_path_accessible,
        unique_view_count,
        price,
        purchase_count,
        post_hash,
        comments_mode,
        entity_type,
        entity_name,
        tags_connected_json,
        user_json,
        purchased_item,
        organization_json,
        display_date,
        date_type
    )
    SELECT
        CAST(NULLIF(json_data->>'$.id', '') AS UNSIGNED),
        CAST(NULLIF(json_data->>'$.userId', '') AS UNSIGNED),
        NULLIF(json_data->>'$.rootFolderId', ''),

        NULLIF(json_data->>'$.title', ''),
        NULLIF(json_data->>'$.slug', ''),
        NULLIF(json_data->>'$.subtitle', ''),
        NULLIF(json_data->>'$.postType', ''),
        NULLIF(json_data->>'$.format', ''),

        JSON_EXTRACT(json_data, '$.content'),

        STR_TO_DATE(
            LEFT(NULLIF(json_data->>'$.creationDate', ''), 19),
            '%Y-%m-%dT%H:%i:%s'
        ),

        STR_TO_DATE(
            LEFT(NULLIF(json_data->>'$.modifiedDate', ''), 19),
            '%Y-%m-%dT%H:%i:%s'
        ),

        STR_TO_DATE(
            LEFT(NULLIF(json_data->>'$.publishDate', ''), 19),
            '%Y-%m-%dT%H:%i:%s'
        ),

        STR_TO_DATE(
            LEFT(NULLIF(json_data->>'$.lastActivityDate', ''), 19),
            '%Y-%m-%dT%H:%i:%s'
        ),

        STR_TO_DATE(
            LEFT(NULLIF(json_data->>'$.lastConferenceDate', ''), 19),
            '%Y-%m-%dT%H:%i:%s'
        ),

        NULLIF(json_data->>'$.status', ''),

        CASE
            WHEN json_data->>'$.deleted' = 'true' THEN 1
            WHEN json_data->>'$.deleted' = 'false' THEN 0
            ELSE NULL
        END,

        CAST(NULLIF(json_data->>'$.featured', '') AS UNSIGNED),
        CAST(NULLIF(json_data->>'$.orgFeatured', '') AS UNSIGNED),
        CAST(NULLIF(json_data->>'$.hideComments', '') AS UNSIGNED),
        CAST(NULLIF(json_data->>'$.version', '') AS UNSIGNED),

        NULLIF(json_data->>'$.sourceId', ''),
        JSON_EXTRACT(json_data, '$.source'),

        CAST(NULLIF(json_data->>'$.score', '') AS SIGNED),
        CAST(NULLIF(json_data->>'$.viewCount', '') AS UNSIGNED),

        CASE
            WHEN json_data->>'$.private' = 'true' THEN 1
            WHEN json_data->>'$.private' = 'false' THEN 0
            ELSE NULL
        END,

        CAST(NULLIF(json_data->>'$.organizationId', '') AS UNSIGNED),
        CAST(NULLIF(json_data->>'$.notesCount', '') AS UNSIGNED),

        JSON_EXTRACT(json_data, '$.metadata'),

        CAST(NULLIF(json_data->>'$.voteScore', '') AS SIGNED),
        CAST(NULLIF(json_data->>'$.posterId', '') AS UNSIGNED),
        CAST(NULLIF(json_data->>'$.portalId', '') AS UNSIGNED),

        NULLIF(json_data->>'$.externalId', ''),
        NULLIF(json_data->>'$.imagePath', ''),

        JSON_EXTRACT(json_data, '$.info'),

        CAST(NULLIF(json_data->>'$.onlyPathAccessible', '') AS UNSIGNED),
        CAST(NULLIF(json_data->>'$.uniqueViewCount', '') AS UNSIGNED),

        CAST(NULLIF(json_data->>'$.price', '') AS DECIMAL(18,2)),
        CAST(NULLIF(json_data->>'$.purchaseCount', '') AS UNSIGNED),

        NULLIF(json_data->>'$.postHash', ''),
        NULLIF(json_data->>'$.commentsMode', ''),

        json_data->>'$.type',
        json_data->>'$._entityName',

        JSON_EXTRACT(json_data, '$.tagsConnected'),
        JSON_EXTRACT(json_data, '$.user'),

        CASE
            WHEN json_data->>'$.purchasedItem' = 'true' THEN 1
            WHEN json_data->>'$.purchasedItem' = 'false' THEN 0
            ELSE NULL
        END,

        JSON_EXTRACT(json_data, '$.organization'),

        NULLIF(json_data->>'$._displayDate', ''),
        NULLIF(json_data->>'$._dateType', '')

    FROM wscpa_breezio.staging_posts;

END$$

DELIMITER ;
