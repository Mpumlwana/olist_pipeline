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
| 2 | 📥 Load raw data | ⬜ Not started |
| 3 | 🧹 Clean data with SQL | ⬜ Not started |
| 4 | ⭐ Star schema | ⬜ Not started |
| 5 | ✅ Data checks | ⬜ Not started |
| 6 | ✨ Final polish | ⬜ Not started |

## 🗂️ Project Structure

```
olist_pipeline/
│
├── data/                  # CSV files (not uploaded to GitHub)
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
| `data/` | Where the CSV files will go |

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

## 📊 Dataset

**Source:** [Brazilian E-Commerce Public Dataset by Olist, on Kaggle](https://www.kaggle.com/datasets/olistbr/brazilian-ecommerce)

Real orders made at Olist, a Brazilian online marketplace. It has several related tables: orders, customers, products, sellers, payments and reviews.

## 📬 Connect With Me

Feel free to reach out if you would like to talk about this project!

**Lakhikhaya Mpumlwana** · [GitHub](https://github.com/Mpumlwana)

⭐ This repository is updated as each deliverable is completed.
