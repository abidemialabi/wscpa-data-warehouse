DROP PROCEDURE IF EXISTS wscpa_dw.sp_load_fact_event_fee_payments;

DELIMITER $$

CREATE PROCEDURE wscpa_dw.sp_load_fact_event_fee_payments()
BEGIN

    DELETE FROM wscpa_dw.fact_EventFeePayments;

    INSERT INTO wscpa_dw.fact_EventFeePayments
    (
        RegistrantsKey,
        EventsKey,
        TransactionTypesKey,
        TransactionDatesKey,
        PaymentMethodsKey,
        GeneralLedgerAccountsKey,
        RegistrantID,
        FeePaymentAmount
    )
    SELECT
        CAST(registrants_key AS SIGNED),
        CAST(events_key AS SIGNED),
        CAST(transaction_types_key AS SIGNED),
        CAST(transaction_dates_key AS SIGNED),
        CAST(payment_methods_key AS SIGNED),
        CAST(general_ledger_accounts_key AS SIGNED),
        CAST(registrant_id AS CHAR(20)),
        CAST(fee_payment_amount AS DECIMAL(12,2))
    FROM wscpa_amnet.staging_event_fee_payments;

END$$

DELIMITER ;
