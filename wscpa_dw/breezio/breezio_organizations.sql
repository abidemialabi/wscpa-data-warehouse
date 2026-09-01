SELECT
    CAST(json_data->>'$.id' AS UNSIGNED)                         AS id,
    CAST(json_data->>'$.userId' AS UNSIGNED)                     AS user_id,

    NULLIF(json_data->>'$.name','')                              AS name,
    NULLIF(json_data->>'$.category','')                          AS category,
    NULLIF(json_data->>'$.region','')                            AS region,
    NULLIF(json_data->>'$.bio','')                               AS bio,
    NULLIF(json_data->>'$.billingEmail','')                      AS billing_email,
    NULLIF(json_data->>'$.website','')                           AS website,
    NULLIF(json_data->>'$.imagePath','')                         AS image_path,
    NULLIF(json_data->>'$.backgroundimagePath','')               AS background_image_path,
    NULLIF(json_data->>'$.slug','')                              AS slug,

    CAST(json_data->>'$.foo' AS SIGNED)                          AS foo,
    CAST(json_data->>'$.viewCount' AS UNSIGNED)                  AS view_count,

    STR_TO_DATE(
        json_data->>'$.creationDate',
        '%Y-%m-%dT%H:%i:%s'
    )                                                            AS creation_date,

    STR_TO_DATE(
        json_data->>'$.modifiedDate',
        '%Y-%m-%dT%H:%i:%s'
    )                                                            AS modified_date,

    CAST(json_data->>'$.featured' AS UNSIGNED)                   AS is_featured,

    CASE
        WHEN json_data->>'$.deleted' = 'true' THEN 1
        WHEN json_data->>'$.deleted' = 'false' THEN 0
        ELSE NULL
    END                                                          AS is_deleted,

    CAST(json_data->>'$.portalId' AS UNSIGNED)                   AS portal_id,
    NULLIF(json_data->>'$.rootFolderId','')                      AS root_folder_id,
    CAST(json_data->>'$.private' AS UNSIGNED)                    AS is_private,

    NULLIF(json_data->>'$.externalId','')                        AS external_id,
    NULLIF(json_data->>'$.externalId2','')                       AS external_id2,

    CAST(NULLIF(json_data->>'$.latestPosts','') AS UNSIGNED)     AS latest_posts,
    CAST(NULLIF(json_data->>'$.latestPaths','') AS UNSIGNED)     AS latest_paths,

    CASE
        WHEN json_data->>'$.postForceSubscription' = 'true' THEN 1
        WHEN json_data->>'$.postForceSubscription' = 'false' THEN 0
        ELSE NULL
    END                                                          AS post_force_subscription,

    CASE
        WHEN json_data->>'$.quickDiscussion' = 'true' THEN 1
        WHEN json_data->>'$.quickDiscussion' = 'false' THEN 0
        ELSE NULL
    END                                                          AS quick_discussion,

    CASE
        WHEN json_data->>'$.communityMembers' = 'true' THEN 1
        WHEN json_data->>'$.communityMembers' = 'false' THEN 0
        ELSE NULL
    END                                                          AS community_members,

    CASE
        WHEN json_data->>'$.visibility' = 'true' THEN 1
        WHEN json_data->>'$.visibility' = 'false' THEN 0
        ELSE NULL
    END                                                          AS visibility,

    CASE
        WHEN json_data->>'$.eventbuttonvisibility' = 'true' THEN 1
        WHEN json_data->>'$.eventbuttonvisibility' = 'false' THEN 0
        ELSE NULL
    END                                                          AS event_button_visibility,

    CASE
        WHEN json_data->>'$.videoConference' = 'true' THEN 1
        WHEN json_data->>'$.videoConference' = 'false' THEN 0
        ELSE NULL
    END                                                          AS video_conference,

    NULLIF(json_data->>'$.joinRule','')                          AS join_rule,
    NULLIF(json_data->>'$.defaultRole','')                       AS default_role,

    JSON_EXTRACT(json_data, '$.config')                          AS config_json,

    json_data->>'$.type'                                        AS entity_type,
    json_data->>'$._entityName'                                 AS entity_name,

    JSON_EXTRACT(json_data, '$.user')                            AS user_json

FROM wscpa_breezio.staging_organizations;
