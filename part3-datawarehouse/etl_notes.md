ETL Decisions:

When inspecting the raw `retail_transactions.csv` file, it was clear that pushing the data directly into a reporting warehouse would cause our analytical queries to fail or return inaccurate group totals. Here are the three main transformations I applied during the ETL pipeline before loading the final tables:

### Decision 1 — Standardizing Date Formats
Problem: The raw file had dates all over the place. Some were recorded as 'MM/DD/YYYY', others as 'DD-MM-YY', and a few even had text like 'Jan 15th 2024'. If left like this, the database wouldn't be able to group sales by month properly.
Resolution: I parsed all incoming date strings into a standard ISO format (`YYYY-MM-DD`). To make querying faster and easier, I generated a `dim_date` table that acts as a calendar. I mapped every transaction to an integer `date_id` (like `20240115`) which allows us to quickly filter by month, quarter, or year without writing messy date-extraction functions in our SQL queries.

### Decision 2 — Handling NULL Values in Quantitative Fields
Problem: Several rows in the raw data were missing the `quantity_sold` value (they were completely NULL), even though they had a valid `unit_price`. Leaving them as NULL breaks aggregate functions like `SUM()` and throws off our total revenue calculations.
Resolution: I implemented a data quality rule during the extraction phase. If a row was missing the quantity but had the other details, I imputed the `quantity_sold` as `1` (assuming a default single-item purchase). Alternatively, if the entire row was mostly NULLs or missing critical identifiers like `product_id`, I dropped the row entirely into an error log, ensuring only complete, calculable rows made it into the `fact_sales` table.

### Decision 3 — Fixing Inconsistent Category Casing
Problem: Product categories were entered manually by different people, leading to wildly inconsistent text formatting. For example, the same category appeared as 'electronics', 'ELECTRONICS', and 'Electronics'. A SQL `GROUP BY` clause treats these as three separate categories, which would completely ruin our category-wise revenue reports.
Resolution: I added a string transformation step in the pipeline that applied a `Title Case` (or proper case) function to the `category` column. Every variation was standardized to 'Electronics', 'Apparel', etc., before being inserted into the `dim_product` table. This guarantees that our reporting dashboards will aggregate the totals perfectly under single, unified category names.
