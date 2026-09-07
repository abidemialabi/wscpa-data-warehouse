CREATE TABLE wscpa_dw.fact_DuesYearIndividualSnapshots
(
    DuesYearIndividualSnapshotsKey  INT AUTO_INCREMENT PRIMARY KEY,
    DuesYearsKey                       INT NOT NULL,
    IndividualsKey                        INT NOT NULL,
    EmployersKey                            INT NULL,
    PriorDuesYearIndividualsKey                INT NULL,  -- role-playing self-FK -> dim_Individuals
    MemberStatusChangeReasonsKey                 INT NULL,
    DuesBillingTypesKey                            INT NULL,  -- FK -> dim_DuesBillingTypes (not in this batch)
    IndividualID                                     VARCHAR(20),
    DYAge                                              INT,
    DYAgeBracket                                         VARCHAR(10),
    DYMemberChangeCount                                    INT,
    DYMemberStatusChangeCount                                INT,
    DYBillingClassChangeCount                                  INT,
    DYYearsCertified                                             INT,
    DYCreditHoursEarned                                            DECIMAL(6,2),
    DYBillingDate                                                    DATE,
    DYLastInvoiceDate                                                  DATE,
    DYLastPaymentDate                                                    DATE,
    DYDuesGrossBilling                                                     DECIMAL(12,2),
    DYDuesAdjustments                                                        DECIMAL(12,2),
    DYDuesNetBilling                                                           DECIMAL(12,2),
    DYDuesPayments                                                               DECIMAL(12,2),
    DYDuesRefunds                                                                  DECIMAL(12,2),
    DYDuesNetPayments                                                                DECIMAL(12,2),
    DYDuesBalance                                                                      DECIMAL(12,2),
    DYChapterDues                                                                        DECIMAL(12,2),
    DYContributionTotal                                                                    DECIMAL(12,2),
    DYContributionCount                                                                      INT,
    DYCommitteeMembershipCount                                                                 INT,
    DYCommitteeAttendanceCount                                                                   INT,
    DYEventFeeTotal                                                                                DECIMAL(12,2),
    DYEventPaymentTotal                                                                              DECIMAL(12,2),
    DYEventRegistrationCount                                                                           INT,
    DYEventAttendanceCount                                                                               INT,
    DYProductSalesQuantity                                                                               INT,
    DYProductExtendedNetPriceTotal                                                                         DECIMAL(12,2),
    DYProductExtendedItemCostTotal                                                                           DECIMAL(12,2),
    DYProductMargin                                                                                          DECIMAL(12,2),
    DYVolunteerAssignmentCount                                                                                 INT,
    DYConsecutiveYearsOfMembership                                                                               INT,
    DYCumulativeYearsOfMembership                                                                                  INT,
    UNIQUE KEY UQ_DYIndividualSnapshots (DuesYearsKey, IndividualsKey),
    CONSTRAINT FK_DYIndivSnap_DuesYears
        FOREIGN KEY (DuesYearsKey)
        REFERENCES wscpa_dw.dim_DuesYears (DuesYearsKey),
    CONSTRAINT FK_DYIndivSnap_Individuals
        FOREIGN KEY (IndividualsKey)
        REFERENCES wscpa_dw.dim_Individuals (IndividualsKey),
    CONSTRAINT FK_DYIndivSnap_Employers
        FOREIGN KEY (EmployersKey)
        REFERENCES wscpa_dw.dim_Firms (FirmsKey),
    CONSTRAINT FK_DYIndivSnap_PriorDuesYear
        FOREIGN KEY (PriorDuesYearIndividualsKey)
        REFERENCES wscpa_dw.dim_Individuals (IndividualsKey),
    CONSTRAINT FK_DYIndivSnap_ChangeReasons
        FOREIGN KEY (MemberStatusChangeReasonsKey)
        REFERENCES wscpa_dw.dim_MemberStatusChangeReasons (MemberStatusChangeReasonsKey)
) ENGINE=InnoDB;
