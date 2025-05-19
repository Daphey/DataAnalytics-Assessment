-- Assessment_Q3
-- Step 1: Get last transaction date for investment plans
SELECT 
    id AS plan_id,
    owner_id,
    'investment' AS type,
    MAX(last_charge_date) AS last_transaction_date,
    DATEDIFF(CURDATE(), MAX(last_charge_date)) AS inactivity_days
FROM plans_plan
WHERE last_charge_date IS NOT NULL
  AND is_deleted = 0
  AND is_archived = 0
GROUP BY id, owner_id
HAVING inactivity_days > 365

UNION ALL

-- Step 2: Get last transaction date for savings
SELECT 
    plan_id,
    owner_id,
    'savings' AS type,
    MAX(transaction_date) AS last_transaction_date,
    DATEDIFF(CURDATE(), MAX(transaction_date)) AS inactivity_days
FROM savings_savingsaccount
WHERE transaction_date IS NOT NULL
GROUP BY plan_id, owner_id
HAVING inactivity_days > 365;