DROP PROCEDURE IF EXISTS wscpa_dw.sp_load_fact_event_fee_billing;

DELIMITER $$

CREATE PROCEDURE wscpa_dw.sp_load_fact_event_fee_billing()
BEGIN

    DELETE FROM wscpa_dw.fact_EventFeeBilling;

    INSERT INTO wscpa_dw.fact_EventFeeBilling
    (
        RegistrantsKey,
        EventsKey,
        TransactionDatesKey,
        TransactionTypesKey,
        EventFeeTypesKey,
        GeneralLedgerAccountsKey,
        RegistrantID,
        FeeAmount,
        MemberSavings
    )
    SELECT
        CAST(registrants_key AS SIGNED),
        CAST(events_key AS SIGNED),
        CAST(transaction_dates_key AS SIGNED),
        CAST(transaction_types_key AS SIGNED),
        CAST(event_fee_types_key AS SIGNED),
        CAST(general_ledger_accounts_key AS SIGNED),
        CAST(registrant_id AS CHAR(20)),
        CAST(fee_amount AS DECIMAL(12,2)),
        CAST(member_savings AS DECIMAL(12,2))
    FROM wscpa_amnet.staging_event_fee_billing;

END$$

DELIMITER ;
