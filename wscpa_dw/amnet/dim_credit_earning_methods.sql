CREATE TABLE wscpa_dw.dim_CreditEarningMethods
(
    CreditEarningMethodsKey  INT AUTO_INCREMENT PRIMARY KEY,
    CreditEarningMethod        VARCHAR(50)  -- Event Attendance, Leader Preparation, Self-Study Event, Self-Study Product, Self-Reported CPE
) ENGINE=InnoDB;
