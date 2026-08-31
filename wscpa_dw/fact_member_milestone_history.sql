CREATE TABLE wscpa_dw.fact_MemberMilestoneHistory
(
    MemberMilestoneHistoryKey   INT AUTO_INCREMENT PRIMARY KEY,
    MembersKey                     INT NOT NULL,
    MilestonesKey                     INT NOT NULL,
    DuesYearsKey                        INT NOT NULL,
    MilestoneDatesKey                     INT NOT NULL,
    MemberID                                VARCHAR(20),
    CONSTRAINT FK_MMH_Members
        FOREIGN KEY (MembersKey)
        REFERENCES wscpa_dw.dim_Individuals (IndividualsKey),
    CONSTRAINT FK_MMH_Milestones
        FOREIGN KEY (MilestonesKey)
        REFERENCES wscpa_dw.dim_Milestones (MilestonesKey),
    CONSTRAINT FK_MMH_DuesYears
        FOREIGN KEY (DuesYearsKey)
        REFERENCES wscpa_dw.dim_DuesYears (DuesYearsKey),
    CONSTRAINT FK_MMH_MilestoneDates
        FOREIGN KEY (MilestoneDatesKey)
        REFERENCES wscpa_dw.dim_Dates (DatesKey)
) ENGINE=InnoDB;
