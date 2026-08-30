CREATE TABLE wscpa_dw.fact_CPEBankIndividualSnapshots
(
    CPEBankIndividualSnapshotsKey  INT AUTO_INCREMENT PRIMARY KEY,
    MembersKey                        INT NOT NULL,
    DuesYearsKey                         INT NOT NULL,
    BeginDatesKey                          INT NULL,
    EndDatesKey                              INT NULL,
    MemberID                                   VARCHAR(20),
    BankDollarsPurchased                         DECIMAL(12,2),
    BankDollarsUsed                                DECIMAL(12,2),
    BankDollarsBalance                               DECIMAL(12,2),
    BankHoursPurchased                                 DECIMAL(9,2),
    BankHoursUsed                                        DECIMAL(9,2),
    BankHoursRemaining                                     DECIMAL(9,2),
    BankActiveYN                                             VARCHAR(3),
    TotalRegistrationCost                                      DECIMAL(12,2),
    TotalMargin                                                  DECIMAL(12,2),
    UNIQUE KEY UQ_CPEBankIndividualSnapshots (MembersKey, DuesYearsKey),
    CONSTRAINT FK_CPEBankSnap_Members
        FOREIGN KEY (MembersKey)
        REFERENCES wscpa_dw.dim_Individuals (IndividualsKey),
    CONSTRAINT FK_CPEBankSnap_DuesYears
        FOREIGN KEY (DuesYearsKey)
        REFERENCES wscpa_dw.dim_DuesYears (DuesYearsKey),
    CONSTRAINT FK_CPEBankSnap_BeginDates
        FOREIGN KEY (BeginDatesKey)
        REFERENCES wscpa_dw.dim_Dates (DatesKey),
    CONSTRAINT FK_CPEBankSnap_EndDates
        FOREIGN KEY (EndDatesKey)
        REFERENCES wscpa_dw.dim_Dates (DatesKey)
) ENGINE=InnoDB;
