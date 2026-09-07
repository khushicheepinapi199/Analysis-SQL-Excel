-- Financial Transaction Analysis
-- Dataset is synthetic and intended for portfolio demonstration only.

-- 1. High-value completed transactions
SELECT transaction_id, customer_id, transaction_datetime, transaction_type, amount_usd, transaction_country
FROM transactions
WHERE amount_usd >= 10000 AND status = 'Completed'
ORDER BY amount_usd DESC;

-- 2. Customer-level transaction summary
SELECT customer_id, COUNT(*) AS transaction_count,
       ROUND(SUM(amount_usd), 2) AS total_value_usd,
       ROUND(AVG(amount_usd), 2) AS average_transaction_usd,
       MAX(amount_usd) AS largest_transaction_usd
FROM transactions
WHERE status = 'Completed'
GROUP BY customer_id
ORDER BY total_value_usd DESC;

-- 3. Join customer profile and transaction activity
SELECT c.customer_id, c.customer_name, c.country AS customer_country, c.country_risk,
       COUNT(t.transaction_id) AS transaction_count,
       ROUND(SUM(CASE WHEN t.status = 'Completed' THEN t.amount_usd ELSE 0 END), 2) AS completed_value_usd
FROM customers c
LEFT JOIN transactions t ON c.customer_id = t.customer_id
GROUP BY c.customer_id, c.customer_name, c.country, c.country_risk
ORDER BY completed_value_usd DESC;

-- 4. Cross-border transactions
SELECT t.transaction_id, t.customer_id, c.country AS customer_country,
       t.transaction_country, t.amount_usd, t.transaction_datetime
FROM transactions t
JOIN customers c ON t.customer_id = c.customer_id
WHERE t.transaction_country <> c.country AND t.status = 'Completed'
ORDER BY t.amount_usd DESC;

-- 5. Simple review priority using CASE
SELECT t.transaction_id, t.customer_id, t.amount_usd, c.country_risk,
       CASE WHEN t.amount_usd >= 20000 THEN 'High'
            WHEN t.amount_usd >= 10000 OR c.country_risk = 'Medium' THEN 'Medium'
            ELSE 'Low' END AS review_priority
FROM transactions t
JOIN customers c ON t.customer_id = c.customer_id
WHERE t.status = 'Completed'
ORDER BY t.amount_usd DESC;

-- 6. Monthly transaction trend
SELECT SUBSTR(transaction_datetime, 1, 7) AS transaction_month,
       COUNT(*) AS transaction_count,
       ROUND(SUM(amount_usd), 2) AS transaction_value_usd
FROM transactions
WHERE status = 'Completed'
GROUP BY SUBSTR(transaction_datetime, 1, 7)
ORDER BY transaction_month;

-- 7. Rank customers by completed transaction value
WITH customer_totals AS (
    SELECT customer_id, SUM(amount_usd) AS total_value_usd
    FROM transactions
    WHERE status = 'Completed'
    GROUP BY customer_id
)
SELECT customer_id, ROUND(total_value_usd, 2) AS total_value_usd,
       RANK() OVER (ORDER BY total_value_usd DESC) AS value_rank
FROM customer_totals
ORDER BY value_rank;
