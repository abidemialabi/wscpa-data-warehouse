CREATE TABLE wscpa_dw.fact_Contributions
(
    ContributionsKey            INT AUTO_INCREMENT PRIMARY KEY,
    ContributorPartyType          CHAR(1) NULL,
    ContributorIndividualsKey       INT NULL,
    ContributorFirmsKey               INT NULL,
    TransactionDatesKey                 INT NOT NULL,
    TransactionTypesKey                   INT NULL,  -- FK -> dim_TransactionTypes (not in this batch)
    PaymentMethodsKey                       INT NULL,  -- FK -> dim_PaymentMethods (not in this batch)
    ContributionTypesKey                      INT NULL,  -- FK -> dim_ContributionTypes (not in this batch)
    DuesYearsKey                                INT NULL,
    ContributorID                                 VARCHAR(20),
    ContributionAmount                              DECIMAL(12,2) NOT NULL,
    CONSTRAINT CK_Contributions_Contributor CHECK (
        (ContributorPartyType = 'I' AND ContributorIndividualsKey IS NOT NULL AND ContributorFirmsKey IS NULL) OR
        (ContributorPartyType = 'F' AND ContributorFirmsKey IS NOT NULL AND ContributorIndividualsKey IS NULL) OR
        (ContributorPartyType IS NULL AND ContributorIndividualsKey IS NULL AND ContributorFirmsKey IS NULL)
    ),
    CONSTRAINT FK_Contributions_ContributorIndividuals
        FOREIGN KEY (ContributorIndividualsKey)
        REFERENCES wscpa_dw.dim_Individuals (IndividualsKey),
    CONSTRAINT FK_Contributions_ContributorFirms
        FOREIGN KEY (ContributorFirmsKey)
        REFERENCES wscpa_dw.dim_Firms (FirmsKey),
    CONSTRAINT FK_Contributions_TransactionDates
        FOREIGN KEY (TransactionDatesKey)
        REFERENCES wscpa_dw.dim_Dates (DatesKey),
    CONSTRAINT FK_Contributions_DuesYears
        FOREIGN KEY (DuesYearsKey)
        REFERENCES wscpa_dw.dim_DuesYears (DuesYearsKey)
) ENGINE=InnoDB;
