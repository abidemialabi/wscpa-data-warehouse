CREATE TABLE wscpa_dw.dim_Milestones
(
    MilestonesKey        INT AUTO_INCREMENT PRIMARY KEY,
    Milestone               VARCHAR(50),
    BillingClassChange        VARCHAR(200),
    OldBillingClass             VARCHAR(50),
    NewBillingClass               VARCHAR(50),
    MemberTypeChange                VARCHAR(200),
    OldMemberType                     VARCHAR(50),
    NewMemberType                       VARCHAR(50)
) ENGINE=InnoDB;
