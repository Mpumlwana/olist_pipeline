# 📝 Reflection - Deliverable 6: Final Polish

## 🎯 What I Did
For this deliverable, I made the whole pipeline run with one command, and I tested that it works from nothing. Before this, every step ran by hand, one command at a time.

I completed these objectives:

- **▶️ One script that runs everything:** `run_pipeline.ps1` takes every `.sql` file in the `sql` folder, in number order, and sends it into the database. It stops at the first error (`-v ON_ERROR_STOP=1` plus a check of the exit code), so later scripts never build tables from broken data.
- **🧪 A test on the existing database:** the first run proved that the pipeline is safe to run again. All 8 files ran, the counts matched, and the data checks showed 6 PASS and 1 WARN.
- **🗑️ A test from scratch:** I removed the container and the volume (`docker compose down -v`), started a new empty database, checked that it had 0 tables, and ran the pipeline again. It built everything from the CSV files and the scripts alone, with the same numbers as before.
- **🚀 A Quick Start in the README:** a list of steps so someone else can clone the project, add the CSV files, set a password, and run it.
- **🔒 A final check of the repository:** I looked at the files Git tracks to make sure `.env` and the CSV files are not in the public repository.

## 💡 What I Learned
- ✅ Running a pipeline again proves it is safe to repeat. Only a run on an empty database proves it can build everything from the start.
- ✅ A pipeline should stop at the first error, because a later step can build a wrong table that looks fine.
- ✅ The data lives in the Docker volume, and the CSV files and the scripts stay on my computer. That is why I can wipe the database and rebuild it. A real live database would never be wiped like this.
- ✅ I should look before I build: I checked that script 01 uses `IF NOT EXISTS` before relying on it in the runner.
- ✅ A README should let a stranger run the project, and it should never need my `.env` file.

## 🧗 Challenges I Faced
- I did not understand where the data was when I wiped the database. I asked, and learned that the rows are in the volume, while the CSV files, the scripts and GitHub are not touched.
- I was not sure whether the pipeline would work again after a first run. I tested both cases: on the existing database, and from an empty one.

## 🛠️ Tools Used
`PowerShell` · `Docker Compose` · `PostgreSQL 16` · `SQL` · `Git` · `GitHub` · `VS Code`

---
*Deliverable 6 of the Olist Data Pipeline project*