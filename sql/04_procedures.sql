-- =========================
-- 4. AUDIT LOG PROCEDURE
-- =========================

CREATE OR REPLACE PROCEDURE audit_log(
p_process VARCHAR2,
p_message VARCHAR2)
AS
BEGIN
    INSERT INTO fraud_audit_log
    VALUES(seq_audit.NEXTVAL,p_process,p_message,SYSDATE);
    COMMIT;
END;
/

-- =========================
-- 5. ALERT PROCEDURE
-- =========================

CREATE OR REPLACE PROCEDURE create_alert(
p_customer_id NUMBER,
p_txn_id NUMBER,
p_alert_type VARCHAR2,
p_risk_score NUMBER)
AS
BEGIN
    INSERT INTO fraud_alerts
    VALUES(
        seq_alert.NEXTVAL,
        p_customer_id,
        p_txn_id,
        p_alert_type,
        p_risk_score,
        SYSDATE,
        'OPEN'
    );

    audit_log('ALERT',p_alert_type);
END;
/

-- =========================
-- 6. BLOCK CUSTOMER
-- =========================

CREATE OR REPLACE PROCEDURE block_customer(
p_customer_id NUMBER)
AS
BEGIN
    UPDATE customer
    SET account_status='BLOCKED'
    WHERE customer_id=p_customer_id;

    audit_log('AUTO_BLOCK',
              'Customer Blocked : '||p_customer_id);

    COMMIT;
END;
/

-- =========================
-- 7. FRAUD SCAN ENGINE
-- =========================

CREATE OR REPLACE PROCEDURE fraud_scan
AS
    CURSOR c_txn IS
    SELECT *
    FROM transaction_master
    WHERE txn_time >= SYSDATE - (1/24);

    v_avg NUMBER;
    v_score NUMBER;
BEGIN

FOR r IN c_txn LOOP

    v_score := 0;

    SELECT AVG(txn_amount)
    INTO v_avg
    FROM transaction_master
    WHERE customer_id = r.customer_id;

    IF r.txn_amount > NVL(v_avg,0)*3 THEN
        v_score := v_score + 30;

        create_alert(
            r.customer_id,
            r.txn_id,
            'HIGH_VALUE_TXN',
            30
        );
    END IF;

    IF TO_NUMBER(TO_CHAR(r.txn_time,'HH24'))
       BETWEEN 1 AND 4 THEN

       v_score := v_score + 10;

       create_alert(
            r.customer_id,
            r.txn_id,
            'MIDNIGHT_TXN',
            10
       );
    END IF;

    MERGE INTO customer_risk_profile c
    USING (
       SELECT r.customer_id customer_id
       FROM dual
    ) d
    ON (c.customer_id=d.customer_id)

    WHEN MATCHED THEN
       UPDATE SET
       total_risk_score =
       NVL(total_risk_score,0)+v_score,
       last_updated = SYSDATE

    WHEN NOT MATCHED THEN
       INSERT(
           customer_id,
           total_risk_score,
           risk_level,
           last_updated
       )
       VALUES(
           r.customer_id,
           v_score,
           'MEDIUM',
           SYSDATE
       );

    IF v_score > 80 THEN
       block_customer(r.customer_id);
    END IF;

END LOOP;

END;
/
