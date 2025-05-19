# DataAnalytics-Assessment
 
This repository contains my solutions to the SQL-based assessment for the Data Analyst role. The task involved querying a simulated financial database (`adashi_staging`) with tables that include savings, withdrawals, user data, and plans. The goal was to extract insights for different teams like marketing, finance, and operations.


## Part A - Per-Question Explanations

### 1. **Cross-Selling Opportunity: Identify Customers with Both Savings and Investment Plans**

**Objective:**  
Find customers who have **at least one funded savings plan** and **at least one funded investment plan**, and sort them by **total deposits**.

**Approach:**  
To identify users with both a funded savings plan and a funded investment plan, 
- I joined the savings_savingsaccount, plans_plan, and users_customuser tables.
- I then filtered for plans/accounts with an amount greater than zero and
- Grouped them by owner_id to count and sum their deposits.
- Then, I joined both savings and investment summaries back to the user table and computed the total deposits per customer.


### 2. **Transaction Frequency Segmentation**

**Objective:**  
Categorize customers into `High`, `Medium`, and `Low` frequency segments based on their **average monthly transaction volume**.

**Approach:**  
- I pulled transaction records from the `savings_savingsaccount` table.
- Using `TIMESTAMPDIFF`, I calculated the total number of months between the **earliest** and **latest** transaction per user.
- I divided total transactions by tenure in months to get the **average transactions per month**.
- Then, I used a `CASE` statement to assign frequency categories.
- Finally, I aggregated the result by category and calculated the average transactions per category.



### 3. **Account Inactivity Alert**

**Objective:**  
Identify savings or investment accounts with **no transactions in the past 365 days**.

**Approach:**  
- For savings, I checked the `transaction_date` column in `savings_savingsaccount`.
- For plans, I used the `last_charge_date` (or similar field) in `plans_plan`.
- I calculated the number of days since the last transaction using `DATEDIFF(CURRENT_DATE, last_transaction_date)`.
- I filtered out any account with a recent transaction within the past year.
- The output includes account type, owner, and how long they’ve been inactive.



### 4. **Customer Lifetime Value (CLV) Estimation**

**Objective:**  
Estimate CLV using a **simplified model**:
> CLV = (total_transactions / tenure_in_months) × 12 × avg_profit_per_transaction  
Assuming profit per transaction is **0.1%** of transaction value.

**Approach:**  
- I joined `users_customuser` and `savings_savingsaccount`.
- I calculated **tenure** as the number of months since the user signed up.
- I summed total transaction value and divided by tenure to get a monthly average.
- Then, I multiplied by 12 and 0.001 (0.1%) to estimate annualized CLV.
- Finally, I sorted customers by CLV to identify top-value users.



## Part B - Challenges & Solutions

### 1: MySQL Server Connection Loss  
While running a large `JOIN` query with filters and aggregations, I encountered:

'Error Code: 2013. Lost connection to MySQL server during query'

**My Solution:**

- I split the logic into Common Table Expressions (CTEs) for savings and investment summaries to simplify the final join.

- Ensured proper WHERE clause filtering before joining.


### 2: Complex Schema with Long Table Names
The schema involved large and complex table structures (savings_savingsaccount, withdrawals_withdrawal, etc.).

**My Solution:**

- I took extra time to understand each structure in order to effectively apply them in writing my queries.
-  Reviewed the schema documentation and relationships carefully before writing joins.
- I used AS aliases extensively to shorten and clarify query structure.

  
### 3: Some accounts didn’t have recent transaction_date entries, leading to NULLs.

**My Solution:**

- Used MAX(transaction_date) and filtered out NULLs safely.
- I also used DATEDIFF(CURRENT_DATE, last_transaction_date) to compute inactivity days, and included the type column to distinguish between savings and investments in the combined result.


### 4: Some users had tenure < 1 month or no transaction data, which led to divide-by-zero errors.

**My Solution:**

- Used GREATEST(tenure_months, 1) to ensure we never divide by zero.
- Filtered only users with at least one transaction.
- Rounded tenure months using TIMESTAMPDIFF(MONTH, date_joined, CURRENT_DATE) for consistency.


### 5: The transaction_date field had date formatting inconsistencies.

**My Solution::**
I used the DATE_FORMAT() function to standardize it to %Y-%m (month granularity) and ensured NULL-safe handling. Grouping by this normalized date ensured accurate monthly counts.
