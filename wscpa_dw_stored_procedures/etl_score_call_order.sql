-- ETL call order for score tables
-- Run in this order so each score table is populated after its dependent source/dw tables are refreshed.

CALL wscpa_dw.sp_load_dw_member_events();
CALL wscpa_dw.sp_load_dw_member_committees();
CALL wscpa_dw.sp_load_dw_member_summary();
CALL wscpa_dw.sp_load_dw_breezio_users();
CALL wscpa_dw.sp_load_dw_breezio_posts();

CALL wscpa_dw.sp_load_dw_member_education_score();
CALL wscpa_dw.sp_load_dw_member_community_score();
CALL wscpa_dw.sp_load_dw_member_leadership_score();
