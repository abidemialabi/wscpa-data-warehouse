CREATE TABLE wscpa_dw.dim_Products
(
    ProductsKey                  INT AUTO_INCREMENT PRIMARY KEY,
    AuthorsKey                     INT NULL,  -- role-playing FK -> dim_Individuals
    VendorsKey                       INT NULL,  -- role-playing FK -> dim_Firms
    ProductCode                        CHAR(15),
    ProductName                          VARCHAR(255),
    ProductType                            VARCHAR(25),
    ProductFormat                            VARCHAR(50),
    ProductCategoriesList                      TEXT,
    ProductFieldsOfStudyList                     TEXT,
    ProductFieldsOfInterestList                    TEXT,
    ProductSkillLevel                                VARCHAR(50),
    ProductScope                                       VARCHAR(20),
    ProductAvailability                                  VARCHAR(50),
    ProductCompany                                         VARCHAR(50),
    ProductDivision                                          VARCHAR(50),
    ProductGLAccount                                           CHAR(14),
    ProductVendorCode1                                           CHAR(100),
    ProductVendorCode2                                             CHAR(100),
    CONSTRAINT FK_Products_Authors
        FOREIGN KEY (AuthorsKey)
        REFERENCES wscpa_dw.dim_Individuals (IndividualsKey),
    CONSTRAINT FK_Products_Vendors
        FOREIGN KEY (VendorsKey)
        REFERENCES wscpa_dw.dim_Firms (FirmsKey)
) ENGINE=InnoDB;
