# inventory-abc-xyz-analysis

# Smart Inventory Optimization: ABC/XYZ Analysis (SQL)

## 📌 Executive Summary
In modern supply chain management, treating all materials equally leads to excessive capital tie-up and high stock-out risks for critical items. This project demonstrates a data-driven approach to inventory management using the **ABC/XYZ analysis matrix**, entirely engineered in **PostgreSQL**.

By classifying materials based on both their **financial value (ABC)** and **demand volatility (XYZ)**, this project provides actionable insights to optimize Safety Stock levels, align with Just-in-Time (JIT) principles, and reduce overall inventory holding costs.

## 🎯 Business Problems Solved
1. **Capital Allocation (ABC Analysis):** Identifying the 20% of materials that account for 80% of the inventory value (Pareto Principle) using Cumulative Sums and Running Totals.
2. **Demand Predictability (XYZ Analysis):** Measuring demand fluctuations over time using Standard Deviation and the Coefficient of Variation (CV).
3. **Safety Stock Strategy:** Differentiating procurement strategies—keeping high safety stocks for erratic items (Z-Class) while maintaining lean inventories for steady-demand items (X-Class).

## 🛠️ Tech Stack & Advanced SQL Techniques
* **Database:** PostgreSQL
* **Key SQL Concepts Implemented:**
  * **Window Functions:** Employed `SUM() OVER(ORDER BY ...)` to calculate running totals and cumulative percentages for Pareto classification.
  * **Statistical Functions:** Utilized `STDDEV()` and `AVG()` to calculate the Coefficient of Variation mathematically.
  * **Common Table Expressions (CTEs):** Structured complex, multi-step statistical calculations into readable and modular queries.
  * **Data Cleansing:** Used `COALESCE()` to handle `NULL` values during standard deviation calculations for low-volume items.
  * **Conditional Logic:** Advanced `CASE WHEN` statements to dynamically categorize materials into multi-dimensional classes (e.g., A-Class, Z-Class).

## 🗄️ Database Schema
* `materials`: Master data containing material codes, descriptions, and unit prices.
* `monthly_demand`: Historical consumption logs tracking the quantity of each material used per month.

## 📊 Business Insights & Methodology
* **ABC Classification (Value-Based):** Calculated cumulative value percentages. Items up to 80% of total value are A-Class (tight control), 80-95% are B-Class, and the rest are C-Class (bulk order).
* **XYZ Classification (Volatility-Based):** Calculated the Coefficient of Variation (CV = Standard Deviation / Mean). Items with CV ≤ 15% are X-Class (steady), up to 40% are Y-Class (fluctuating), and >40% are Z-Class (erratic).

## 🚀 Conclusion
This SQL pipeline replaces static spreadsheet forecasting with a dynamic, database-driven classification system. It empowers supply chain planners to instantly identify which materials require urgent procurement attention and which can be automated, ultimately freeing up working capital.
