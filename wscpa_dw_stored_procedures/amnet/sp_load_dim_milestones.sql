DROP PROCEDURE IF EXISTS wscpa_dw.sp_load_dim_milestones;

DELIMITER $$

CREATE PROCEDURE wscpa_dw.sp_load_dim_milestones()
BEGIN

    DELETE FROM wscpa_dw.dim_Milestones;

    INSERT INTO wscpa_dw.dim_Milestones
    (
        MilestonesKey,
        Milestone,
        BillingClassChange,
        OldBillingClass,
        NewBillingClass,
        MemberTypeChange,
        OldMemberType,
        NewMemberType
    )
    SELECT
        CAST(milestones_key AS SIGNED),
        CAST(milestone AS CHAR(50)),
        CAST(billing_class_change AS CHAR(200)),
        CAST(old_billing_class AS CHAR(50)),
        CAST(new_billing_class AS CHAR(50)),
        CAST(member_type_change AS CHAR(200)),
        CAST(old_member_type AS CHAR(50)),
        CAST(new_member_type AS CHAR(50))
    FROM wscpa_amnet.staging_milestones;

END$$

DELIMITER ;
