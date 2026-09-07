ALTER TABLE wscpa_dw.dim_Individuals
    ADD CONSTRAINT FK_Individuals_Employers
    FOREIGN KEY (EmployersKey)
    REFERENCES wscpa_dw.dim_Firms (FirmsKey);
