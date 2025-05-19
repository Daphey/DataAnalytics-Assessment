-- Assessment_Q2
WITH customer_monthly_txn AS (
    SELECT 
        owner_id,
        COUNT(*) / COUNT(DISTINCT DATE_FORMAT(transaction_date, '%Y-%m')) AS avg_txn_per_month
    FROM savings_savingsaccount
    WHERE transaction_date IS NOT NULL
    GROUP BY owner_id
),
categorized_customers AS (
    SELECT 
        owner_id,
        avg_txn_per_month,
        CASE 
            WHEN avg_txn_per_month >= 10 THEN 'High Frequency'
            WHEN avg_txn_per_month BETWEEN 3 AND 9 THEN 'Medium Frequency'
            ELSE 'Low Frequency'
        END AS frequency_category
    FROM customer_monthly_txn
)
SELECT 
    frequency_category,
    COUNT(*) AS customer_count,
    ROUND(AVG(avg_txn_per_month), 2) AS avg_transactions_per_month
FROM categorized_customers
GROUP BY frequency_category
ORDER BY FIELD(frequency_category, 'High Frequency', 'Medium Frequency', 'Low Frequency');
