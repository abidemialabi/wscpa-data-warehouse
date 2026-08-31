CREATE TABLE wscpa_dw.fact_EventFeePayments
(
    EventFeePaymentsKey         INT AUTO_INCREMENT PRIMARY KEY,
    RegistrantsKey                 INT NOT NULL,
    EventsKey                        INT NOT NULL,
    TransactionTypesKey                INT NULL,  -- FK -> dim_TransactionTypes (not in this batch)
    TransactionDatesKey                  INT NOT NULL,
    PaymentMethodsKey                      INT NULL,  -- FK -> dim_PaymentMethods (not in this batch)
    GeneralLedgerAccountsKey                 INT NULL,  -- FK -> dim_GeneralLedgerAccounts (not in this batch)
    RegistrantID                               VARCHAR(20),
    FeePaymentAmount                             DECIMAL(12,2) NOT NULL,
    CONSTRAINT FK_EFP_Registrants
        FOREIGN KEY (RegistrantsKey)
        REFERENCES wscpa_dw.dim_Individuals (IndividualsKey),
    CONSTRAINT FK_EFP_Events
        FOREIGN KEY (EventsKey)
        REFERENCES wscpa_dw.dim_Events (EventsKey),
    CONSTRAINT FK_EFP_TransactionDates
        FOREIGN KEY (TransactionDatesKey)
        REFERENCES wscpa_dw.dim_Dates (DatesKey)
) ENGINE=InnoDB;
