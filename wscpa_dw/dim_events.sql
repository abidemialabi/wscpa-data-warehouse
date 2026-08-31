CREATE TABLE wscpa_dw.dim_Events
(
    EventsKey                       INT AUTO_INCREMENT PRIMARY KEY,
    EventsCustomInformationKey        INT NULL,  -- outrigger, out of scope for this batch
    BeginDatesKey                       INT NULL,
    EndDatesKey                           INT NULL,
    AccountingCloseDatesKey                 INT NULL,
    FacilitiesKey                             INT NULL,  -- role-playing FK -> dim_Firms
    PrimaryVendorsKey                           INT NULL,  -- role-playing FK -> dim_Firms
    PrimaryAdministratorsKey                      INT NULL,  -- role-playing FK -> dim_Individuals
    StaffContactsKey                                INT NULL,  -- role-playing FK -> dim_Individuals
    EventCodeYr                                       CHAR(10),
    EventCode1                                          CHAR(8),
    EventCode2                                            CHAR(8),
    EventName                                               VARCHAR(75),
    ExtendedEventTitle                                        VARCHAR(149),
    EventStatus                                                 VARCHAR(50),
    CancellationDate                                              DATE,
    EventHasSessionsYN                                              VARCHAR(3),
    UniqueEventYN                                                     VARCHAR(3),
    NewEventYN                                                          VARCHAR(3),
    ExcludeFromCatalogYN                                                  VARCHAR(3),
    EventScope                                                              VARCHAR(15),
    EventLevel                                                                VARCHAR(50),
    EventCity                                                                   VARCHAR(50),
    EventCompany                                                                  VARCHAR(50),
    EventDivision                                                                   VARCHAR(50),
    EventGLAccount                                                                    CHAR(14),
    NationalAcronym                                                                     CHAR(8),
    YellowbookEventYN                                                                     VARCHAR(3),
    AttestAndCompilationEventYN                                                             VARCHAR(3),
    CertifiedFinancialPlannerEventYN                                                          VARCHAR(3),
    NASBACertifiedEventYN                                                                       VARCHAR(3),
    EventVendorCode1                                                                              CHAR(100),
    EventVendorCode2                                                                                CHAR(100),
    EventFieldsOfStudyList                                                                            TEXT,
    EventFieldsOfInterestList                                                                           TEXT,
    EventFormatsList                                                                                      TEXT,
    EventTopicsList                                                                                         TEXT,
    UNIQUE KEY UQ_dim_Events_EventCodeYr (EventCodeYr),
    CONSTRAINT FK_Events_BeginDates
        FOREIGN KEY (BeginDatesKey)
        REFERENCES wscpa_dw.dim_Dates (DatesKey),
    CONSTRAINT FK_Events_EndDates
        FOREIGN KEY (EndDatesKey)
        REFERENCES wscpa_dw.dim_Dates (DatesKey),
    CONSTRAINT FK_Events_AccountingCloseDates
        FOREIGN KEY (AccountingCloseDatesKey)
        REFERENCES wscpa_dw.dim_Dates (DatesKey),
    CONSTRAINT FK_Events_Facilities
        FOREIGN KEY (FacilitiesKey)
        REFERENCES wscpa_dw.dim_Firms (FirmsKey),
    CONSTRAINT FK_Events_PrimaryVendors
        FOREIGN KEY (PrimaryVendorsKey)
        REFERENCES wscpa_dw.dim_Firms (FirmsKey),
    CONSTRAINT FK_Events_PrimaryAdministrators
        FOREIGN KEY (PrimaryAdministratorsKey)
        REFERENCES wscpa_dw.dim_Individuals (IndividualsKey),
    CONSTRAINT FK_Events_StaffContacts
        FOREIGN KEY (StaffContactsKey)
        REFERENCES wscpa_dw.dim_Individuals (IndividualsKey)
) ENGINE=InnoDB;
