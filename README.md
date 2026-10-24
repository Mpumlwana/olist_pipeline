# 🛒 Olist Data Pipeline

Welcome! This repository contains my **data engineering project** built with the Olist Brazilian e-commerce dataset. It shows how to take raw CSV files and turn them into clean, trusted data ready for analysis.

## 👋 About This Project

Raw data is often messy. It has duplicates, wrong data types and missing values. This project builds a full pipeline that:

- 📥 Loads raw CSV files into **PostgreSQL**
- 🧹 Cleans the data with **SQL**
- ⭐ Builds a **star schema** (fact and dimension tables)
- ✅ Runs simple **data checks**, like "no duplicate orders"
- 🐳 Runs everything with **Docker**

## ✅ Deliverables Overview

| # | Deliverable | Status |
|---|-------------|--------|
| 1 | 🐳 Project setup, Docker and PostgreSQL | ✅ Done |
| 2 | 📥 Load raw data | ✅ Done |
| 3 | 🧹 Clean data with SQL | ✅ Done |
| 4 | ⭐ Star schema | ⬜ Not started |
| 5 | ✅ Data checks | ⬜ Not started |
| 6 | ✨ Final polish | ⬜ Not started |

## 🗂️ Project Structure

```
olist_pipeline/
│
├── data/                  # CSV files (not uploaded to GitHub)
├── sql/                   # SQL scripts, run in number order
│   ├── 01_create_raw_tables.sql
│   ├── 02_load_raw_data.sql
│   ├── 03_check_raw_counts.sql
│   ├── 04_create_staging_tables.sql
│   └── 05_check_staging_counts.sql
├── docs/                  # My reflections for each deliverable
├── docker-compose.yml     # Recipe that starts PostgreSQL
├── .env                   # Real password (not uploaded to GitHub)
├── .env.example           # Safe copy of .env with a fake password
├── .gitignore             # Files Git must ignore
└── README.md              # You are here
```

## 🛠️ Tools & Technologies

Git · GitHub · Docker · PostgreSQL 16 · SQL · Python

## 📘 Deliverable 1: What We Built and Why

### 🧰 Tools
- 🔀 **Git and GitHub**: save the history of the project and share it online.
- 🐳 **Docker**: runs PostgreSQL in a container, so it works the same on any computer.
- 🐘 **PostgreSQL 16**: the database that will hold all the Olist data.

### 📄 Files
| File | What it does |
|------|--------------|
| `docker-compose.yml` | The recipe that starts PostgreSQL |
| `.env` | Real settings and password (never saved in Git) |
| `.env.example` | A safe copy of `.env` with a fake password |
| `.gitignore` | Tells Git which files to ignore (`.env`, CSV files) |
| `data/` | Where the CSV files go |

### 💡 Key Ideas
- 📦 **Container**: a small, closed box that runs one program.
- 💾 **Volume**: a safe place where Docker keeps the database data, so it is not lost when the container stops.
- 🚪 **Port 5433**: the door to the database. It is locked to this computer with `127.0.0.1`.
- 🔐 **Secrets**: passwords live in `.env`, not on GitHub.

### ▶️ How to Run
1. Install Docker Desktop and start it (wait for "Engine running").
2. Copy `.env.example` to `.env` and set a password.
3. Run `docker compose up -d`.
4. Test it:
```
   docker exec -it olist_postgres psql -U olist_user -d olist -c "SELECT version();"
```

## 📘 Deliverable 2: Loading the Raw Data

### 🧰 What I Built
- 🗂️ Three schemas: `raw`, `staging` and `warehouse`.
- 📋 Nine tables in `raw`, one for each CSV file.
- 📥 SQL scripts that create the tables, load the data and check the counts.

### 📄 Files
| File | What it does |
|------|--------------|
| `sql/01_create_raw_tables.sql` | Creates the schemas and the 9 empty raw tables |
| `sql/02_load_raw_data.sql` | Empties the tables, then loads the 9 CSV files with `COPY` |
| `sql/03_check_raw_counts.sql` | Counts the rows in all 9 tables in one query |
| `docker-compose.yml` | Now also shares the `data` folder with the container |

### 💡 Key Ideas
- 📚 **Schema**: a section of the database, like a section of a library. `raw` holds the untouched copy of the CSV files.
- 🔤 **All raw columns are TEXT**: loading never fails on a strange value, and zip codes keep their leading zeros.
- 🚪 **Bind mount** (`./data:/data:ro`): a read-only door that lets the container see my CSV files.
- 🔁 **TRUNCATE before COPY**: running the load script twice never loads the data twice.
- ✅ **Check the load**: row counts in the database must match the original files.

### 📊 Rows Loaded
| Table | Rows |
|-------|------|
| `customers` | 99,441 |
| `geolocation` | 1,000,163 |
| `orders` | 99,441 |
| `order_items` | 112,650 |
| `order_payments` | 103,886 |
| `order_reviews` | 99,224 |
| `products` | 32,951 |
| `sellers` | 3,095 |
| `product_category_name_translation` | 71 |

### ▶️ How to Run
1. Download the 9 CSV files from Kaggle (link below) into the `data/` folder.
2. Make sure the container is running: `docker compose up -d`
3. Run the three scripts in order:
```
   Get-Content sql\01_create_raw_tables.sql | docker exec -i olist_postgres psql -U olist_user -d olist
   Get-Content sql\02_load_raw_data.sql | docker exec -i olist_postgres psql -U olist_user -d olist
   Get-Content sql\03_check_raw_counts.sql | docker exec -i olist_postgres psql -U olist_user -d olist
```

## 📘 Deliverable 3: Cleaning the Data with SQL

### 🧰 What I Built
- 🧹 Nine tables in the `staging` schema, one for each raw table. The `raw` tables are never changed.
- 🔍 I first checked every table with the same 4 questions: how many rows, are the ids unique, where are the empty values, and which columns need a real type.
- 📄 One script that builds all 9 staging tables, and one script that checks them.

### 📄 Files
| File | What it does |
|------|--------------|
| `sql/04_create_staging_tables.sql` | Builds the 9 staging tables from the raw tables |
| `sql/05_check_staging_counts.sql` | Compares the row counts of raw and staging for all 9 tables |

### 💡 Key Ideas
- 🥘 **Three layers**: `raw` is the untouched copy, `staging` is the cleaned copy, and `warehouse` (Deliverable 4) is the final shape for analysis.
- 🔢 **Real types in staging**: dates become `timestamp`, whole numbers become `integer`, money becomes `numeric`. Ids, names, codes and zip codes stay `text`.
- 🔍 **Look before you fix**: a repeated id is not always a duplicate, and odd data is not always wrong data. I checked each case before I changed anything.
- 🚫 **Never invent values**: odd values I could not explain were kept as they are, and only impossible values were fixed.
- 🔁 **Safe to run again**: each table is dropped and rebuilt, so the script gives the same result every time.

### 🧹 What I Fixed
| Table | Fix |
|-------|-----|
| `geolocation` | Kept one copy of each exact duplicate row (1,000,163 → 738,332) |
| `geolocation` | Points outside Brazil got empty latitude and longitude (the zip code, city and state stay) |
| `product_category_name_translation` | Added 2 missing English names by hand (71 → 73) |
| 5 tables | Changed text columns to `timestamp`, `integer` or `numeric` |

### 📊 Raw vs Staging Rows
| Table | Raw | Staging |
|-------|-----|---------|
| `customers` | 99,441 | 99,441 |
| `geolocation` | 1,000,163 | 738,332 |
| `orders` | 99,441 | 99,441 |
| `order_items` | 112,650 | 112,650 |
| `order_payments` | 103,886 | 103,886 |
| `order_reviews` | 99,224 | 99,224 |
| `products` | 32,951 | 32,951 |
| `sellers` | 3,095 | 3,095 |
| `product_category_name_translation` | 71 | 73 |

### ▶️ How to Run
1. Make sure the raw tables are loaded (Deliverable 2).
2. Build the staging tables, then check them:
```
   Get-Content sql\04_create_staging_tables.sql | docker exec -i olist_postgres psql -U olist_user -d olist
   Get-Content sql\05_check_staging_counts.sql | docker exec -i olist_postgres psql -U olist_user -d olist
```

## 📊 Dataset

**Source:** [Brazilian E-Commerce Public Dataset by Olist, on Kaggle](https://www.kaggle.com/datasets/olistbr/brazilian-ecommerce)

Real orders made at Olist, a Brazilian online marketplace. It has 9 related tables: orders, order items, customers, products, sellers, payments, reviews, geolocation and a category name translation.

## 📬 Connect With Me

Feel free to reach out if you would like to talk about this project!

**Lakhikhaya Mpumlwana** · [GitHub](https://github.com/Mpumlwana)

⭐ This repository is updated as each deliverable is completed.