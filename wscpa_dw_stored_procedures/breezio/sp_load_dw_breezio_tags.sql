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

        CAST(
            NULLIF(NULLIF(json_data->>'$.id', ''), 'null')
            AS UNSIGNED
        ),

        CAST(
            NULLIF(NULLIF(json_data->>'$.userId', ''), 'null')
            AS UNSIGNED
        ),

        NULLIF(NULLIF(json_data->>'$.name', ''), 'null'),
        NULLIF(NULLIF(json_data->>'$.slug', ''), 'null'),
        NULLIF(NULLIF(json_data->>'$.imagePath', ''), 'null'),

        NULLIF(json_data->>'$.tagType', 'null'),

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

        CASE
            WHEN JSON_UNQUOTE(JSON_EXTRACT(json_data, '$.deleted')) = 'true' THEN 1
            WHEN JSON_UNQUOTE(JSON_EXTRACT(json_data, '$.deleted')) = 'false' THEN 0
            ELSE NULL
        END,

        CAST(
            NULLIF(NULLIF(json_data->>'$.featured', ''), 'null')
            AS UNSIGNED
        ),

        CAST(
            NULLIF(NULLIF(json_data->>'$.itemsCount', ''), 'null')
            AS UNSIGNED
        ),

        CAST(
            NULLIF(NULLIF(json_data->>'$.priority', ''), 'null')
            AS SIGNED
        ),

        CAST(
            NULLIF(NULLIF(json_data->>'$.portalId', ''), 'null')
            AS UNSIGNED
        ),

        CAST(
            NULLIF(NULLIF(json_data->>'$.organizationId', ''), 'null')
            AS UNSIGNED
        ),

        NULLIF(json_data->>'$.type', 'null'),
        NULLIF(json_data->>'$._entityName', 'null'),

        JSON_EXTRACT(json_data, '$.user')

    FROM wscpa_breezio.staging_tags;

END$$

DELIMITER ;
