CREATE OR REPLACE TRIGGER trg_fraud_detection
AFTER INSERT
ON transaction_master
FOR EACH ROW
BEGIN
    fraud_scan;
END;
/
