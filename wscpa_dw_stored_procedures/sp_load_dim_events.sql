DROP PROCEDURE IF EXISTS wscpa_dw.sp_load_dim_events;

DELIMITER $$

CREATE PROCEDURE wscpa_dw.sp_load_dim_events()
BEGIN

    DELETE FROM wscpa_dw.dim_Events;

    INSERT INTO wscpa_dw.dim_Events
    (
        EventsKey,
        EventsCustomInformationKey,
        BeginDatesKey,
        EndDatesKey,
        AccountingCloseDatesKey,
        FacilitiesKey,
        PrimaryVendorsKey,
        PrimaryAdministratorsKey,
        StaffContactsKey,
        EventCodeYr,
        EventCode1,
        EventCode2,
        EventName,
        ExtendedEventTitle,
        EventStatus,
        CancellationDate,
        EventHasSessionsYN,
        UniqueEventYN,
        NewEventYN,
        ExcludeFromCatalogYN,
        EventScope,
        EventLevel,
        EventCity,
        EventCompany,
        EventDivision,
        EventGLAccount,
        NationalAcronym,
        YellowbookEventYN,
        AttestAndCompilationEventYN,
        CertifiedFinancialPlannerEventYN,
        NASBACertifiedEventYN,
        EventVendorCode1,
        EventVendorCode2,
        EventFieldsOfStudyList,
        EventFieldsOfInterestList,
        EventFormatsList,
        EventTopicsList
    )
    SELECT
        CAST(events_key AS SIGNED),
        CAST(events_custom_information_key AS SIGNED),
        CAST(begin_dates_key AS SIGNED),
        CAST(end_dates_key AS SIGNED),
        CAST(accounting_close_dates_key AS SIGNED),
        CAST(facilities_key AS SIGNED),
        CAST(primary_vendors_key AS SIGNED),
        CAST(primary_administrators_key AS SIGNED),
        CAST(staff_contacts_key AS SIGNED),
        CAST(event_codeyr AS CHAR(10)),
        CAST(event_code_1 AS CHAR(8)),
        CAST(event_code_2 AS CHAR(8)),
        CAST(event_name AS CHAR(75)),
        CAST(extended_event_title AS CHAR(149)),
        CAST(event_status AS CHAR(50)),
        CAST(cancellation_date AS DATE),
        CAST(event_has_sessions_yn AS CHAR(3)),
        CAST(unique_event_yn AS CHAR(3)),
        CAST(new_event_yn AS CHAR(3)),
        CAST(exclude_from_catalog_yn AS CHAR(3)),
        CAST(event_scope AS CHAR(15)),
        CAST(event_level AS CHAR(50)),
        CAST(event_city AS CHAR(50)),
        CAST(event_company AS CHAR(50)),
        CAST(event_division AS CHAR(50)),
        CAST(event_gl_account AS CHAR(14)),
        CAST(national_acronym AS CHAR(8)),
        CAST(yellowbook_event_yn AS CHAR(3)),
        CAST(attest_and_compilation_event_yn AS CHAR(3)),
        CAST(certified_financial_planner_event_yn AS CHAR(3)),
        CAST(nasba_certified_event_yn AS CHAR(3)),
        CAST(event_vendor_code_1 AS CHAR(100)),
        CAST(event_vendor_code_2 AS CHAR(100)),
        CAST(event_fields_of_study_list AS CHAR),
        CAST(event_fields_of_interest_list AS CHAR),
        CAST(event_formats_list AS CHAR),
        CAST(event_topics_list AS CHAR)
    FROM wscpa_amnet.staging_events;

END$$

DELIMITER ;
