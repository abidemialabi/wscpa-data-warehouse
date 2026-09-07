CREATE TABLE wscpa_dw.fact_VolunteerAssignments
(
    VolunteerAssignmentsKey     INT AUTO_INCREMENT PRIMARY KEY,
    VolunteerOpportunitiesKey      INT NULL,  -- FK -> dim_VolunteerOpportunities (not in this batch)
    VolunteersKey                     INT NOT NULL,
    FirmsKey                            INT NULL,
    BeginDatesKey                         INT NOT NULL,
    EndDatesKey                             INT NULL,
    VolunteerID                               VARCHAR(20),
    CONSTRAINT FK_VA_Volunteers
        FOREIGN KEY (VolunteersKey)
        REFERENCES wscpa_dw.dim_Individuals (IndividualsKey),
    CONSTRAINT FK_VA_Firms
        FOREIGN KEY (FirmsKey)
        REFERENCES wscpa_dw.dim_Firms (FirmsKey),
    CONSTRAINT FK_VA_BeginDates
        FOREIGN KEY (BeginDatesKey)
        REFERENCES wscpa_dw.dim_Dates (DatesKey),
    CONSTRAINT FK_VA_EndDates
        FOREIGN KEY (EndDatesKey)
        REFERENCES wscpa_dw.dim_Dates (DatesKey)
) ENGINE=InnoDB;
