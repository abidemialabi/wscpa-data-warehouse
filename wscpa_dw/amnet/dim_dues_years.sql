CREATE TABLE wscpa_dw.dim_DuesYears
(
    DuesYearsKey       INT AUTO_INCREMENT PRIMARY KEY,
    DuesYearName          CHAR(4) NOT NULL,
    DuesYearBeginDate       DATE,
    DuesYearEndDate           DATE,
    UNIQUE KEY UQ_dim_DuesYears_Name (DuesYearName)
) ENGINE=InnoDB;
