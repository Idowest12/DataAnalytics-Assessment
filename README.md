# SQL Assessment Solutions

## Approach and Challenges

### Question 1: High-Value Customers with Multiple Products
**Approach**:
- Joined `users_customuser` with both `savings_savingsaccount` and `plans_plan` tables
- Used `COUNT(DISTINCT)` to identify customers with ≥1 savings account AND ≥1 investment plan
- Calculated total deposits by summing `confirmed_amount` (converted from kobo to currency)
- Sorted by highest deposit amounts

**Challenges**:
- Initially struggled with missing `is_regular_savings` and `is_a_fund` columns
- Resolved by using `EXISTS` clauses instead of direct column filters
- Added NULL handling with `COALESCE` for customers with no transactions

---

### Question 2: Transaction Frequency Analysis
**Approach**:
- Created CTE to count transactions per customer per month using `DATE_FORMAT(transaction_date, '%Y-%m-01')`
- Calculated average monthly transactions per customer
- Applied CASE statements to categorize:
  - High Frequency (≥10/month)
  - Medium Frequency (3-9/month)
  - Low Frequency (≤2/month)

**Challenges**:
- Date formatting required adjustments for MySQL (`DATE_FORMAT` instead of `DATE_TRUNC`)
- Initially miscounted transactions by not using `DISTINCT`
- Fixed by verifying raw data with `SELECT transaction_date FROM savings_savingsaccount LIMIT 10;`

---

### Question 3: Account Inactivity Alert
**Approach**:
- Combined savings and investment accounts using `UNION ALL`
- Calculated days since last transaction with `DATEDIFF(CURRENT_DATE, MAX(transaction_date))`
- Filtered for accounts with >365 days inactivity or no transactions
- Included account type labels for clarity

**Challenges**:
- Missing `is_active` column required alternative approach
- Resolved by assuming all accounts are active unless proven inactive
- Validated with test query using 30-day threshold first

---

### Question 4: Customer Lifetime Value (CLV) Estimation
**Approach**:
- Calculated tenure in months using `TIMESTAMPDIFF(MONTH, date_joined, CURRENT_DATE())`
- Counted all transactions per customer
- Applied formula:  
  `CLV = (transactions / tenure) * 12 * (0.1% of avg transaction value)`
- Used `GREATEST(tenure, 1)` to avoid division by zero

**Challenges**:
- Initially miscalculated profit by not converting kobo to currency (/100)
- Added `COALESCE` to handle NULL values for new customers
- Verified calculations with sample customers using `LIMIT 10`

## Lessons Learned
1. Always verify column names with `DESCRIBE table_name`
2. Test queries with small datasets first (`LIMIT 10`)
3. Document assumptions when exact requirements don't match schema
