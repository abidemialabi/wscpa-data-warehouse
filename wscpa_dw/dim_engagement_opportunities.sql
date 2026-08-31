CREATE TABLE wscpa_dw.dim_EngagementOpportunities
(
    EngagementOpportunitiesKey  INT AUTO_INCREMENT PRIMARY KEY,
    EngagementType                 VARCHAR(50),   -- e.g., Committee, Event, Product, Contribution, Volunteer, Membership
    EngagementOpportunity            VARCHAR(150),
    EngagementCategory1                VARCHAR(50),
    EngagementCategory2                  VARCHAR(50)
) ENGINE=InnoDB;
