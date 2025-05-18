-- USE assessment_db;
-- SHOW TABLES;
-- Question1
USE assessment_db;
USE assessment_db;

-- Solution to Question 1 users_customuser: 
SELECT 
    u.id AS owner_id,
    CONCAT(u.first_name, ' ', u.last_name) AS name,
    (SELECT COUNT(DISTINCT id) 
     FROM savings_savingsaccount 
     WHERE owner_id = u.id) AS savings_count,
    (SELECT COUNT(DISTINCT id) 
     FROM plans_plan 
     WHERE owner_id = u.id) AS investment_count,
    (SELECT SUM(confirmed_amount)/100 
     FROM savings_savingsaccount 
     WHERE owner_id = u.id) AS total_deposits
FROM 
    users_customuser u
WHERE
    -- Has at least one savings account
    EXISTS (SELECT 1 FROM savings_savingsaccount WHERE owner_id = u.id)
    AND
    -- Has at least one investment plan
    EXISTS (SELECT 1 FROM plans_plan WHERE owner_id = u.id)
ORDER BY 
    total_deposits DESC;