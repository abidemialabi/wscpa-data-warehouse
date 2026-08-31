CREATE TABLE wscpa_dw.fact_CalendarMonthIndividualSnapshots
(
    CalendarMonthIndividualSnapshotsKey  INT AUTO_INCREMENT PRIMARY KEY,
    MonthsKey                               INT NOT NULL,
    IndividualsKey                             INT NOT NULL,
    EmployersKey                                 INT NULL,
    PriorMonthIndividualsKey                       INT NULL,  -- role-playing self-FK: prior-period join
    PriorDuesYearIndividualsKey                      INT NULL,  -- role-playing self-FK: prior-dues-year join
    MemberStatusChangeReasonsKey                       INT NULL,
    IndividualID                                         VARCHAR(20),
    CMAge                                                  INT,
    CMAgeBracket                                             VARCHAR(10),
    CMMemberChangeCount                                        INT,
    CMMemberStatusChangeCount                                    INT,
    CMBillingClassChangeCount                                      INT,
    CMMonthsCertified                                                INT,
    CMCreditHoursEarned                                                DECIMAL(6,2),
    CMDuesGrossBillingTotal                                              DECIMAL(12,2),
    CMDuesAdjustmentsTotal                                                 DECIMAL(12,2),
    CMDuesNetBillingTotal                                                    DECIMAL(12,2),
    CMDuesGrossPaymentsTotal                                                   DECIMAL(12,2),
    CMDuesRefundsTotal                                                           DECIMAL(12,2),
    CMDuesNetPaymentsTotal                                                         DECIMAL(12,2),
    CMContributionTotal                                                              DECIMAL(12,2),
    CMContributionCount                                                                INT,
    CMCommitteeMembershipCount                                                           INT,
    CMCommitteeAttendanceCount                                                             INT,
    CMEventFeeTotal                                                                          DECIMAL(12,2),
    CMEventPaymentTotal                                                                        DECIMAL(12,2),
    CMEventRegistrationCount                                                                     INT,
    CMEventAttendanceCount                                                                         INT,
    CMProductSalesQuantity                                                                           INT,
    CMProductExtendedNetPriceTotal                                                                     DECIMAL(12,2),
    CMProductExtendedItemCostTotal                                                                       DECIMAL(12,2),
    CMProductMargin                                                                                        DECIMAL(12,2),
    CMVolunteerAssignmentCount                                                                               INT,
    UNIQUE KEY UQ_CMIndividualSnapshots (MonthsKey, IndividualsKey),
    CONSTRAINT FK_CMIndivSnap_Months
        FOREIGN KEY (MonthsKey)
        REFERENCES wscpa_dw.dim_Months (MonthsKey),
    CONSTRAINT FK_CMIndivSnap_Individuals
        FOREIGN KEY (IndividualsKey)
        REFERENCES wscpa_dw.dim_Individuals (IndividualsKey),
    CONSTRAINT FK_CMIndivSnap_Employers
        FOREIGN KEY (EmployersKey)
        REFERENCES wscpa_dw.dim_Firms (FirmsKey),
    CONSTRAINT FK_CMIndivSnap_PriorMonth
        FOREIGN KEY (PriorMonthIndividualsKey)
        REFERENCES wscpa_dw.dim_Individuals (IndividualsKey),
    CONSTRAINT FK_CMIndivSnap_PriorDuesYear
        FOREIGN KEY (PriorDuesYearIndividualsKey)
        REFERENCES wscpa_dw.dim_Individuals (IndividualsKey),
    CONSTRAINT FK_CMIndivSnap_ChangeReasons
        FOREIGN KEY (MemberStatusChangeReasonsKey)
        REFERENCES wscpa_dw.dim_MemberStatusChangeReasons (MemberStatusChangeReasonsKey)
) ENGINE=InnoDB;
