DROP TABLE IF EXISTS wscpa_dw.dw_breezio_tags;

CREATE TABLE wscpa_dw.dw_breezio_tags
(
    id                  BIGINT UNSIGNED NOT NULL,
    user_id             BIGINT UNSIGNED NULL,
    name                VARCHAR(255) NULL,
    slug                VARCHAR(255) NULL,
    image_path          TEXT NULL,
    tag_type            VARCHAR(50) NULL,
    creation_date       DATETIME NULL,
    modified_date       DATETIME NULL,
    is_deleted          TINYINT UNSIGNED NULL,
    is_featured         TINYINT UNSIGNED NULL,
    items_count         INT UNSIGNED NULL,
    priority            INT NULL,
    portal_id           BIGINT UNSIGNED NULL,
    organization_id     BIGINT UNSIGNED NULL,
    entity_type         VARCHAR(50) NULL,
    entity_name         VARCHAR(50) NULL,
    user_json           JSON NULL,

    PRIMARY KEY (id)
)
ENGINE=InnoDB;
