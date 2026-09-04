CREATE TABLE wscpa_dw.fact_ProductSales
(
    ProductSalesKey              INT AUTO_INCREMENT PRIMARY KEY,
    OrdersKey                       INT NULL,  -- FK -> dim_Orders (not in this batch)
    ProductsKey                        INT NOT NULL,
    PurchaserPartyType                    CHAR(1) NULL,
    PurchaserIndividualsKey                  INT NULL,
    PurchaserFirmsKey                          INT NULL,
    TransactionDatesKey                          INT NOT NULL,
    EventsKey                                      INT NULL,
    GeneralLedgerAccountsKey                         INT NULL,  -- FK -> dim_GeneralLedgerAccounts (not in this batch)
    InvoiceNumber                                      VARCHAR(20),
    CreditMemoNumber                                     VARCHAR(20),
    PurchaserID                                            VARCHAR(20),
    Quantity                                                 INT,
    ExtendedNetPrice                                           DECIMAL(12,2),
    ExtendedItemCost                                             DECIMAL(12,2),
    Margin                                                         DECIMAL(12,2),
    StateTax                                                         DECIMAL(12,2),
    LocalTax                                                           DECIMAL(12,2),
    ShippingFee                                                          DECIMAL(12,2),
    MemberSavings                                                          DECIMAL(12,2),
    CONSTRAINT CK_ProductSales_Purchaser CHECK (
        (PurchaserPartyType = 'I' AND PurchaserIndividualsKey IS NOT NULL AND PurchaserFirmsKey IS NULL) OR
        (PurchaserPartyType = 'F' AND PurchaserFirmsKey IS NOT NULL AND PurchaserIndividualsKey IS NULL) OR
        (PurchaserPartyType IS NULL AND PurchaserIndividualsKey IS NULL AND PurchaserFirmsKey IS NULL)
    ),
    CONSTRAINT FK_ProductSales_Products
        FOREIGN KEY (ProductsKey)
        REFERENCES wscpa_dw.dim_Products (ProductsKey),
    CONSTRAINT FK_ProductSales_PurchaserIndividuals
        FOREIGN KEY (PurchaserIndividualsKey)
        REFERENCES wscpa_dw.dim_Individuals (IndividualsKey),
    CONSTRAINT FK_ProductSales_PurchaserFirms
        FOREIGN KEY (PurchaserFirmsKey)
        REFERENCES wscpa_dw.dim_Firms (FirmsKey),
    CONSTRAINT FK_ProductSales_TransactionDates
        FOREIGN KEY (TransactionDatesKey)
        REFERENCES wscpa_dw.dim_Dates (DatesKey),
    CONSTRAINT FK_ProductSales_Events
        FOREIGN KEY (EventsKey)
        REFERENCES wscpa_dw.dim_Events (EventsKey)
) ENGINE=InnoDB;
