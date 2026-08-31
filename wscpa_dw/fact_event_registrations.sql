CREATE TABLE wscpa_dw.fact_EventRegistrations
(
    EventRegistrationsKey       INT AUTO_INCREMENT PRIMARY KEY,
    RegistrantsKey                 INT NOT NULL,
    EventsKey                        INT NOT NULL,
    RegistrationStatusesKey             INT NULL,  -- FK -> dim_RegistrationStatuses (not in this batch)
    RegistrationDatesKey                   INT NOT NULL,
    CompletionDatesKey                       INT NULL,
    ResellersKey                               INT NULL,
    RegistrantID                                 VARCHAR(20),
    CancellationDate                               DATE,
    CreditHoursEarnedAtEvent                         DECIMAL(6,2),
    FeesBilledTotal                                    DECIMAL(12,2),
    FeesPaidTotal                                        DECIMAL(12,2),
    FeesPaidDate                                           DATE,
    FeesBalanceDue                                           DECIMAL(12,2),
    MilesFromHome                                              DECIMAL(9,2),
    MilesFromWork                                                DECIMAL(9,2),
    MilesFromPreferredAddress                                      DECIMAL(9,2),
    DaysBeforeEvent                                                  INT,
    RegistrantAge                                                      INT,
    RegistrantAgeBracket                                                 VARCHAR(10),
    CONSTRAINT FK_EventReg_Registrants
        FOREIGN KEY (RegistrantsKey)
        REFERENCES wscpa_dw.dim_Individuals (IndividualsKey),
    CONSTRAINT FK_EventReg_Events
        FOREIGN KEY (EventsKey)
        REFERENCES wscpa_dw.dim_Events (EventsKey),
    CONSTRAINT FK_EventReg_RegistrationDates
        FOREIGN KEY (RegistrationDatesKey)
        REFERENCES wscpa_dw.dim_Dates (DatesKey),
    CONSTRAINT FK_EventReg_CompletionDates
        FOREIGN KEY (CompletionDatesKey)
        REFERENCES wscpa_dw.dim_Dates (DatesKey),
    CONSTRAINT FK_EventReg_Resellers
        FOREIGN KEY (ResellersKey)
        REFERENCES wscpa_dw.dim_Firms (FirmsKey)
) ENGINE=InnoDB;
