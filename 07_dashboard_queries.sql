-- Top Risk Customers
SELECT *
FROM customer_risk_profile
ORDER BY total_risk_score DESC;

-- Critical Customers
SELECT *
FROM customer_risk_profile
WHERE risk_level='CRITICAL';

-- Daily Fraud Count
SELECT TRUNC(alert_time),
       COUNT(*)
FROM fraud_alerts
GROUP BY TRUNC(alert_time);

-- Fraud Trend
SELECT TRUNC(alert_time),
       COUNT(*)
FROM fraud_alerts
GROUP BY TRUNC(alert_time)
ORDER BY 1;

-- Blocked Accounts
SELECT *
FROM customer
WHERE account_status='BLOCKED';
