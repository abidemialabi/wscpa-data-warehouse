CREATE TABLE wscpa_dw.dim_LogEntryTypes
(
    LogEntryTypesKey        INT AUTO_INCREMENT PRIMARY KEY,
    LogType                    VARCHAR(50),
    LogSubType                    VARCHAR(50),
    EngagementYN                     VARCHAR(3),
    LogModule                          VARCHAR(50)
) ENGINE=InnoDB;
