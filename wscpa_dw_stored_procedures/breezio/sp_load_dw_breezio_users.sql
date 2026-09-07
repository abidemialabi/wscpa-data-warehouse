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
        CAST(NULLIF(json_data->>'$.id', '') AS UNSIGNED),
        NULLIF(json_data->>'$.unverifiedEmail', ''),
        json_data->>'$.username',
        json_data->>'$.role',
        json_data->>'$.firstName',
        json_data->>'$.lastName',
        json_data->>'$.status',

        CAST(NULLIF(json_data->>'$.state', '') AS UNSIGNED),

        json_data->>'$.imagePath',
        NULLIF(json_data->>'$.cvPath', ''),

        CAST(NULLIF(json_data->>'$.deleted', '') AS UNSIGNED),
        CAST(NULLIF(json_data->>'$.featured', '') AS UNSIGNED),

        STR_TO_DATE(
            NULLIF(json_data->>'$.birthdate', ''),
            '%Y-%m-%d'
        ),

        STR_TO_DATE(
            LEFT(NULLIF(json_data->>'$.creationDate', ''), 19),
            '%Y-%m-%dT%H:%i:%s'
        ),

        CAST(NULLIF(json_data->>'$.lastModifiedBy', '') AS UNSIGNED),

        STR_TO_DATE(
            LEFT(NULLIF(json_data->>'$.modifiedDate', ''), 19),
            '%Y-%m-%dT%H:%i:%s'
        ),

        NULLIF(json_data->>'$.bio', ''),
        NULLIF(json_data->>'$.shortBio', ''),
        NULLIF(json_data->>'$.gender', ''),
        NULLIF(json_data->>'$.website', ''),
        NULLIF(json_data->>'$.officeHours', ''),

        CAST(NULLIF(json_data->>'$.viewCount', '') AS UNSIGNED),
        CAST(NULLIF(json_data->>'$.postsCount', '') AS UNSIGNED),
        CAST(NULLIF(json_data->>'$.commentsCount', '') AS UNSIGNED),
        CAST(NULLIF(json_data->>'$.votesCount', '') AS UNSIGNED),

        CAST(NULLIF(json_data->>'$.score', '') AS SIGNED),
        CAST(NULLIF(json_data->>'$.foo', '') AS SIGNED),
        CAST(NULLIF(json_data->>'$.bar', '') AS SIGNED),

        json_data->>'$.activeKey',
        NULLIF(json_data->>'$.title', ''),

        CAST(NULLIF(json_data->>'$.version', '') AS UNSIGNED),
        CAST(NULLIF(json_data->>'$.invitedBy', '') AS UNSIGNED),
        CAST(NULLIF(json_data->>'$.invitedCount', '') AS UNSIGNED),
        CAST(NULLIF(json_data->>'$.portalId', '') AS UNSIGNED),
        CAST(NULLIF(json_data->>'$.originalPortalId', '') AS UNSIGNED),
        CAST(NULLIF(json_data->>'$.externalId', '') AS UNSIGNED),
        CAST(NULLIF(json_data->>'$.externalId2', '') AS UNSIGNED),

        json_data->>'$.rootFolderId',

        CAST(NULLIF(json_data->>'$.private', '') AS UNSIGNED),
        CAST(NULLIF(json_data->>'$.cloakMode', '') AS UNSIGNED),

        json_data->>'$.privacy',

        NULLIF(json_data->>'$.metadata.company', ''),
        NULLIF(json_data->>'$.metadata.city', ''),
        NULLIF(json_data->>'$.metadata.country', ''),
        NULLIF(json_data->>'$.metadata.phone', ''),
        NULLIF(json_data->>'$.metadata.twitter', ''),
        NULLIF(json_data->>'$.metadata.facebook', ''),
        NULLIF(json_data->>'$.metadata.linkedin', ''),
        NULLIF(json_data->>'$.metadata.instagram', ''),
        NULLIF(json_data->>'$.metadata.publicEmail', ''),
        NULLIF(json_data->>'$.metadata.nickname', ''),

        JSON_EXTRACT(json_data, '$.metadata'),

        json_data->>'$.timezone',
        json_data->>'$.userType',
        json_data->>'$.membershipType',

        STR_TO_DATE(
            LEFT(NULLIF(json_data->>'$.lastFetchDate', ''), 19),
            '%Y-%m-%dT%H:%i:%s'
        ),

        STR_TO_DATE(
            LEFT(NULLIF(json_data->>'$.lastSeenDate', ''), 19),
            '%Y-%m-%dT%H:%i:%s'
        ),

        CAST(NULLIF(json_data->>'$.followersCount', '') AS UNSIGNED),
        CAST(NULLIF(json_data->>'$.followingsCount', '') AS UNSIGNED),
        CAST(NULLIF(json_data->>'$.isActive', '') AS UNSIGNED),
        CAST(NULLIF(json_data->>'$.hardDeleted', '') AS UNSIGNED),
        CAST(NULLIF(json_data->>'$.syncRequired', '') AS UNSIGNED),

        STR_TO_DATE(
            LEFT(NULLIF(json_data->>'$.lastSyncDate', ''), 19),
            '%Y-%m-%dT%H:%i:%s'
        ),

        CAST(NULLIF(json_data->>'$.lastSyncBy', '') AS UNSIGNED),
        CAST(NULLIF(json_data->>'$.suspended', '') AS UNSIGNED),

        NULLIF(json_data->>'$.alternateEmail', ''),
        json_data->>'$.hash',
        json_data->>'$.user_email',
        json_data->>'$.type',
        json_data->>'$._entityName'

    FROM wscpa_breezio.staging_users;

END$$

DELIMITER ;
