CREATE INDEX IX_Individuals_IndividualID
    ON wscpa_dw.dim_Individuals (IndividualID);

CREATE INDEX IX_Individuals_MemberStatus
    ON wscpa_dw.dim_Individuals (MemberStatus, MemberType);

CREATE INDEX IX_Firms_FirmCode
    ON wscpa_dw.dim_Firms (FirmCode);

CREATE INDEX IX_CreditHoursEarned_Members
    ON wscpa_dw.fact_CreditHoursEarned (MembersKey);

CREATE INDEX IX_EventRegistrations_Events
    ON wscpa_dw.fact_EventRegistrations (EventsKey);

CREATE INDEX IX_ProductSales_TransactionDates
    ON wscpa_dw.fact_ProductSales (TransactionDatesKey);

CREATE INDEX IX_Contributions_TransactionDates
    ON wscpa_dw.fact_Contributions (TransactionDatesKey);

CREATE INDEX IX_DuesYearIndivSnap_Individuals
    ON wscpa_dw.fact_DuesYearIndividualSnapshots (IndividualsKey);

CREATE INDEX IX_CMIndivSnap_Individuals
    ON wscpa_dw.fact_CalendarMonthIndividualSnapshots (IndividualsKey);

CREATE INDEX IX_EngagementPeriodSnap_Individuals
    ON wscpa_dw.fact_EngagementPeriodSnapshots (IndividualsKey);

CREATE INDEX IX_MemberMilestoneHistory_Members
    ON wscpa_dw.fact_MemberMilestoneHistory (MembersKey);

CREATE INDEX IX_LogHistory_LogEntryTypes
    ON wscpa_dw.fact_LogHistory (LogEntryTypesKey);
