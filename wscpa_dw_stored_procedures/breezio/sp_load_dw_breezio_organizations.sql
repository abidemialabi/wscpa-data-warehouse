DROP PROCEDURE IF EXISTS wscpa_dw.sp_load_dw_breezio_organizations;

DELIMITER $$

CREATE PROCEDURE wscpa_dw.sp_load_dw_breezio_organizations()
BEGIN

    DELETE FROM wscpa_dw.dw_breezio_organizations;

    INSERT INTO wscpa_dw.dw_breezio_organizations
    (
        id,
        user_id,
        name,
        category,
        region,
        bio,
        billing_email,
        website,
        image_path,
        background_image_path,
        slug,
        foo,
        view_count,
        creation_date,
        modified_date,
        is_featured,
        is_deleted,
        portal_id,
        root_folder_id,
        is_private,
        external_id,
        external_id2,
        latest_posts,
        latest_paths,
        post_force_subscription,
        quick_discussion,
        community_members,
        visibility,
        event_button_visibility,
        video_conference,
        join_rule,
        default_role,
        config_json,
        entity_type,
        entity_name,
        user_json
    )
    SELECT
        CAST(NULLIF(json_data->>'$.id', '') AS UNSIGNED),
        CAST(NULLIF(json_data->>'$.userId', '') AS UNSIGNED),

        NULLIF(json_data->>'$.name', ''),
        NULLIF(json_data->>'$.category', ''),
        NULLIF(json_data->>'$.region', ''),
        NULLIF(json_data->>'$.bio', ''),
        NULLIF(json_data->>'$.billingEmail', ''),
        NULLIF(json_data->>'$.website', ''),
        NULLIF(json_data->>'$.imagePath', ''),
        NULLIF(json_data->>'$.backgroundimagePath', ''),
        NULLIF(json_data->>'$.slug', ''),

        CAST(NULLIF(json_data->>'$.foo', '') AS SIGNED),
        CAST(NULLIF(json_data->>'$.viewCount', '') AS UNSIGNED),

        STR_TO_DATE(
            LEFT(NULLIF(json_data->>'$.creationDate', ''), 19),
            '%Y-%m-%dT%H:%i:%s'
        ),

        STR_TO_DATE(
            LEFT(NULLIF(json_data->>'$.modifiedDate', ''), 19),
            '%Y-%m-%dT%H:%i:%s'
        ),

        CAST(NULLIF(json_data->>'$.featured', '') AS UNSIGNED),

        CASE
            WHEN json_data->>'$.deleted' = 'true' THEN 1
            WHEN json_data->>'$.deleted' = 'false' THEN 0
            ELSE NULL
        END,

        CAST(NULLIF(json_data->>'$.portalId', '') AS UNSIGNED),

        NULLIF(json_data->>'$.rootFolderId', ''),

        CAST(NULLIF(json_data->>'$.private', '') AS UNSIGNED),

        NULLIF(json_data->>'$.externalId', ''),
        NULLIF(json_data->>'$.externalId2', ''),

        CAST(NULLIF(json_data->>'$.latestPosts', '') AS UNSIGNED),
        CAST(NULLIF(json_data->>'$.latestPaths', '') AS UNSIGNED),

        CASE
            WHEN json_data->>'$.postForceSubscription' = 'true' THEN 1
            WHEN json_data->>'$.postForceSubscription' = 'false' THEN 0
            ELSE NULL
        END,

        CASE
            WHEN json_data->>'$.quickDiscussion' = 'true' THEN 1
            WHEN json_data->>'$.quickDiscussion' = 'false' THEN 0
            ELSE NULL
        END,

        CASE
            WHEN json_data->>'$.communityMembers' = 'true' THEN 1
            WHEN json_data->>'$.communityMembers' = 'false' THEN 0
            ELSE NULL
        END,

        CASE
            WHEN json_data->>'$.visibility' = 'true' THEN 1
            WHEN json_data->>'$.visibility' = 'false' THEN 0
            ELSE NULL
        END,

        CASE
            WHEN json_data->>'$.eventbuttonvisibility' = 'true' THEN 1
            WHEN json_data->>'$.eventbuttonvisibility' = 'false' THEN 0
            ELSE NULL
        END,

        CASE
            WHEN json_data->>'$.videoConference' = 'true' THEN 1
            WHEN json_data->>'$.videoConference' = 'false' THEN 0
            ELSE NULL
        END,

        NULLIF(json_data->>'$.joinRule', ''),
        NULLIF(json_data->>'$.defaultRole', ''),

        JSON_EXTRACT(json_data, '$.config'),

        json_data->>'$.type',
        json_data->>'$._entityName',

        JSON_EXTRACT(json_data, '$.user')

    FROM wscpa_breezio.staging_organizations;

END$$

DELIMITER ;
