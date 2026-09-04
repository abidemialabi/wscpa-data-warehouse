CREATE TABLE wscpa_dw.dim_CreditCategories
(
    CreditCategoriesKey    INT AUTO_INCREMENT PRIMARY KEY,
    CreditCategory           VARCHAR(50),
    CPEQualifiedYN             VARCHAR(3)
) ENGINE=InnoDB;
