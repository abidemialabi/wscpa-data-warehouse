CREATE TABLE wscpa_dw.dim_MemberStatusChangeReasons
(
    MemberStatusChangeReasonsKey  INT AUTO_INCREMENT PRIMARY KEY,
    MemberStatusChangeReason         VARCHAR(20)  -- No Change, New, Rejoined, Reinstated, Terminated, Deceased, Suspended, Resigned, Other
) ENGINE=InnoDB;
