DROP PROCEDURE IF EXISTS wscpa_dw.sp_load_dw_breezio_tags;

DELIMITER $$

CREATE PROCEDURE wscpa_dw.sp_load_dw_breezio_tags()
BEGIN

    DELETE FROM wscpa_dw.dw_breezio_tags;

    INSERT INTO wscpa_dw.dw_breezio_tags
    (
        id,
        user_id,
        name,
        slug,
        image_path,
        tag_type,
        creation_date,
        modified_date,
        is_deleted,
        is_featured,
        items_count,
        priority,
        portal_id,
        organization_id,
        entity_type,
        entity_name,
        user_json
    )
    SELECT
        CAST(NULLIF(json_data->>'$.id', '') AS UNSIGNED),

        CAST(NULLIF(json_data->>'$.userId', '') AS UNSIGNED),

        NULLIF(json_data->>'$.name', ''),
        NULLIF(json_data->>'$.slug', ''),
        NULLIF(json_data->>'$.imagePath', ''),

        json_data->>'$.tagType',

        STR_TO_DATE(
            LEFT(NULLIF(json_data->>'$.creationDate', ''), 19),
            '%Y-%m-%dT%H:%i:%s'
        ),

        STR_TO_DATE(
            LEFT(NULLIF(json_data->>'$.modifiedDate', ''), 19),
            '%Y-%m-%dT%H:%i:%s'
        ),

        CASE
            WHEN JSON_UNQUOTE(JSON_EXTRACT(json_data, '$.deleted')) = 'true' THEN 1
            WHEN JSON_UNQUOTE(JSON_EXTRACT(json_data, '$.deleted')) = 'false' THEN 0
            ELSE NULL
        END,

        CAST(NULLIF(json_data->>'$.featured', '') AS UNSIGNED),

        CAST(NULLIF(json_data->>'$.itemsCount', '') AS UNSIGNED),

        CAST(NULLIF(json_data->>'$.priority', '') AS SIGNED),

        CAST(NULLIF(json_data->>'$.portalId', '') AS UNSIGNED),

        CAST(NULLIF(json_data->>'$.organizationId', '') AS UNSIGNED),

        json_data->>'$.type',
        json_data->>'$._entityName',

        JSON_EXTRACT(json_data, '$.user')

    FROM wscpa_breezio.staging_tags;

END$$

DELIMITER ;
