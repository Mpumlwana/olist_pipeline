# 📝 Reflection - Deliverable 1: Project Setup, Docker and PostgreSQL

## 🎯 What I Did
For this deliverable, I built the foundation of the Olist data pipeline. This was my first data engineering project, so I started from zero: I set up the project folder, connected it to GitHub, and got a PostgreSQL database running inside Docker.

Before writing any project files, I checked that my tools worked:
- 🔍 Checked that Git and Docker were installed (Git 2.39.1, Docker 29.4.0)
- 🐳 Ran `docker run hello-world` to prove the Docker engine was really running
- 🧾 Set my Git name and email (using my GitHub no-reply email) so my commits are linked to my account

I then completed the core objectives of this deliverable:

- **📁 Project and GitHub:** created the project at `C:\projects\olist_pipeline` (outside OneDrive, to avoid file-locking problems with Git and Docker) and pushed it to a public GitHub repository.
- **🐳 Docker and PostgreSQL:** wrote a `docker-compose.yml` that runs PostgreSQL 16 in a container, with a volume so the data survives restarts.
- **🔒 Safety:** kept the real password in a `.env` file that is listed in `.gitignore`, and committed a `.env.example` with a fake password instead. I also locked the database port to my own computer (`127.0.0.1:5433`), so nobody else on the network can reach it.
- **✅ First query:** ran `SELECT version();` and got PostgreSQL 16.15, which proved the database was alive.

The result is a safe, repeatable place to put the Olist data, with my work saved on GitHub.

## 💡 What I Learned
- ✅ The difference between Git (saving versions on my computer) and GitHub (the online copy), and what `add`, `commit` and `push` each do.
- ✅ That Docker lets the same database run the same way on any computer, and that "Docker is installed" is not the same as "Docker is running".
- ✅ Why secrets like passwords must never go to GitHub, and how `.gitignore` and `.env.example` solve this.
- ✅ That a Docker volume keeps the database data even when the container is stopped.

## 🧗 Challenges I Faced
- Docker Desktop has to be started by hand each session. When it was closed, I got the error "failed to connect to the docker API". I learned to open Docker Desktop and wait for "Engine running" before running any Docker command.
- Being careful about the password: I checked `git status` many times to make sure `.env` never appeared in the files going to GitHub.

## 🛠️ Tools Used
`Git` · `GitHub` · `Docker` · `Docker Compose` · `PostgreSQL 16` · `PowerShell` · `VS Code`

---
*Deliverable 1 of the Olist Data Pipeline project*