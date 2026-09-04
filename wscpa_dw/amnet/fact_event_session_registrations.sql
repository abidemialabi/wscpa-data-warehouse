CREATE TABLE wscpa_dw.fact_EventSessionRegistrations
(
    EventSessionRegistrationsKey  INT AUTO_INCREMENT PRIMARY KEY,
    RegistrantsKey                   INT NULL,
    GuestsKey                          INT NULL,  -- FK -> dim_Guests (not in this batch)
    EventsKey                            INT NOT NULL,
    EventSessionsKey                       INT NOT NULL,
    RegistrantID                             VARCHAR(20),
    CONSTRAINT FK_ESR_Registrants
        FOREIGN KEY (RegistrantsKey)
        REFERENCES wscpa_dw.dim_Individuals (IndividualsKey),
    CONSTRAINT FK_ESR_Events
        FOREIGN KEY (EventsKey)
        REFERENCES wscpa_dw.dim_Events (EventsKey),
    CONSTRAINT FK_ESR_EventSessions
        FOREIGN KEY (EventSessionsKey)
        REFERENCES wscpa_dw.dim_EventSessions (EventSessionsKey)
) ENGINE=InnoDB;
