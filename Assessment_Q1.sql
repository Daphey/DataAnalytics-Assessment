-- Savings Summary
WITH savings_summary AS (
    SELECT
        owner_id,
        COUNT(DISTINCT id) AS savings_count,
        SUM(amount) AS total_savings
    FROM
        savings_savingsaccount
    WHERE
        amount > 0
    GROUP BY
        owner_id
),

-- Investment Summary
investment_summary AS (
    SELECT
        owner_id,
        COUNT(DISTINCT id) AS investment_count,
        SUM(amount) AS total_investments
    FROM
        plans_plan
    WHERE
        amount > 0
    GROUP BY
        owner_id
)

-- Final Join with Users
SELECT
    u.id AS owner_id,
    u.name,
    ss.savings_count,
    isv.investment_count,
    ss.total_savings + isv.total_investments AS total_deposits
FROM
    users_customuser u
JOIN savings_summary ss ON u.id = ss.owner_id
JOIN investment_summary isv ON u.id = isv.owner_id
ORDER BY
    total_deposits DESC;