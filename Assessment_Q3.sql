USE assessment_db;
USE assessment_db;

-- Solution 3 to plans_plan:
SELECT 
    a.id AS account_id,
    a.owner_id,
    a.account_type,
    MAX(t.transaction_date) AS last_transaction_date,
    DATEDIFF(CURRENT_DATE, MAX(t.transaction_date)) AS inactivity_days
FROM (
    -- Combine all accounts (savings and investments)
    SELECT id, owner_id, 'Savings' AS account_type FROM savings_savingsaccount
    UNION ALL
    SELECT id, owner_id, 'Investment' AS account_type FROM plans_plan
) a
LEFT JOIN (
    -- Combine all transactions
    SELECT id AS account_id, owner_id, transaction_date FROM savings_savingsaccount
    UNION ALL
    SELECT plan_id AS account_id, owner_id, transaction_date FROM withdrawals_withdrawal
) t ON a.id = t.account_id AND a.owner_id = t.owner_id
GROUP BY 
    a.id, a.owner_id, a.account_type
HAVING 
    last_transaction_date IS NULL 
    OR inactivity_days > 365
ORDER BY 
    inactivity_days DESC;