# 📝 Reflection - Deliverable 4: Building the Star Schema

## 🎯 What I Did
For this deliverable, I turned the cleaned `staging` tables into a star schema in the `warehouse` schema. A star schema has one **fact table** in the middle (the numbers we add up) and **dimension tables** around it (the descriptions: who, what, when). This makes questions easy to answer, because we start in the middle and hop to one description table.

Before building the fact table, I checked that every id had a partner:
- 🔗 Every item has an order, a product and a seller.
- 👤 Every order has a customer.
- 📦 775 orders have no items at all (603 `unavailable`, 164 `canceled`, and 8 others), so they have no rows in the fact table. They are not deleted: they stay in `staging.orders`.

I then completed these objectives:

- **🧱 Dimensions:** I built `dim_sellers` (3,095 rows), `dim_customers` (99,441 rows), `dim_products` (32,951 rows) and `dim_dates` (1,096 rows). Each one has a primary key, so no row can appear twice.
- **🌐 Product categories:** in `dim_products` I joined the English category names with a `LEFT JOIN`, so the 610 products with no category stayed in the table. Every product that has a category now has an English name, because of the 2 translations I added in Deliverable 3. I also fixed the spelling of `lenght` to `length` here.
- **📅 Calendar:** I created one row for every day from 2016-01-01 to 2018-12-31, with the year, quarter, month, weekday and a weekend flag. Every order's purchase day has a row in it.
- **⭐ Fact table:** `fact_order_items` has one row for each item inside an order (112,650 rows). It holds the ids that point to the dimensions, plus the price and the freight value.
- **✅ Checking the result:** the price total (13,591,643.70) and the freight total (2,251,909.54) are identical in the fact table and in staging, so the join repeated and lost nothing. No fact row points to a missing customer, product, seller or day. I also asked the star a real question, "which categories earn the most?", and it answered with a simple join (`health_beauty` was first).

I left `geolocation` out of the star on purpose: it has about 52 map points for each zip code, so joining it would repeat customers and make the totals wrong. Customers and sellers keep their zip code, city and state.

The result is 5 warehouse tables built by one script (`sql/06_create_warehouse_tables.sql`) that is safe to run many times, plus a check script (`sql/07_check_warehouse_counts.sql`).

## 💡 What I Learned
- ✅ The difference between a fact table (the numbers, one row for each item) and dimension tables (the descriptions).
- ✅ The "grain" of a table: I must decide what one row means before building it, because a wrong grain gives wrong totals without any error.
- ✅ `LEFT JOIN` keeps every row from the left table, so I used it when some rows have no match (products with no category). A plain `JOIN` is fine when I have checked that every row has a match.
- ✅ A primary key is a safety check: if a join repeated a row, the table would fail to build.
- ✅ Before joining, I check that every id has a partner, so I know nothing will be silently lost.
- ✅ Leaving something out can be the right decision, as with `geolocation`, as long as I write down why.

## 🧗 Challenges I Faced
- I was confused about whether I had created all the dimension tables. I learned that writing the recipe in the SQL file is not the same as running it, and that a table exists only after the script runs.
- Deciding what to do with the 775 orders that have no items. I looked at their statuses first: most were `unavailable` or `canceled`, so I kept them out of the fact table and did not delete anything.

## 🛠️ Tools Used
`PostgreSQL 16` · `SQL` (`CREATE TABLE AS`, `LEFT JOIN`, `generate_series`, `PRIMARY KEY`, `NOT EXISTS`) · `Docker Compose` · `PowerShell` · `Git` · `GitHub` · `VS Code`

---
*Deliverable 4 of the Olist Data Pipeline project*