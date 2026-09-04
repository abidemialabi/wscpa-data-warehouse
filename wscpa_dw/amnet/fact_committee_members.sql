CREATE TABLE wscpa_dw.fact_CommitteeMembers
(
    CommitteeMembersKey       INT AUTO_INCREMENT PRIMARY KEY,
    MembersKey                   INT NOT NULL,
    CommitteesKey                   INT NULL,  -- FK -> dim_Committees (not in this batch)
    CommitteePositionsKey              INT NULL,  -- FK -> dim_CommitteePositions (not in this batch)
    BeginDatesKey                        INT NOT NULL,
    EndDatesKey                            INT NULL,
    MemberID                                 VARCHAR(20),
    CONSTRAINT FK_CommMembers_Members
        FOREIGN KEY (MembersKey)
        REFERENCES wscpa_dw.dim_Individuals (IndividualsKey),
    CONSTRAINT FK_CommMembers_BeginDates
        FOREIGN KEY (BeginDatesKey)
        REFERENCES wscpa_dw.dim_Dates (DatesKey),
    CONSTRAINT FK_CommMembers_EndDates
        FOREIGN KEY (EndDatesKey)
        REFERENCES wscpa_dw.dim_Dates (DatesKey)
) ENGINE=InnoDB;
