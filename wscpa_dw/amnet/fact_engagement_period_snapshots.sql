CREATE TABLE wscpa_dw.fact_EngagementPeriodSnapshots
(
    EngagementPeriodSnapshotsKey  INT AUTO_INCREMENT PRIMARY KEY,
    IndividualsKey                    INT NOT NULL,
    MonthsKey                            INT NOT NULL,
    EngagementPeriodBeginDate               DATE,
    EngagementPeriodEndDate                   DATE,
    EngagementScore                             DECIMAL(9,2),
    EPAge                                         INT,
    EPAgeBracket                                    VARCHAR(10),
    EPContributionCount                               INT,
    EPCommitteeMembershipCount                          INT,
    EPCommitteeAttendanceCount                            INT,
    EPEventRegistrationCount                                INT,
    EPProductSalesQuantity                                    INT,
    EPVolunteerAssignmentCount                                  INT,
    EPMembershipCount                                             INT,
    UNIQUE KEY UQ_EngagementPeriodSnapshots (IndividualsKey, MonthsKey),
    CONSTRAINT FK_EPSnap_Individuals
        FOREIGN KEY (IndividualsKey)
        REFERENCES wscpa_dw.dim_Individuals (IndividualsKey),
    CONSTRAINT FK_EPSnap_Months
        FOREIGN KEY (MonthsKey)
        REFERENCES wscpa_dw.dim_Months (MonthsKey)
) ENGINE=InnoDB;
