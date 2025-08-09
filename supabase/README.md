# Supabase Local Backend

This folder contains the **local backend** for the Football_is_life app.
We use [Supabase CLI](https://supabase.com/docs/guides/cli) + Docker to run Postgres, Auth, and Studio locally.
Everything (schema, RLS policies, seeds, edge functions) lives in Git so we can develop locally and deploy to Supabase Cloud later.

---

## 📦 Prerequisites

### 1. Install [Homebrew](https://brew.sh/)
```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

### 2. Install Supabase CLI (via Homebrew)
```bash
brew update
brew install supabase/tap/supabase
```
Verify:
```bash
supabase --version
```

### 3. Install Docker Desktop
```bash
brew install --cask docker
open -a Docker
```
Wait until the whale icon in the menu bar stops saying "starting…"

## 🚀 First-time setup
From the repo root:
```bash
cd supabase        # go into backend folder
supabase init      # only if supabase/config.toml doesn't exist yet
supabase start     # spins up Postgres, Auth, Studio locally
```
You'll see output like:
```arduino
Started supabase local development setup.
API URL: http://localhost:54321
anon key: eyJhbGciOi...
```
Copy these values into your Flutter `.env.dev` file (see `env/` folder).

## 🗄 Database
Migrations live in `supabase/migrations/`.

Seed data lives in `supabase/seed.sql`.

Apply all migrations + seed:
```bash
supabase db reset
```
⚠ This drops and recreates the DB (dev only!).

## 🛠 Commands
Run local backend:
```bash
supabase start
```
Stop local backend:
```bash
supabase stop
```
Create a new migration:
```bash
supabase migration new <name>
```
Push all migrations to local DB:
```bash
supabase db push
```

## 🌐 Deploy to Supabase Cloud
Create a project in Supabase Dashboard (choose EU region if needed).

Link local CLI:
```bash
supabase link --project-ref <your-project-ref>
```
Push schema:
```bash
supabase db push
```
Deploy edge functions:
```bash
supabase functions deploy <function-name>
```

## 📂 Structure
```
supabase/
├── config.toml            # CLI config (local + linked projects)
├── migrations/            # SQL migrations (schema, RLS, etc.)
├── seed.sql               # Dev seed data
├── functions/             # Edge Functions (serverless API)
└── README.md              # This file
```
