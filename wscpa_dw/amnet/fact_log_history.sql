CREATE TABLE wscpa_dw.fact_LogHistory
(
    LogHistoryKey               INT AUTO_INCREMENT PRIMARY KEY,
    ContactPartyType               CHAR(1) NULL,
    ContactIndividualsKey            INT NULL,
    ContactFirmsKey                    INT NULL,
    LogEntryTypesKey                     INT NOT NULL,
    AddDatesKey                            INT NOT NULL,
    FollowUpDatesKey                         INT NULL,
    ContactID                                  VARCHAR(20),
    LogEntryNote                                 VARCHAR(500),
    LogEntryMemo                                   LONGTEXT,
    CONSTRAINT CK_LogHistory_Contact CHECK (
        (ContactPartyType = 'I' AND ContactIndividualsKey IS NOT NULL AND ContactFirmsKey IS NULL) OR
        (ContactPartyType = 'F' AND ContactFirmsKey IS NOT NULL AND ContactIndividualsKey IS NULL) OR
        (ContactPartyType IS NULL AND ContactIndividualsKey IS NULL AND ContactFirmsKey IS NULL)
    ),
    CONSTRAINT FK_LogHistory_ContactIndividuals
        FOREIGN KEY (ContactIndividualsKey)
        REFERENCES wscpa_dw.dim_Individuals (IndividualsKey),
    CONSTRAINT FK_LogHistory_ContactFirms
        FOREIGN KEY (ContactFirmsKey)
        REFERENCES wscpa_dw.dim_Firms (FirmsKey),
    CONSTRAINT FK_LogHistory_LogEntryTypes
        FOREIGN KEY (LogEntryTypesKey)
        REFERENCES wscpa_dw.dim_LogEntryTypes (LogEntryTypesKey),
    CONSTRAINT FK_LogHistory_AddDates
        FOREIGN KEY (AddDatesKey)
        REFERENCES wscpa_dw.dim_Dates (DatesKey),
    CONSTRAINT FK_LogHistory_FollowUpDates
        FOREIGN KEY (FollowUpDatesKey)
        REFERENCES wscpa_dw.dim_Dates (DatesKey)
) ENGINE=InnoDB;
