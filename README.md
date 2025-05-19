# DataAnalytics-Assessment
 
This repository contains my solutions to the SQL-based assessment for the Data Analyst role. The task involved querying a simulated financial database (`adashi_staging`) with tables that include savings, withdrawals, user data, and plans. The goal was to extract insights for different teams like marketing, finance, and operations.


## Part A - Per-Question Explanations

### 1. **Cross-Selling Opportunity: Identify Customers with Both Savings and Investment Plans**

**Objective:**  
Find customers who have **at least one funded savings plan** and **at least one funded investment plan**, and sort them by **total deposits**.

**Approach:**  
- I joined the `users_customuser`, `savings_savingsaccount`, and `plans_plan` tables on the customer ID.
- I filtered for records with amounts greater than zero (to ensure they are funded).
- Then, I used `COUNT(DISTINCT ...)` to get savings and investment plan counts.
- I summed the deposit amounts and sorted the results.


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

- I broke the query down step by step. 
- Then I Ran intermediate joins and filters independently to optimize performance.
- Used LIMIT for previewing data before applying heavy aggregations.


### 2: Complex Schema with Long Table Names
The schema involved large and complex table structures (savings_savingsaccount, withdrawals_withdrawal, etc.).

**My Solution:**

- I took extra time to understand each structure in order to effectively apply them in writing my queries.
-  Reviewed the schema documentation and relationships carefully before writing joins.
- I used AS aliases extensively to shorten and clarify query structure.



