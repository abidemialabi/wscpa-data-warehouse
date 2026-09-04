CREATE TABLE wscpa_dw.fact_PromotionConversions
(
    PromotionConversionsKey     INT AUTO_INCREMENT PRIMARY KEY,
    IndividualsKey                 INT NOT NULL,
    CommunicationsKey                 INT NOT NULL,
    EngagementOpportunitiesKey          INT NOT NULL,
    ConversionDatesKey                    INT NOT NULL,
    IndividualID                            VARCHAR(20),
    DaysUntilConversion                       INT,
    ConversionCount                             INT,
    CONSTRAINT FK_PromoConv_Individuals
        FOREIGN KEY (IndividualsKey)
        REFERENCES wscpa_dw.dim_Individuals (IndividualsKey),
    CONSTRAINT FK_PromoConv_Communications
        FOREIGN KEY (CommunicationsKey)
        REFERENCES wscpa_dw.dim_Communications (CommunicationsKey),
    CONSTRAINT FK_PromoConv_EngagementOpportunities
        FOREIGN KEY (EngagementOpportunitiesKey)
        REFERENCES wscpa_dw.dim_EngagementOpportunities (EngagementOpportunitiesKey),
    CONSTRAINT FK_PromoConv_ConversionDates
        FOREIGN KEY (ConversionDatesKey)
        REFERENCES wscpa_dw.dim_Dates (DatesKey)
) ENGINE=InnoDB;
