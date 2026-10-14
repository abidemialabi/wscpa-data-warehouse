DROP PROCEDURE IF EXISTS wscpa_dw.sp_run_wscpa_dw_sproc_in_synapse;

CREATE PROCEDURE wscpa_dw.sp_run_wscpa_dw_sproc_in_synapse(IN p_name VARCHAR(200), IN p_args VARCHAR(500))
BEGIN
  SET @sql = CONCAT('CALL ', p_name, '(', IFNULL(p_args, ''), ')');
  PREPARE stmt FROM @sql;
  EXECUTE stmt;
  DEALLOCATE PREPARE stmt;
  SELECT 'Sproc Run Completed' AS status;
END;