SELECT
    CAST(json_data->>'$.id' AS UNSIGNED)                         AS id,
    CAST(json_data->>'$.userId' AS UNSIGNED)                     AS user_id,

    NULLIF(json_data->>'$.name','')                              AS name,
    NULLIF(json_data->>'$.slug','')                              AS slug,
    NULLIF(json_data->>'$.imagePath','')                         AS image_path,
    NULLIF(json_data->>'$.tagType','')                           AS tag_type,

    STR_TO_DATE(
        json_data->>'$.creationDate',
        '%Y-%m-%dT%H:%i:%s'
    )                                                            AS creation_date,

    STR_TO_DATE(
        json_data->>'$.modifiedDate',
        '%Y-%m-%dT%H:%i:%s'
    )                                                            AS modified_date,

    CASE
        WHEN json_data->>'$.deleted' = 'true' THEN 1
        WHEN json_data->>'$.deleted' = 'false' THEN 0
        ELSE NULL
    END                                                          AS is_deleted,

    CAST(json_data->>'$.featured' AS UNSIGNED)                   AS is_featured,
    CAST(json_data->>'$.itemsCount' AS UNSIGNED)                 AS items_count,
    CAST(json_data->>'$.priority' AS SIGNED)                     AS priority,
    CAST(json_data->>'$.portalId' AS UNSIGNED)                   AS portal_id,

    CAST(
        NULLIF(json_data->>'$.organizationId','')
        AS UNSIGNED
    )                                                            AS organization_id,

    json_data->>'$.type'                                        AS entity_type,
    json_data->>'$._entityName'                                 AS entity_name,

    JSON_EXTRACT(json_data, '$.user')                            AS user_json

FROM wscpa_breezio.staging_tags;
