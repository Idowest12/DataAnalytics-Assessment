USE assessment_db;
-- Solution to Question 2 savings_savingsaccount:: 
WITH monthly_transactions AS (
    -- Count transactions per customer per month
    SELECT 
        owner_id,
        DATE_FORMAT(transaction_date, '%Y-%m-01') AS month,
        COUNT(*) AS transactions_count
    FROM 
        savings_savingsaccount
    GROUP BY 
        owner_id, DATE_FORMAT(transaction_date, '%Y-%m-01')
),

customer_frequencies AS (
    -- Calculate average transactions per customer
    SELECT 
        owner_id,
        AVG(transactions_count) AS avg_monthly_transactions
    FROM 
        monthly_transactions
    GROUP BY 
        owner_id
)

-- Categorize and summarize results
SELECT 
    CASE 
        WHEN avg_monthly_transactions >= 10 THEN 'High Frequency'
        WHEN avg_monthly_transactions >= 3 THEN 'Medium Frequency'
        ELSE 'Low Frequency'
    END AS frequency_category,
    COUNT(*) AS customer_count,
    ROUND(AVG(avg_monthly_transactions), 1) AS avg_transactions_per_month
FROM 
    customer_frequencies
GROUP BY 
    frequency_category
ORDER BY 
    customer_count DESC;