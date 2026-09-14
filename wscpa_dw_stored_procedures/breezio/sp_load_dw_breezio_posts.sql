DROP PROCEDURE IF EXISTS wscpa_dw.sp_load_dw_breezio_posts;

DELIMITER $$

CREATE PROCEDURE wscpa_dw.sp_load_dw_breezio_posts()
BEGIN

    DELETE FROM wscpa_dw.dw_breezio_posts;

    INSERT INTO wscpa_dw.dw_breezio_posts
    (
        id,
        user_id,
        user_email,
        user_username,
        user_external_id,
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

        CAST(
            NULLIF(NULLIF(json_data->>'$.id', ''), 'null')
            AS UNSIGNED
        ),

        CAST(
            NULLIF(NULLIF(json_data->>'$.userId', ''), 'null')
            AS UNSIGNED
        ),

        NULLIF(
            NULLIF(json_data->>'$.user.user_email', ''),
            'null'
        ),

        NULLIF(
            NULLIF(json_data->>'$.user.username', ''),
            'null'
        ),

        NULLIF(
            NULLIF(json_data->>'$.user.externalId', ''),
            'null'
        ),

        NULLIF(NULLIF(json_data->>'$.rootFolderId', ''), 'null'),

        NULLIF(NULLIF(json_data->>'$.title', ''), 'null'),
        NULLIF(NULLIF(json_data->>'$.slug', ''), 'null'),
        NULLIF(NULLIF(json_data->>'$.subtitle', ''), 'null'),
        NULLIF(NULLIF(json_data->>'$.postType', ''), 'null'),
        NULLIF(NULLIF(json_data->>'$.format', ''), 'null'),

        JSON_EXTRACT(json_data, '$.content'),

        STR_TO_DATE(
            LEFT(
                NULLIF(NULLIF(json_data->>'$.creationDate', ''), 'null'),
                19
            ),
            '%Y-%m-%dT%H:%i:%s'
        ),

        STR_TO_DATE(
            LEFT(
                NULLIF(NULLIF(json_data->>'$.modifiedDate', ''), 'null'),
                19
            ),
            '%Y-%m-%dT%H:%i:%s'
        ),

        STR_TO_DATE(
            LEFT(
                NULLIF(NULLIF(json_data->>'$.publishDate', ''), 'null'),
                19
            ),
            '%Y-%m-%dT%H:%i:%s'
        ),

        STR_TO_DATE(
            LEFT(
                NULLIF(NULLIF(json_data->>'$.lastActivityDate', ''), 'null'),
                19
            ),
            '%Y-%m-%dT%H:%i:%s'
        ),

        STR_TO_DATE(
            LEFT(
                NULLIF(NULLIF(json_data->>'$.lastConferenceDate', ''), 'null'),
                19
            ),
            '%Y-%m-%dT%H:%i:%s'
        ),

        NULLIF(NULLIF(json_data->>'$.status', ''), 'null'),

        CASE
            WHEN json_data->>'$.deleted' = 'true' THEN 1
            WHEN json_data->>'$.deleted' = 'false' THEN 0
            ELSE NULL
        END,

        CAST(
            NULLIF(NULLIF(json_data->>'$.featured', ''), 'null')
            AS UNSIGNED
        ),

        CAST(
            NULLIF(NULLIF(json_data->>'$.orgFeatured', ''), 'null')
            AS UNSIGNED
        ),

        CAST(
            NULLIF(NULLIF(json_data->>'$.hideComments', ''), 'null')
            AS UNSIGNED
        ),

        CAST(
            NULLIF(NULLIF(json_data->>'$.version', ''), 'null')
            AS UNSIGNED
        ),

        NULLIF(NULLIF(json_data->>'$.sourceId', ''), 'null'),

        JSON_EXTRACT(json_data, '$.source'),

        CAST(
            NULLIF(NULLIF(json_data->>'$.score', ''), 'null')
            AS SIGNED
        ),

        CAST(
            NULLIF(NULLIF(json_data->>'$.viewCount', ''), 'null')
            AS UNSIGNED
        ),

        CASE
            WHEN json_data->>'$.private' = 'true' THEN 1
            WHEN json_data->>'$.private' = 'false' THEN 0
            ELSE NULL
        END,

        CAST(
            NULLIF(NULLIF(json_data->>'$.organizationId', ''), 'null')
            AS UNSIGNED
        ),

        CAST(
            NULLIF(NULLIF(json_data->>'$.notesCount', ''), 'null')
            AS UNSIGNED
        ),

        JSON_EXTRACT(json_data, '$.metadata'),

        CAST(
            NULLIF(NULLIF(json_data->>'$.voteScore', ''), 'null')
            AS SIGNED
        ),

        CAST(
            NULLIF(NULLIF(json_data->>'$.posterId', ''), 'null')
            AS UNSIGNED
        ),

        CAST(
            NULLIF(NULLIF(json_data->>'$.portalId', ''), 'null')
            AS UNSIGNED
        ),

        NULLIF(NULLIF(json_data->>'$.externalId', ''), 'null'),
        NULLIF(NULLIF(json_data->>'$.imagePath', ''), 'null'),

        JSON_EXTRACT(json_data, '$.info'),

        CAST(
            NULLIF(NULLIF(json_data->>'$.onlyPathAccessible', ''), 'null')
            AS UNSIGNED
        ),

        CAST(
            NULLIF(NULLIF(json_data->>'$.uniqueViewCount', ''), 'null')
            AS UNSIGNED
        ),

        CAST(
            NULLIF(NULLIF(json_data->>'$.price', ''), 'null')
            AS DECIMAL(18,2)
        ),

        CAST(
            NULLIF(NULLIF(json_data->>'$.purchaseCount', ''), 'null')
            AS UNSIGNED
        ),

        NULLIF(NULLIF(json_data->>'$.postHash', ''), 'null'),
        NULLIF(NULLIF(json_data->>'$.commentsMode', ''), 'null'),

        NULLIF(json_data->>'$.type', 'null'),
        NULLIF(json_data->>'$._entityName', 'null'),

        JSON_EXTRACT(json_data, '$.tagsConnected'),
        JSON_EXTRACT(json_data, '$.user'),

        CASE
            WHEN json_data->>'$.purchasedItem' = 'true' THEN 1
            WHEN json_data->>'$.purchasedItem' = 'false' THEN 0
            ELSE NULL
        END,

        JSON_EXTRACT(json_data, '$.organization'),

        NULLIF(NULLIF(json_data->>'$._displayDate', ''), 'null'),
        NULLIF(NULLIF(json_data->>'$._dateType', ''), 'null')

    FROM wscpa_breezio.staging_posts;

END$$

DELIMITER ;
