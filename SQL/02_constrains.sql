ALTER TABLE client
    ADD CONSTRAINT pk_client        PRIMARY KEY (client_id),
    ADD CONSTRAINT chk_client_bdate CHECK (birth_date > TO_DATE('01-01-1900','dd-mm-yyyy')),
    ADD CONSTRAINT chk_client_reg   CHECK (registration_date > birth_date);

ALTER TABLE policy
    ADD CONSTRAINT pk_policy        PRIMARY KEY (policy_id),
    ADD CONSTRAINT fk_policy_type   FOREIGN KEY (policy_type) REFERENCES policy_types (type_id),
    ADD CONSTRAINT fk_policy_client FOREIGN KEY (client_id)   REFERENCES client (client_id),
    ADD CONSTRAINT chk_policy_dates CHECK (start_date < end_date),
    ADD CONSTRAINT chk_policy_prem  CHECK (premium >= 0),
    ADD CONSTRAINT fk_policy_status FOREIGN KEY (status) REFERENCES policy_statuses (pstatus_id);

ALTER TABLE payment
    ADD CONSTRAINT pk_payment        PRIMARY KEY (payment_id),
    ADD CONSTRAINT fk_payment_policy FOREIGN KEY (policy_id) REFERENCES policy (policy_id),
    ADD CONSTRAINT chk_payment_amt   CHECK (amount >= 0),
    ADD CONSTRAINT fk_payment_status FOREIGN KEY (status) REFERENCES payment_statuses (status_id);

ALTER TABLE claim
    ADD CONSTRAINT pk_claim        PRIMARY KEY (claim_id),
    ADD CONSTRAINT fk_claim_policy FOREIGN KEY (policy_id) REFERENCES policy (policy_id),
    ADD CONSTRAINT fk_claim_type   FOREIGN KEY (claim_type) REFERENCES claim_types (type_id),
    ADD CONSTRAINT chk_claim_amt   CHECK (claim_amount >= 0),
    ADD CONSTRAINT fk_claim_status FOREIGN KEY (status) REFERENCES claim_statuses (status_id);