# 📝 Reflection - Deliverable 2: Loading the Raw Data

## 🎯 What I Did
For this deliverable, I worked with the Brazilian E-Commerce Public Dataset by Olist from Kaggle, which comes as 9 separate CSV files. I loaded all of them into PostgreSQL as an untouched "raw" copy, using SQL scripts so the whole process can be repeated.

Before loading anything, I:
- 🔍 Downloaded the 9 CSV files into a `data` folder and kept them out of Git with `.gitignore`
- 👀 Looked at the headers and first rows of every file to understand the columns
- ⚠️ Noticed some quirks: zip codes with leading zeros (like `01037`), a spelling mistake in a column name (`product_name_lenght`), and empty comment fields in the reviews

I then completed these objectives:

- **🗂️ Schemas and tables:** created three schemas (`raw`, `staging`, `warehouse`) and 9 tables in `raw`. Every raw column is TEXT, so loading never fails on a strange value and zip codes keep their leading zeros. I also kept the original column names, even the typo, so the raw layer stays a true copy.
- **🚪 Letting Docker see the files:** PostgreSQL runs inside a container and could not see my CSV files. I fixed this by adding a read-only bind mount (`./data:/data:ro`) to `docker-compose.yml`, and checked it by listing `/data` inside the container.
- **📥 Loading the data:** tested `COPY` on one table first (`customers`, 99,441 rows), then wrote a script with one `COPY` for each table. I put `TRUNCATE` at the top so running the script twice does not load the data twice.
- **✅ Checking the load:** compared the database count for `orders` with the line count of the original CSV (both 99,441), then wrote one `UNION ALL` query to count all 9 tables. Every number matched the `COPY` results.

The final result is 9 raw tables, with 1,000,163 rows in the biggest one (`geolocation`), all saved in three SQL scripts on GitHub.

## 💡 What I Learned
- ✅ That a database is organised like a library: schemas are sections, tables are shelves, columns are labels, and rows are books.
- ✅ Why the raw layer should stay untouched and be stored as TEXT: it is my safe copy to go back to, and cleaning belongs to the next step.
- ✅ That a container is separate from my computer, so I need a bind mount to share files with it, and `:ro` keeps my original files safe.
- ✅ That "no error" does not mean "correct": I should always verify a load by comparing counts. I also learned that counting lines in a CSV does not work for `order_reviews`, because some comments run over several lines.
- ✅ What idempotent means: a script that gives the same result however many times I run it.

## 🧗 Challenges I Faced
- My SQL file was saved with 0 bytes twice: once because I had not pasted the content, and once because my disk was full (`ENOSPC`). I fixed it by freeing disk space and by running `dir sql` after saving to check the file size. I had also accidentally created a nested `sql\sql\` folder, so I moved the file to the right place.
- Telling two Docker errors apart: "failed to connect to the docker API" means the engine is off (open Docker Desktop), while "container is not running" means the container stopped (run `docker compose up -d`).

## 🛠️ Tools Used
`PostgreSQL 16` · `SQL` (`CREATE TABLE`, `COPY`, `TRUNCATE`, `UNION ALL`) · `Docker Compose` · `PowerShell` · `Git` · `GitHub` · `VS Code`

---
*Deliverable 2 of the Olist Data Pipeline project*