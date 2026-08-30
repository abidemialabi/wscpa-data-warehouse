CREATE TABLE wscpa_dw.dim_Firms
(
    FirmsKey                        INT AUTO_INCREMENT PRIMARY KEY,
    FirmsCustomInformationKey         INT NULL,  -- outrigger, out of scope for this batch
    MainOfficesKey                     INT NULL,  -- self-referencing role-playing FK
    ExhibitorPrimaryContactsKey          INT NULL,
    ExhibitorEmergencyContactsKey          INT NULL,
    PersonsInChargeKey                       INT NULL,
    FirmCode                                   CHAR(5),
    FirmName                                     VARCHAR(75),
    FirmAddress                                    VARCHAR(37),
    FirmCity                                         VARCHAR(37),
    FirmState                                          CHAR(2),
    FirmZIP                                              CHAR(5),
    FirmZIPLatitude                                        DOUBLE,
    FirmZIPLongitude                                         DOUBLE,
    FirmZIPGeoLocation                                         POINT,
    FirmChapter                                                  VARCHAR(50),
    FirmCounty                                                     VARCHAR(50),
    FirmCountry                                                      VARCHAR(37),
    AICPANumber                                                        VARCHAR(12),
    ReviewBillingClass                                                   CHAR(3),
    GroupMembershipYN                                                      VARCHAR(3),
    GeneralBusinessType                                                      VARCHAR(50),
    SpecificBusinessType                                                       VARCHAR(50),
    EntityType                                                                   VARCHAR(50),
    FirstFirmContributionDate                                                      DATE,
    CompanyHeldPubliclyYN                                                            VARCHAR(3),
    PersonInCharge                                                                     VARCHAR(37),
    FirmPaysDuesYN                                                                       VARCHAR(3),
    RevenueRange                                                                           VARCHAR(50),
    ClientReferralStatus                                                                     VARCHAR(10),
    ClientReferralChapterList                                                                  TEXT,
    ClientReferralServiceList                                                                    TEXT,
    ClientReferralCityList                                                                         TEXT,
    ClientReferralIndustryList                                                                       TEXT,
    MediaCirculation                                                                                   INT,
    MediaFormat                                                                                          VARCHAR(50),
    MediaFrequency                                                                                         VARCHAR(50),
    MediaGeneralType                                                                                         VARCHAR(50),
    MediaSpecificType                                                                                          VARCHAR(50),
    ReviewStatus                                                                                               VARCHAR(50),
    ReviewDivision                                                                                               VARCHAR(50),
    ReviewLocation                                                                                                 VARCHAR(50),
    ReviewType                                                                                                       VARCHAR(50),
    ReviewSource                                                                                                       VARCHAR(50),
    LastReviewDate                                                                                                       DATE,
    NextReviewDate                                                                                                         DATE,
    ExhibitorYearExhibiting                                                                                                  CHAR(4),
    ExhibitorStatus                                                                                                            VARCHAR(50),
    ExhibitorProductTypesList                                                                                                    TEXT,
    ExhibitorTypesList                                                                                                             TEXT,
    ExhibitorOtherList                                                                                                              TEXT,
    FirmsRowEffectiveDate                                                                                                            DATETIME NOT NULL,
    FirmsRowExpirationDate                                                                                                             DATETIME,
    FirmsRowChangeReason                                                                                                                 TEXT,
    FirmsRowStatus                                                                                                                         VARCHAR(10),
    CONSTRAINT FK_Firms_MainOffices
        FOREIGN KEY (MainOfficesKey)
        REFERENCES wscpa_dw.dim_Firms (FirmsKey),
    CONSTRAINT FK_Firms_ExhibitorPrimaryContacts
        FOREIGN KEY (ExhibitorPrimaryContactsKey)
        REFERENCES wscpa_dw.dim_Individuals (IndividualsKey),
    CONSTRAINT FK_Firms_ExhibitorEmergencyContacts
        FOREIGN KEY (ExhibitorEmergencyContactsKey)
        REFERENCES wscpa_dw.dim_Individuals (IndividualsKey),
    CONSTRAINT FK_Firms_PersonsInCharge
        FOREIGN KEY (PersonsInChargeKey)
        REFERENCES wscpa_dw.dim_Individuals (IndividualsKey)
) ENGINE=InnoDB;

ALTER TABLE wscpa_dw.dim_Individuals
    ADD CONSTRAINT FK_Individuals_Employers
    FOREIGN KEY (EmployersKey)
    REFERENCES wscpa_dw.dim_Firms (FirmsKey);

CREATE INDEX IX_Firms_FirmCode
    ON wscpa_dw.dim_Firms (FirmCode);
