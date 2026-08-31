CREATE TABLE wscpa_dw.fact_CommitteeMeetingAttendance
(
    CommitteeMeetingAttendanceKey  INT AUTO_INCREMENT PRIMARY KEY,
    MembersKey                        INT NOT NULL,
    MeetingDatesKey                      INT NOT NULL,
    AttendanceStatusesKey                   INT NOT NULL,
    CommitteeMeetingsKey                      INT NULL,  -- FK -> dim_CommitteeMeetings (not in this batch)
    MemberID                                    VARCHAR(20),
    CONSTRAINT FK_CMA_Members
        FOREIGN KEY (MembersKey)
        REFERENCES wscpa_dw.dim_Individuals (IndividualsKey),
    CONSTRAINT FK_CMA_MeetingDates
        FOREIGN KEY (MeetingDatesKey)
        REFERENCES wscpa_dw.dim_Dates (DatesKey),
    CONSTRAINT FK_CMA_AttendanceStatuses
        FOREIGN KEY (AttendanceStatusesKey)
        REFERENCES wscpa_dw.dim_AttendanceStatuses (AttendanceStatusesKey)
) ENGINE=InnoDB;
