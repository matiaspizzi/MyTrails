![Ruby](https://img.shields.io/badge/ruby-%23CC342D.svg?style=for-the-badge&logo=ruby&logoColor=white)
![Rails](https://img.shields.io/badge/rails-%23CC0000.svg?style=for-the-badge&logo=ruby-on-rails&logoColor=white)
![PostgreSQL](https://img.shields.io/badge/postgresql-%23316192.svg?style=for-the-badge&logo=postgresql&logoColor=white)
![TailwindCSS](https://img.shields.io/badge/tailwindcss-%2338B2AC.svg?style=for-the-badge&logo=tailwind-css&logoColor=white)
![Docker](https://img.shields.io/badge/docker-%230db7ed.svg?style=for-the-badge&logo=docker&logoColor=white)

# MyTrails

A goal-tracking web application where employees set and manage their objectives, leaders supervise progress and rate completed work, and administrators oversee the entire organization.

> Video demo: [youtube.com/watch?v=vPSpGtzMLvg](https://www.youtube.com/watch?v=vPSpGtzMLvg)

---

## Features

**As an employee** you can:
- Register and log in
- Create objectives with a title, description, and estimated completion date
- Track and update objective status (New / In Progress / In Review)
- Delete unrated objectives
- View your account and profile picture

**As a leader** you can:
- Everything an employee can do
- View and filter all objectives belonging to your assigned employees
- Rate completed objectives (1–5) and mark them as Done

**As an admin** you can:
- Everything a leader can do
- View all objectives across the organization
- Manage user roles
- Create leader–employee relationships

---

## Tech stack

| Layer | Technology |
|---|---|
| Backend | Ruby 3.x, Rails 8 |
| Frontend | Hotwire (Turbo + Stimulus), Tailwind CSS v3 |
| Database | PostgreSQL 16 |
| Asset pipeline | Propshaft + importmap |
| Background jobs | Solid Queue (in-process via Puma) |
| File uploads | Active Storage |
| Authorization | Pundit |
| Pagination | Pagy |
| Email (dev) | Mailtrap |
| Containerization | Docker + Docker Compose |

---

## Setup

### Requirements

- Ruby 3.x
- PostgreSQL 16 (local or via Docker)
- Bundler

### Environment variables

Copy `.env.example` to `.env` and fill in the values:

```bash
cp .env.example .env
```

| Variable | Description | Required |
|---|---|---|
| `POSTGRES_USER` | PostgreSQL username | Yes |
| `POSTGRES_PASSWORD` | PostgreSQL password | Yes |
| `POSTGRES_DB` | Database name | Yes (Docker) |
| `POSTGRES_HOST` | Database host | Yes (local) |
| `POSTGRES_PORT` | Database port (default `5432`) | Yes (local) |
| `SECRET_KEY_BASE` | Rails secret key (`bin/rails secret`) | Yes (prod) |
| `RAILS_ENV` | `development` / `production` | No (default: `development`) |
| `RAILS_MAX_THREADS` | Puma thread count | No (default: `5`) |
| `WEB_CONCURRENCY` | Puma worker count | No (default: `2`) |
| `SOLID_QUEUE_IN_PUMA` | Run jobs inside Puma | No (default: `true`) |
| `MAILTRAP_USERNAME` | Mailtrap SMTP username | No |
| `MAILTRAP_PASSWORD` | Mailtrap SMTP password | No |

---

### Option A — Local (without Docker)

> PostgreSQL must be running locally or in a separate container on port 5432.

```bash
# 1. Install dependencies
bundle install

# 2. Set env vars (or export them individually)
export POSTGRES_HOST=127.0.0.1
export POSTGRES_PORT=5432
export POSTGRES_USER=postgres
export POSTGRES_PASSWORD=postgres

# 3. Create, migrate and seed the database
bin/rails db:create db:migrate db:seed

# 4. Start the app
bin/rails server
bin/rails tailwindcss:watch
```

App available at `http://localhost:3000`.

---

### Option B — Docker Compose

```bash
# 1. Copy and fill in the env file
cp .env.example .env

# 2. Build and start all services
docker compose up --build
```

App available at `http://localhost:3000`.

To seed the database after the containers are up:

```bash
docker compose exec web bin/rails db:seed
```

To stop:

```bash
docker compose down
```

---

## Seed accounts

After running `db:seed`, the following accounts are available (all with password `password`):

| Email | Role |
|---|---|
| `admin@mytrails.dev` | Admin |
| `leader1@mytrails.dev` | Leader |
| `leader2@mytrails.dev` | Leader |
| `emp1@mytrails.dev` | Employee |
| `emp2@mytrails.dev` | Employee |
| `emp3@mytrails.dev` | Employee |
| `emp4@mytrails.dev` | Employee |
