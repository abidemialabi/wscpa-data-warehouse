DROP PROCEDURE IF EXISTS wscpa_dw.sp_load_dim_communications;

DELIMITER $$

CREATE PROCEDURE wscpa_dw.sp_load_dim_communications()
BEGIN

    DELETE FROM wscpa_dw.dim_Communications;

    INSERT INTO wscpa_dw.dim_Communications
    (
        CommunicationsKey,
        CommunicationTitle,
        CommunicationDescription,
        CommunicationMethodList,
        PromotionTitle,
        PromotionDescription,
        PromotionCategory,
        PromotionSubcategory,
        PromotionGroupList,
        CommunicationDatesKey,
        BeginDatesKey,
        EndDatesKey
    )
    SELECT
        CAST(communications_key AS SIGNED),
        CAST(communication_title AS CHAR(75)),
        CAST(communication_description AS CHAR(88)),
        CAST(communication_method_list AS CHAR),
        CAST(promotion_title AS CHAR(75)),
        CAST(promotion_description AS CHAR),
        CAST(promotion_category AS CHAR(50)),
        CAST(promotion_subcategory AS CHAR(50)),
        CAST(promotion_group_list AS CHAR),
        CAST(communication_dates_key AS SIGNED),
        CAST(begin_dates_key AS SIGNED),
        CAST(end_dates_key AS SIGNED)
    FROM wscpa_amnet.staging_communications;

END$$

DELIMITER ;
