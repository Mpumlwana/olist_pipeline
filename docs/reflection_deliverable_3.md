# 📝 Reflection - Deliverable 3: Cleaning the Data with SQL

## 🎯 What I Did
For this deliverable, I cleaned the 9 raw Olist tables with SQL and built a new `staging` schema. The `raw` tables stay untouched, so I can always go back to them. I did not clean blindly: I first looked at every table, decided what to fix, and only then wrote the fixes.

Before changing anything, I ran the same 4-question checklist on all 9 tables:
- 🔢 How many rows are there?
- 🔑 Are the ids unique?
- ❓ Where are the empty values (NULL)?
- 🔤 Which columns need a real type (date, whole number, decimal)?

I then completed these objectives:

- **🔍 Duplicates:** `orders` had none. `order_reviews` has 814 extra rows with a repeated `review_id`, but each one belongs to a different `order_id` (one review linked to several orders), so I kept them all. `geolocation` had 261,831 exact copies, and I kept one of each (1,000,163 rows down to 738,332).
- **🧩 Empty values and odd values:** I kept empty values where they are normal, for example empty delivery dates for orders that were never delivered, and empty review comments. I also found small oddities: 8 `delivered` orders with no delivery date, 6 `canceled` orders with a delivery date, 2 credit card payments with 0 installments, 9 payments of 0.00, 610 products with no category information, and 4 products with weight 0. I kept all of them as they are, because I do not know the real values and I did not want to invent any.
- **🌍 Wrong coordinates:** some `geolocation` points were outside Brazil, for example in Europe and the USA, while the city and state were Brazilian. 5 zip codes had no good row at all, so deleting the bad rows would have lost those zip codes. I kept the rows and set only their latitude and longitude to empty (NULL).
- **🔢 Real types:** in staging, dates became `timestamp`, whole numbers became `integer`, and money became `numeric`. Ids, names, codes and zip codes stay `text`, so zip codes keep their leading zeros.
- **🌐 Translations:** 2 product categories had no English name (`pc_gamer` and `portateis_cozinha_e_preparadores_de_alimentos`), so I added them by hand. The staging dictionary has 73 rows instead of 71.
- **✅ Checking the result:** I compared row counts between raw and staging for all 9 tables (only the dictionary and `geolocation` differ, on purpose). The price total (13,591,643.70) and the payment total (16,008,872.12) are identical in raw and staging, so no money was lost. I also calculated an average delivery time of about 12 days, which was not possible when the dates were text.

The result is 9 staging tables built by one script (`sql/04_create_staging_tables.sql`) that is safe to run many times, plus a check script (`sql/05_check_staging_counts.sql`).

## 💡 What I Learned
- ✅ The three layers: `raw` is the untouched copy, `staging` is the cleaned copy, and `warehouse` is the final shape for analysis. Each layer has one job, and I can go back to the previous one if I make a mistake.
- ✅ In data engineering I clean each table on its own first and join later. A join before cleaning can hide problems or repeat rows.
- ✅ A repeated id is not always a duplicate. I have to check what kind of repeat it is (exact copy, conflicting versions, or a link to different orders) before I remove anything.
- ✅ Odd data is not automatically wrong data. I look at it, count it, and decide with evidence. I only fixed values that are impossible, and I did not invent values.
- ✅ "No error" does not mean "correct". After every build I checked the types, the row counts, and the money totals.
- ✅ Looking at 5 rows (`LIMIT 5`) only shows the shape of a table. The real checks (`COUNT`, `GROUP BY`, `IS NULL`) read every row.

## 🧗 Challenges I Faced
- I was confused about whether I was only investigating one table, because I kept looking at the first 5 rows. I asked, and learned that the checks read the whole table, and that I would run the same checklist on all 9.
- My SQL file did not save in VS Code (it stayed at 640 bytes even after I pasted new text). I checked the size with `dir sql`, and fixed it by adding the text with `Add-Content` in PowerShell.
- Learning when a value is a real mistake and when it is only unusual, such as the coordinates outside Brazil compared with the 0.00 payments.

## 🛠️ Tools Used
`PostgreSQL 16` · `SQL` (`CREATE TABLE AS`, `CASE WHEN`, `DISTINCT`, `GROUP BY`, `NOT EXISTS`, type casting) · `Docker Compose` · `PowerShell` · `Git` · `GitHub` · `VS Code`

---
*Deliverable 3 of the Olist Data Pipeline project*