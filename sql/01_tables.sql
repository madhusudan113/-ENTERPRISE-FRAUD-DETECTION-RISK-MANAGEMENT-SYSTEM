
CREATE TABLE customer(
    customer_id NUMBER PRIMARY KEY,
    customer_name VARCHAR2(100),
    mobile_no VARCHAR2(15),
    email VARCHAR2(100),
    account_status VARCHAR2(20),
    created_date DATE
);

CREATE TABLE device(
    device_id NUMBER PRIMARY KEY,
    customer_id NUMBER,
    device_name VARCHAR2(100),
    device_type VARCHAR2(50),
    last_login_time DATE,
    CONSTRAINT fk_device_customer
    FOREIGN KEY(customer_id) REFERENCES customer(customer_id)
);

CREATE TABLE location(
    location_id NUMBER PRIMARY KEY,
    city VARCHAR2(100),
    state_name VARCHAR2(100),
    country_name VARCHAR2(100)
);

CREATE TABLE merchant(
    merchant_id NUMBER PRIMARY KEY,
    merchant_name VARCHAR2(100),
    merchant_type VARCHAR2(50)
);

CREATE TABLE login_history(
    login_id NUMBER PRIMARY KEY,
    customer_id NUMBER,
    device_id NUMBER,
    location_id NUMBER,
    login_time DATE,
    FOREIGN KEY(customer_id) REFERENCES customer(customer_id),
    FOREIGN KEY(device_id) REFERENCES device(device_id),
    FOREIGN KEY(location_id) REFERENCES location(location_id)
);

CREATE TABLE transaction_master(
    txn_id NUMBER PRIMARY KEY,
    customer_id NUMBER,
    txn_amount NUMBER(12,2),
    txn_type VARCHAR2(30),
    location_id NUMBER,
    device_id NUMBER,
    merchant_id NUMBER,
    txn_time DATE,
    txn_status VARCHAR2(20),
    FOREIGN KEY(customer_id) REFERENCES customer(customer_id),
    FOREIGN KEY(location_id) REFERENCES location(location_id),
    FOREIGN KEY(device_id) REFERENCES device(device_id),
    FOREIGN KEY(merchant_id) REFERENCES merchant(merchant_id)
);

CREATE TABLE fraud_alerts(
    alert_id NUMBER PRIMARY KEY,
    customer_id NUMBER,
    txn_id NUMBER,
    alert_type VARCHAR2(100),
    risk_score NUMBER,
    alert_time DATE,
    status VARCHAR2(20)
);

CREATE TABLE customer_risk_profile(
    customer_id NUMBER PRIMARY KEY,
    total_risk_score NUMBER,
    risk_level VARCHAR2(20),
    last_updated DATE
);

CREATE TABLE blacklisted_devices(
    device_id NUMBER PRIMARY KEY,
    reason VARCHAR2(200),
    blocked_date DATE
);

CREATE TABLE failed_login_attempts(
    attempt_id NUMBER PRIMARY KEY,
    customer_id NUMBER,
    device_id NUMBER,
    attempt_time DATE,
    failure_reason VARCHAR2(200)
);

CREATE TABLE fraud_investigation(
    investigation_id NUMBER PRIMARY KEY,
    alert_id NUMBER,
    investigator_name VARCHAR2(100),
    investigation_status VARCHAR2(30),
    remarks VARCHAR2(500),
    investigation_date DATE
);

CREATE TABLE fraud_audit_log(
    log_id NUMBER PRIMARY KEY,
    process_name VARCHAR2(100),
    log_message VARCHAR2(500),
    log_time DATE
);
