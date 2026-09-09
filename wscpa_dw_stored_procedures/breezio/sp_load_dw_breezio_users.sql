DROP PROCEDURE IF EXISTS wscpa_dw.sp_load_dw_breezio_users;

DELIMITER $$

CREATE PROCEDURE wscpa_dw.sp_load_dw_breezio_users()
BEGIN

    DELETE FROM wscpa_dw.dw_breezio_users;

    INSERT INTO wscpa_dw.dw_breezio_users
    (
        id,
        unverified_email,
        username,
        role,
        first_name,
        last_name,
        status,
        state,
        image_path,
        cv_path,
        is_deleted,
        is_featured,
        birthdate,
        creation_date,
        last_modified_by,
        modified_date,
        bio,
        short_bio,
        gender,
        website,
        office_hours,
        view_count,
        posts_count,
        comments_count,
        votes_count,
        score,
        foo,
        bar,
        active_key,
        title,
        version,
        invited_by,
        invited_count,
        portal_id,
        original_portal_id,
        external_id,
        external_id2,
        root_folder_id,
        is_private,
        cloak_mode,
        privacy,
        metadata_company,
        metadata_city,
        metadata_country,
        metadata_phone,
        metadata_twitter,
        metadata_facebook,
        metadata_linkedin,
        metadata_instagram,
        metadata_public_email,
        metadata_nickname,
        metadata_json,
        timezone,
        user_type,
        membership_type,
        last_fetch_date,
        last_seen_date,
        followers_count,
        followings_count,
        is_active,
        hard_deleted,
        sync_required,
        last_sync_date,
        last_sync_by,
        is_suspended,
        alternate_email,
        hash,
        user_email,
        entity_type,
        entity_name
    )
    SELECT
        CAST(
            NULLIF(NULLIF(json_data->>'$.id', ''), 'null')
            AS UNSIGNED
        ),

        NULLIF(NULLIF(json_data->>'$.unverifiedEmail', ''), 'null'),
        NULLIF(json_data->>'$.username', 'null'),
        NULLIF(json_data->>'$.role', 'null'),
        NULLIF(json_data->>'$.firstName', 'null'),
        NULLIF(json_data->>'$.lastName', 'null'),
        NULLIF(json_data->>'$.status', 'null'),

        CAST(
            NULLIF(NULLIF(json_data->>'$.state', ''), 'null')
            AS UNSIGNED
        ),

        NULLIF(json_data->>'$.imagePath', 'null'),
        NULLIF(NULLIF(json_data->>'$.cvPath', ''), 'null'),

        CAST(
            NULLIF(NULLIF(json_data->>'$.deleted', ''), 'null')
            AS UNSIGNED
        ),

        CAST(
            NULLIF(NULLIF(json_data->>'$.featured', ''), 'null')
            AS UNSIGNED
        ),

        STR_TO_DATE(
            NULLIF(NULLIF(json_data->>'$.birthdate', ''), 'null'),
            '%Y-%m-%d'
        ),

        STR_TO_DATE(
            LEFT(
                NULLIF(NULLIF(json_data->>'$.creationDate', ''), 'null'),
                19
            ),
            '%Y-%m-%dT%H:%i:%s'
        ),

        CAST(
            NULLIF(NULLIF(json_data->>'$.lastModifiedBy', ''), 'null')
            AS UNSIGNED
        ),

        STR_TO_DATE(
            LEFT(
                NULLIF(NULLIF(json_data->>'$.modifiedDate', ''), 'null'),
                19
            ),
            '%Y-%m-%dT%H:%i:%s'
        ),

        NULLIF(NULLIF(json_data->>'$.bio', ''), 'null'),
        NULLIF(NULLIF(json_data->>'$.shortBio', ''), 'null'),
        NULLIF(NULLIF(json_data->>'$.gender', ''), 'null'),
        NULLIF(NULLIF(json_data->>'$.website', ''), 'null'),
        NULLIF(NULLIF(json_data->>'$.officeHours', ''), 'null'),

        CAST(
            NULLIF(NULLIF(json_data->>'$.viewCount', ''), 'null')
            AS UNSIGNED
        ),

        CAST(
            NULLIF(NULLIF(json_data->>'$.postsCount', ''), 'null')
            AS UNSIGNED
        ),

        CAST(
            NULLIF(NULLIF(json_data->>'$.commentsCount', ''), 'null')
            AS UNSIGNED
        ),

        CAST(
            NULLIF(NULLIF(json_data->>'$.votesCount', ''), 'null')
            AS UNSIGNED
        ),

        CAST(
            NULLIF(NULLIF(json_data->>'$.score', ''), 'null')
            AS SIGNED
        ),

        CAST(
            NULLIF(NULLIF(json_data->>'$.foo', ''), 'null')
            AS SIGNED
        ),

        CAST(
            NULLIF(NULLIF(json_data->>'$.bar', ''), 'null')
            AS SIGNED
        ),

        NULLIF(json_data->>'$.activeKey', 'null'),
        NULLIF(NULLIF(json_data->>'$.title', ''), 'null'),

        CAST(
            NULLIF(NULLIF(json_data->>'$.version', ''), 'null')
            AS UNSIGNED
        ),

        CAST(
            NULLIF(NULLIF(json_data->>'$.invitedBy', ''), 'null')
            AS UNSIGNED
        ),

        CAST(
            NULLIF(NULLIF(json_data->>'$.invitedCount', ''), 'null')
            AS UNSIGNED
        ),

        CAST(
            NULLIF(NULLIF(json_data->>'$.portalId', ''), 'null')
            AS UNSIGNED
        ),

        CAST(
            NULLIF(NULLIF(json_data->>'$.originalPortalId', ''), 'null')
            AS UNSIGNED
        ),

        CAST(
            NULLIF(NULLIF(json_data->>'$.externalId', ''), 'null')
            AS UNSIGNED
        ),

        CAST(
            NULLIF(NULLIF(json_data->>'$.externalId2', ''), 'null')
            AS UNSIGNED
        ),

        NULLIF(json_data->>'$.rootFolderId', 'null'),

        CAST(
            NULLIF(NULLIF(json_data->>'$.private', ''), 'null')
            AS UNSIGNED
        ),

        CAST(
            NULLIF(NULLIF(json_data->>'$.cloakMode', ''), 'null')
            AS UNSIGNED
        ),

        NULLIF(json_data->>'$.privacy', 'null'),

        NULLIF(NULLIF(json_data->>'$.metadata.company', ''), 'null'),
        NULLIF(NULLIF(json_data->>'$.metadata.city', ''), 'null'),
        NULLIF(NULLIF(json_data->>'$.metadata.country', ''), 'null'),
        NULLIF(NULLIF(json_data->>'$.metadata.phone', ''), 'null'),
        NULLIF(NULLIF(json_data->>'$.metadata.twitter', ''), 'null'),
        NULLIF(NULLIF(json_data->>'$.metadata.facebook', ''), 'null'),
        NULLIF(NULLIF(json_data->>'$.metadata.linkedin', ''), 'null'),
        NULLIF(NULLIF(json_data->>'$.metadata.instagram', ''), 'null'),
        NULLIF(NULLIF(json_data->>'$.metadata.publicEmail', ''), 'null'),
        NULLIF(NULLIF(json_data->>'$.metadata.nickname', ''), 'null'),

        JSON_EXTRACT(json_data, '$.metadata'),

        NULLIF(json_data->>'$.timezone', 'null'),
        NULLIF(json_data->>'$.userType', 'null'),
        NULLIF(json_data->>'$.membershipType', 'null'),

        STR_TO_DATE(
            LEFT(
                NULLIF(NULLIF(json_data->>'$.lastFetchDate', ''), 'null'),
                19
            ),
            '%Y-%m-%dT%H:%i:%s'
        ),

        STR_TO_DATE(
            LEFT(
                NULLIF(NULLIF(json_data->>'$.lastSeenDate', ''), 'null'),
                19
            ),
            '%Y-%m-%dT%H:%i:%s'
        ),

        CAST(
            NULLIF(NULLIF(json_data->>'$.followersCount', ''), 'null')
            AS UNSIGNED
        ),

        CAST(
            NULLIF(NULLIF(json_data->>'$.followingsCount', ''), 'null')
            AS UNSIGNED
        ),

        CAST(
            NULLIF(NULLIF(json_data->>'$.isActive', ''), 'null')
            AS UNSIGNED
        ),

        CAST(
            NULLIF(NULLIF(json_data->>'$.hardDeleted', ''), 'null')
            AS UNSIGNED
        ),

        CAST(
            NULLIF(NULLIF(json_data->>'$.syncRequired', ''), 'null')
            AS UNSIGNED
        ),

        STR_TO_DATE(
            LEFT(
                NULLIF(NULLIF(json_data->>'$.lastSyncDate', ''), 'null'),
                19
            ),
            '%Y-%m-%dT%H:%i:%s'
        ),

        CAST(
            NULLIF(NULLIF(json_data->>'$.lastSyncBy', ''), 'null')
            AS UNSIGNED
        ),

        CAST(
            NULLIF(NULLIF(json_data->>'$.suspended', ''), 'null')
            AS UNSIGNED
        ),

        NULLIF(NULLIF(json_data->>'$.alternateEmail', ''), 'null'),
        NULLIF(json_data->>'$.hash', 'null'),
        NULLIF(json_data->>'$.user_email', 'null'),
        NULLIF(json_data->>'$.type', 'null'),
        NULLIF(json_data->>'$._entityName', 'null')

    FROM wscpa_breezio.staging_users;

END$$

DELIMITER ;
