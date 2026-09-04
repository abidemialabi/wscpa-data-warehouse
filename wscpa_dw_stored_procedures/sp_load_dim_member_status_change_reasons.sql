DROP PROCEDURE IF EXISTS wscpa_dw.sp_load_dim_member_status_change_reasons;

DELIMITER $$

CREATE PROCEDURE wscpa_dw.sp_load_dim_member_status_change_reasons()
BEGIN

    DELETE FROM wscpa_dw.dim_MemberStatusChangeReasons;

    INSERT INTO wscpa_dw.dim_MemberStatusChangeReasons
    (
        MemberStatusChangeReasonsKey,
        MemberStatusChangeReason
    )
    SELECT
        CAST(member_status_change_reasons_key AS SIGNED),
        CAST(member_status_change_reason AS CHAR(20))
    FROM wscpa_amnet.staging_member_status_change_reasons;

END$$

DELIMITER ;DROP PROCEDURE IF EXISTS wscpa_dw.sp_load_dim_member_status_change_reasons;

DELIMITER $$

CREATE PROCEDURE wscpa_dw.sp_load_dim_member_status_change_reasons()
BEGIN

    DELETE FROM wscpa_dw.dim_MemberStatusChangeReasons;

    INSERT INTO wscpa_dw.dim_MemberStatusChangeReasons
    (
        MemberStatusChangeReasonsKey,
        MemberStatusChangeReason
    )
    SELECT
        CAST(member_status_change_reasons_key AS SIGNED),
        CAST(member_status_change_reason AS CHAR(20))
    FROM wscpa_amnet.staging_member_status_change_reasons;

END$$

DELIMITER ;
