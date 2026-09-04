DROP TABLE IF EXISTS wscpa_dw.dw_breezio_organizations;

CREATE TABLE wscpa_dw.dw_breezio_organizations
(
    id                          BIGINT UNSIGNED NOT NULL,
    user_id                     BIGINT UNSIGNED NULL,

    name                        VARCHAR(255) NULL,
    category                    VARCHAR(255) NULL,
    region                      VARCHAR(255) NULL,
    bio                         TEXT NULL,
    billing_email               VARCHAR(320) NULL,
    website                     VARCHAR(500) NULL,
    image_path                  TEXT NULL,
    background_image_path       TEXT NULL,
    slug                        VARCHAR(500) NULL,

    foo                         INT NULL,
    view_count                  INT UNSIGNED NULL,

    creation_date               DATETIME NULL,
    modified_date               DATETIME NULL,

    is_featured                 TINYINT UNSIGNED NULL,
    is_deleted                  TINYINT UNSIGNED NULL,

    portal_id                   BIGINT UNSIGNED NULL,
    root_folder_id              VARCHAR(100) NULL,
    is_private                  TINYINT UNSIGNED NULL,

    external_id                 VARCHAR(255) NULL,
    external_id2                VARCHAR(255) NULL,

    latest_posts                INT UNSIGNED NULL,
    latest_paths                INT UNSIGNED NULL,

    post_force_subscription     TINYINT UNSIGNED NULL,
    quick_discussion            TINYINT UNSIGNED NULL,
    community_members           TINYINT UNSIGNED NULL,
    visibility                  TINYINT UNSIGNED NULL,
    event_button_visibility     TINYINT UNSIGNED NULL,
    video_conference            TINYINT UNSIGNED NULL,

    join_rule                   VARCHAR(50) NULL,
    default_role                VARCHAR(50) NULL,

    config_json                 JSON NULL,

    entity_type                 VARCHAR(50) NULL,
    entity_name                 VARCHAR(50) NULL,

    user_json                   JSON NULL,

    PRIMARY KEY (id)
)
ENGINE=InnoDB;
