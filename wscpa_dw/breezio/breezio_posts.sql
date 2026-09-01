SELECT
    CAST(json_data->>'$.id' AS UNSIGNED)                         AS id,
    CAST(json_data->>'$.userId' AS UNSIGNED)                     AS user_id,
    json_data->>'$.rootFolderId'                                 AS root_folder_id,

    NULLIF(json_data->>'$.title','')                             AS title,
    NULLIF(json_data->>'$.slug','')                              AS slug,
    NULLIF(json_data->>'$.subtitle','')                          AS subtitle,
    NULLIF(json_data->>'$.postType','')                          AS post_type,
    NULLIF(json_data->>'$.format','')                            AS format,

    JSON_EXTRACT(json_data, '$.content')                         AS content_json,

    STR_TO_DATE(
        json_data->>'$.creationDate',
        '%Y-%m-%dT%H:%i:%s'
    )                                                            AS creation_date,

    STR_TO_DATE(
        json_data->>'$.modifiedDate',
        '%Y-%m-%dT%H:%i:%s'
    )                                                            AS modified_date,

    STR_TO_DATE(
        json_data->>'$.publishDate',
        '%Y-%m-%dT%H:%i:%s'
    )                                                            AS publish_date,

    STR_TO_DATE(
        json_data->>'$.lastActivityDate',
        '%Y-%m-%dT%H:%i:%s'
    )                                                            AS last_activity_date,

    STR_TO_DATE(
        json_data->>'$.lastConferenceDate',
        '%Y-%m-%dT%H:%i:%s'
    )                                                            AS last_conference_date,

    NULLIF(json_data->>'$.status','')                            AS status,

    CASE
        WHEN json_data->>'$.deleted' = 'true' THEN 1
        WHEN json_data->>'$.deleted' = 'false' THEN 0
        ELSE NULL
    END                                                          AS is_deleted,

    CAST(json_data->>'$.featured' AS UNSIGNED)                   AS is_featured,
    CAST(json_data->>'$.orgFeatured' AS UNSIGNED)                AS is_org_featured,
    CAST(json_data->>'$.hideComments' AS UNSIGNED)               AS hide_comments,
    CAST(json_data->>'$.version' AS UNSIGNED)                    AS version,

    NULLIF(json_data->>'$.sourceId','')                          AS source_id,

    CAST(json_data->>'$.score' AS SIGNED)                        AS score,
    CAST(json_data->>'$.viewCount' AS UNSIGNED)                  AS view_count,

    CASE
        WHEN json_data->>'$.private' = 'true' THEN 1
        WHEN json_data->>'$.private' = 'false' THEN 0
        ELSE NULL
    END                                                          AS is_private,

    CAST(json_data->>'$.organizationId' AS UNSIGNED)             AS organization_id,
    CAST(json_data->>'$.notesCount' AS UNSIGNED)                 AS notes_count,

    JSON_EXTRACT(json_data, '$.metadata')                        AS metadata_json,

    CAST(json_data->>'$.voteScore' AS SIGNED)                    AS vote_score,
    CAST(json_data->>'$.posterId' AS UNSIGNED)                   AS poster_id,
    CAST(json_data->>'$.portalId' AS UNSIGNED)                   AS portal_id,

    NULLIF(json_data->>'$.externalId','')                        AS external_id,
    NULLIF(json_data->>'$.imagePath','')                         AS image_path,

    JSON_EXTRACT(json_data, '$.info')                            AS info_json,

    CAST(json_data->>'$.onlyPathAccessible' AS UNSIGNED)         AS only_path_accessible,
    CAST(json_data->>'$.uniqueViewCount' AS UNSIGNED)            AS unique_view_count,

    CAST(NULLIF(json_data->>'$.price','') AS DECIMAL(18,2))      AS price,
    CAST(json_data->>'$.purchaseCount' AS UNSIGNED)              AS purchase_count,

    NULLIF(json_data->>'$.postHash','')                          AS post_hash,
    NULLIF(json_data->>'$.commentsMode','')                      AS comments_mode,

    json_data->>'$.type'                                        AS entity_type,
    json_data->>'$._entityName'                                 AS entity_name,

    JSON_EXTRACT(json_data, '$.tagsConnected')                   AS tags_connected_json,
    JSON_EXTRACT(json_data, '$.user')                            AS user_json,

    CASE
        WHEN json_data->>'$.purchasedItem' = 'true' THEN 1
        WHEN json_data->>'$.purchasedItem' = 'false' THEN 0
        ELSE NULL
    END                                                          AS purchased_item,

    JSON_EXTRACT(json_data, '$.organization')                    AS organization_json,

    NULLIF(json_data->>'$._displayDate','')                      AS display_date,
    NULLIF(json_data->>'$._dateType','')                         AS date_type

FROM wscpa_breezio.staging_posts;
