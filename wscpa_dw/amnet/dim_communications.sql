CREATE TABLE wscpa_dw.dim_Communications
(
    CommunicationsKey               INT AUTO_INCREMENT PRIMARY KEY,
    CommunicationTitle                 VARCHAR(75),
    CommunicationDescription             VARCHAR(88),
    CommunicationMethodList                TEXT,
    PromotionTitle                           VARCHAR(75),
    PromotionDescription                       LONGTEXT,
    PromotionCategory                            VARCHAR(50),
    PromotionSubcategory                           VARCHAR(50),
    PromotionGroupList                               TEXT,
    CommunicationDatesKey                              INT NULL,  -- role-playing FK -> dim_Dates
    BeginDatesKey                                        INT NULL,  -- role-playing FK -> dim_Dates
    EndDatesKey                                            INT NULL,  -- role-playing FK -> dim_Dates
    CONSTRAINT FK_Communications_CommunicationDates
        FOREIGN KEY (CommunicationDatesKey)
        REFERENCES wscpa_dw.dim_Dates (DatesKey),
    CONSTRAINT FK_Communications_BeginDates
        FOREIGN KEY (BeginDatesKey)
        REFERENCES wscpa_dw.dim_Dates (DatesKey),
    CONSTRAINT FK_Communications_EndDates
        FOREIGN KEY (EndDatesKey)
        REFERENCES wscpa_dw.dim_Dates (DatesKey)
) ENGINE=InnoDB;
