CREATE TABLE wscpa_dw.fact_CreditHoursEarned
(
    CreditHoursEarnedKey         INT AUTO_INCREMENT PRIMARY KEY,
    MembersKey                     INT NOT NULL,
    CreditEarningMethodsKey           INT NOT NULL,
    CreditCategoriesKey                 INT NOT NULL,
    CreditSourceType                       VARCHAR(20) NULL,  -- Event, Session, Product, Self-Reported CPE
    CreditSourceEventsKey                    INT NULL,
    CreditSourceEventSessionsKey                INT NULL,
    CreditSourceProductsKey                        INT NULL,
    CreditSourceSelfReportedCPEEventsKey              INT NULL,  -- FK -> dim_SelfReportedCPEEvents (not in this batch)
    CompletionDatesKey                                  INT NOT NULL,
    MemberID                                              VARCHAR(20),
    CreditHoursEarned                                       DECIMAL(6,2) NOT NULL,
    CONSTRAINT FK_CHE_Members
        FOREIGN KEY (MembersKey)
        REFERENCES wscpa_dw.dim_Individuals (IndividualsKey),
    CONSTRAINT FK_CHE_EarningMethods
        FOREIGN KEY (CreditEarningMethodsKey)
        REFERENCES wscpa_dw.dim_CreditEarningMethods (CreditEarningMethodsKey),
    CONSTRAINT FK_CHE_Categories
        FOREIGN KEY (CreditCategoriesKey)
        REFERENCES wscpa_dw.dim_CreditCategories (CreditCategoriesKey),
    CONSTRAINT FK_CHE_Events
        FOREIGN KEY (CreditSourceEventsKey)
        REFERENCES wscpa_dw.dim_Events (EventsKey),
    CONSTRAINT FK_CHE_EventSessions
        FOREIGN KEY (CreditSourceEventSessionsKey)
        REFERENCES wscpa_dw.dim_EventSessions (EventSessionsKey),
    CONSTRAINT FK_CHE_Products
        FOREIGN KEY (CreditSourceProductsKey)
        REFERENCES wscpa_dw.dim_Products (ProductsKey),
    CONSTRAINT FK_CHE_CompletionDates
        FOREIGN KEY (CompletionDatesKey)
        REFERENCES wscpa_dw.dim_Dates (DatesKey)
) ENGINE=InnoDB;
