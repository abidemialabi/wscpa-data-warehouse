CREATE TABLE wscpa_dw.dim_Months
(
    MonthsKey              INT AUTO_INCREMENT PRIMARY KEY,
    CalendarYear             INT NOT NULL,
    CalendarMonthNumber        TINYINT NOT NULL,
    CalendarMonthName            VARCHAR(10),
    CalendarYearAndMonth           CHAR(8) NOT NULL,
    MonthBeginDate                   DATE,
    MonthEndDate                      DATE,
    UNIQUE KEY UQ_dim_Months_YearMonth (CalendarYearAndMonth)
) ENGINE=InnoDB;
