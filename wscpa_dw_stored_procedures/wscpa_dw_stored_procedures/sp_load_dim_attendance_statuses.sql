DROP PROCEDURE IF EXISTS wscpa_dw.sp_load_dim_attendance_statuses;

DELIMITER $$

CREATE PROCEDURE wscpa_dw.sp_load_dim_attendance_statuses()
BEGIN

    DELETE FROM wscpa_dw.dim_AttendanceStatuses;

    INSERT INTO wscpa_dw.dim_AttendanceStatuses
    (
        AttendanceStatusesKey,
        AttendanceStatus
    )
    SELECT
        CAST(attendance_statuses_key AS SIGNED),
        CAST(attendance_status AS CHAR(50))
    FROM wscpa_amnet.staging_attendance_statuses;

END$$

DELIMITER ;
