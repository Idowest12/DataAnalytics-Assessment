USE assessment_db;

-- Step 1: Calculate basic customer information Solution 3
SELECT 
    u.id AS customer_id,
    CONCAT(u.first_name, ' ', u.last_name) AS name,
    
    -- How many months since the customer joined
    TIMESTAMPDIFF(MONTH, u.date_joined, CURRENT_DATE()) AS months_as_customer,
    
    -- Count all transactions for this customer
    COUNT(s.id) AS total_transactions,
    
    -- Calculate average transaction amount (converted from kobo to currency)
    COALESCE(AVG(s.confirmed_amount)/100, 0) AS avg_transaction_amount,
    
    -- Calculate estimated CLV
    ROUND(
        (COUNT(s.id) / GREATEST(TIMESTAMPDIFF(MONTH, u.date_joined, CURRENT_DATE()), 1)) * -- Transactions per month
        12 *                                                                               -- Project to yearly
        (0.001 * COALESCE(AVG(s.confirmed_amount)/100, 0)),                                -- 0.1% profit per transaction
        2                                                                                  -- Round to 2 decimals
    ) AS estimated_clv
FROM 
    users_customuser u
LEFT JOIN 
    savings_savingsaccount s ON u.id = s.owner_id
WHERE
    -- Only include customers who joined more than 1 month ago
    TIMESTAMPDIFF(MONTH, u.date_joined, CURRENT_DATE()) > 0
GROUP BY 
    u.id, u.first_name, u.last_name, u.date_joined
ORDER BY 
    estimated_clv DESC;