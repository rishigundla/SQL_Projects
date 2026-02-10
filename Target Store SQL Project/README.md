# Target E-Commerce Data Analysis (Databricks SQL & Delta Lake)

## 📌 Project Overview

This project performs an end-to-end data analysis of Target's Brazilian e-commerce operations. Moving beyond traditional data warehousing, this project utilizes **Databricks SQL** to process 100k+ records, providing insights into logistics efficiency, pricing strategies, and payment behaviors.

## 🛠️ Tech Stack

* **Platform:** Databricks SQL Warehouse
* **Storage:** Delta Lake (Unity Catalog)
* **Language:** SQL

## 📊 Business Queries & Insights

### 1. Sales Seasonality & Peak Performance

Analyzed purchase timestamps to identify when Target experiences the highest load.

* **Peak Months:** August and May emerged as the highest-performing months.
* **Consumer Behavior:** Afternoon hours (13:00–17:00) see the highest transaction volume, suggesting optimal windows for flash sales.

### 2. Year-over-Year (YoY) Growth

Calculated the economic expansion of Target's Brazil footprint.

* **Insight:** Comparing the Jan–Aug window, there was a **136.98% increase** in total payment value from 2017 to 2018.

### 3. Logistics & Shipping Efficiency

Used `datediff()` and window functions to analyze the supply chain.

* **Delivery Speed:** Identified top 5 states with the fastest delivery times.
* **Freight Impact:** Analyzed the correlation between customer state and freight costs, identifying remote regions where shipping costs eat into profit margins.

### 4. Payment & Installment Trends

* **Credit Logic:** A significant portion of Brazilian customers utilize high installment counts (up to 24x) for higher-value items.
* **Method Diversity:** Tracked the monthly shift between Credit Cards, Boleto, and UPI/Voucher payments.

## 💡 Actionable Recommendations

1. **Inventory Pre-positioning:** Move high-demand inventory to distribution centers in states with the highest average delivery times before the August peak.
2. **Freight Subsidy:** Consider capping freight costs for states with high "Price-to-Freight" ratios to increase conversion rates in remote regions.
3. **Dynamic Pricing:** Implement afternoon-specific promotions to capitalize on peak shopping hours.

---

### 📂 Repository Structure

* `sql_queries/`: Contains scripts for Bronze, Silver, and Gold transformations.
* `dashboards/`: Screenshots of Databricks SQL Visualizations.
* `data/`: Documentation on the Target dataset schema.

**Would you like me to help you create a specific "Actionable Recommendations" summary for your final presentation?**
