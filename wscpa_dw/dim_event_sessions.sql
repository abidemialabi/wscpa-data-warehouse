CREATE TABLE wscpa_dw.dim_EventSessions
(
    EventSessionsKey                 INT AUTO_INCREMENT PRIMARY KEY,
    EventCodeYr                        CHAR(10),
    SessionDate                          DATE,
    SessionCode                            CHAR(3),
    SessionDescription                       VARCHAR(150),
    SessionScope                               VARCHAR(16),
    SessionType                                  VARCHAR(20),
    SessionStatus                                  VARCHAR(50),
    SessionTrack                                     VARCHAR(50),
    YellowBookSessionYN                                VARCHAR(3),
    AttestAndCompilationSessionYN                        VARCHAR(3),
    CertifiedFinancialPlannerSessionYN                     VARCHAR(3),
    SessionFieldsOfStudyList                                 TEXT,
    SessionTopicsList                                          TEXT,
    CONSTRAINT FK_EventSessions_Events
        FOREIGN KEY (EventCodeYr)
        REFERENCES wscpa_dw.dim_Events (EventCodeYr)
) ENGINE=InnoDB;
