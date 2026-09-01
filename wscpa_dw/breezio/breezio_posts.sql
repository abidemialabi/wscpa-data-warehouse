DROP TABLE IF EXISTS wscpa_dw.breezio_posts;

CREATE TABLE wscpa_dw.breezio_posts
(
    id                          BIGINT UNSIGNED PRIMARY KEY,
    user_id                     BIGINT UNSIGNED,
    root_folder_id              BIGINT UNSIGNED,
    title                       VARCHAR(1000),
    slug                        VARCHAR(1000),
    subtitle                    TEXT,
    post_type                   VARCHAR(100),
    format                      VARCHAR(100),
    content_json                JSON,

    creation_date               DATETIME,
    modified_date               DATETIME,
    publish_date                DATETIME,
    last_activity_date          DATETIME,
    last_conference_date        DATETIME,

    status                      VARCHAR(100),
    is_deleted                  TINYINT UNSIGNED,
    is_featured                 TINYINT UNSIGNED,
    org_featured                TINYINT UNSIGNED,
    hide_comments               TINYINT UNSIGNED,

    version                     INT UNSIGNED,
    source_id                   VARCHAR(255),
    score                       INT,
    view_count                  INT UNSIGNED,
    is_private                  TINYINT UNSIGNED,

    organization_id             BIGINT UNSIGNED,
    notes_count                 INT UNSIGNED,

    metadata_json               JSON,

    vote_score                  INT,
    poster_id                   BIGINT UNSIGNED,
    portal_id                   BIGINT UNSIGNED,
    external_id                 VARCHAR(255),
    image_path                  TEXT,

    info_json                   JSON,

    only_path_accessible        TINYINT UNSIGNED,
    unique_view_count           INT UNSIGNED,
    price                       DECIMAL(12,2),
    purchase_count              INT UNSIGNED,

    post_hash                   VARCHAR(255),
    comments_mode               VARCHAR(100),

    entity_type                 VARCHAR(100),
    entity_name                 VARCHAR(100),

    tags_connected_json         JSON,
    user_json                   JSON,
    purchased_item              TINYINT UNSIGNED,
    organization_json           JSON,

    display_date                VARCHAR(100),
    date_type                   VARCHAR(100)
) ENGINE=InnoDB;
