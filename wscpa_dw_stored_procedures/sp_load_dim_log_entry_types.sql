DROP PROCEDURE IF EXISTS wscpa_dw.sp_load_dim_log_entry_types;

DELIMITER $$

CREATE PROCEDURE wscpa_dw.sp_load_dim_log_entry_types()
BEGIN

    DELETE FROM wscpa_dw.dim_LogEntryTypes;

    INSERT INTO wscpa_dw.dim_LogEntryTypes
    (
        LogEntryTypesKey,
        LogType,
        LogSubType,
        EngagementYN,
        LogModule
    )
    SELECT
        CAST(log_entry_types_key AS SIGNED),
        CAST(log_type AS CHAR(50)),
        CAST(log_sub_type AS CHAR(50)),
        CAST(engagement_yn AS CHAR(3)),
        CAST(log_module AS CHAR(50))
    FROM wscpa_amnet.staging_log_entry_types;

END$$

DELIMITER ;
