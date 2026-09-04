DROP PROCEDURE IF EXISTS wscpa_dw.sp_load_dim_event_sessions;

DELIMITER $$

CREATE PROCEDURE wscpa_dw.sp_load_dim_event_sessions()
BEGIN

    DELETE FROM wscpa_dw.dim_EventSessions;

    INSERT INTO wscpa_dw.dim_EventSessions
    (
        EventSessionsKey,
        EventCodeYr,
        SessionDate,
        SessionCode,
        SessionDescription,
        SessionScope,
        SessionType,
        SessionStatus,
        SessionTrack,
        YellowBookSessionYN,
        AttestAndCompilationSessionYN,
        CertifiedFinancialPlannerSessionYN,
        SessionFieldsOfStudyList,
        SessionTopicsList
    )
    SELECT
        CAST(event_sessions_key AS SIGNED),
        CAST(event_codeyr AS CHAR(10)),
        CAST(session_date AS DATE),
        CAST(session_code AS CHAR(3)),
        CAST(session_description AS CHAR(150)),
        CAST(session_scope AS CHAR(16)),
        CAST(session_type AS CHAR(20)),
        CAST(session_status AS CHAR(50)),
        CAST(session_track AS CHAR(50)),
        CAST(yellowbook_session_yn AS CHAR(3)),
        CAST(attest_and_compilation_session_yn AS CHAR(3)),
        CAST(certified_financial_planner_session_yn AS CHAR(3)),
        CAST(session_fields_of_study_list AS CHAR),
        CAST(session_topics_list AS CHAR)
    FROM wscpa_amnet.staging_event_sessions;

END$$

DELIMITER ;
