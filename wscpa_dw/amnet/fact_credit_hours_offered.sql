CREATE TABLE wscpa_dw.fact_CreditHoursOffered
(
    CreditHoursOfferedKey        INT AUTO_INCREMENT PRIMARY KEY,
    CreditCategoriesKey             INT NOT NULL,
    CreditSourceType                   VARCHAR(20) NULL,
    CreditSourceEventsKey                  INT NULL,
    CreditSourceEventSessionsKey              INT NULL,
    CreditSourceProductsKey                      INT NULL,
    CreditHoursOffered                             DECIMAL(6,2) NOT NULL,
    CONSTRAINT FK_CHO_Categories
        FOREIGN KEY (CreditCategoriesKey)
        REFERENCES wscpa_dw.dim_CreditCategories (CreditCategoriesKey),
    CONSTRAINT FK_CHO_Events
        FOREIGN KEY (CreditSourceEventsKey)
        REFERENCES wscpa_dw.dim_Events (EventsKey),
    CONSTRAINT FK_CHO_EventSessions
        FOREIGN KEY (CreditSourceEventSessionsKey)
        REFERENCES wscpa_dw.dim_EventSessions (EventSessionsKey),
    CONSTRAINT FK_CHO_Products
        FOREIGN KEY (CreditSourceProductsKey)
        REFERENCES wscpa_dw.dim_Products (ProductsKey)
) ENGINE=InnoDB;
