CREATE TABLE wscpa_dw.fact_EventFeeBilling
(
    EventFeeBillingKey         INT AUTO_INCREMENT PRIMARY KEY,
    RegistrantsKey                INT NOT NULL,
    EventsKey                       INT NOT NULL,
    TransactionDatesKey                INT NOT NULL,
    TransactionTypesKey                  INT NULL,  -- FK -> dim_TransactionTypes (not in this batch)
    EventFeeTypesKey                       INT NULL,  -- FK -> dim_EventFeeTypes (not in this batch)
    GeneralLedgerAccountsKey                 INT NULL,  -- FK -> dim_GeneralLedgerAccounts (not in this batch)
    RegistrantID                               VARCHAR(20),
    FeeAmount                                    DECIMAL(12,2) NOT NULL,
    MemberSavings                                  DECIMAL(12,2),
    CONSTRAINT FK_EFB_Registrants
        FOREIGN KEY (RegistrantsKey)
        REFERENCES wscpa_dw.dim_Individuals (IndividualsKey),
    CONSTRAINT FK_EFB_Events
        FOREIGN KEY (EventsKey)
        REFERENCES wscpa_dw.dim_Events (EventsKey),
    CONSTRAINT FK_EFB_TransactionDates
        FOREIGN KEY (TransactionDatesKey)
        REFERENCES wscpa_dw.dim_Dates (DatesKey)
) ENGINE=InnoDB;
