# IA-TARA

IA-TARA is a web application for creating Threat Analysis and Risk Assessment projects. It lets users model a system, connect components and assets, define damage and threat scenarios, add attack steps and controls, calculate risks, choose risk treatment, and export a PDF report.

For the detailed project write-up and TARA background, see `documentation/main.pdf` or the LaTeX source in `documentation/main.tex`.

## Repository Layout

- `frontend/` - React, TypeScript, Vite, Tailwind, shadcn-style components, Zustand, and React Flow.
- `backend/` - Django REST Framework API with JWT auth, SQLite, risk calculation, MITRE endpoints, assistant integration, and PDF reports.
- `documentation/` - project report, user guide, screenshots, diagrams, and generated documentation PDF.

## Requirements

- Python 3.12 or newer
- Node.js 22 recommended
- npm
- Docker and Docker Compose, if using containers

## Quick Start

Start the backend:

```sh
cd backend
python -m venv .venv
source .venv/bin/activate
pip install -r requirements.txt
cd tp
python manage.py migrate
python manage.py runserver 0.0.0.0:8000
```

Start the frontend in another terminal:

```sh
cd frontend
npm ci
npm run dev
```

Open `http://localhost:5173`.

On the login screen, set the backend URL to `http://127.0.0.1:8000` or `http://localhost:8000`. Do not include `/api`.

## Docker

Run both services:

```sh
docker compose up --build
```

Then open:

- Frontend: `http://localhost:5173`
- Backend API: `http://localhost:8000/api/`
- Django admin: `http://localhost:8000/admin/`

Useful container commands:

```sh
docker compose exec backend python manage.py migrate
docker compose exec backend python manage.py createsuperuser
docker compose exec backend python manage.py test api
docker compose exec frontend npm run lint
docker compose exec frontend npm run build
```

The Docker setup is for development. It bind-mounts `frontend/` and `backend/`, keeps frontend dependencies in a Docker volume, and uses the Django development server with SQLite.

## Demo Credentials

The checked-in SQLite database contains demo users:

| Username | Password |
| --- | --- |
| `john_doe` | `pass1234` |
| `oliver` | `pass1234` |
| `richard` | `pass1234` |

These are normal application users, not Django admin users. Create an admin account with `python manage.py createsuperuser` if you need `/admin/`.

You can also create a new user from the login screen. For a fresh database, run:

```sh
cd backend/tp
python manage.py migrate
python manage.py seeddb
```

The seed command creates the same demo users and sample projects.

## Backend Development

The Django project is in `backend/tp`.

```sh
cd backend
source .venv/bin/activate
pip install -r requirements.txt
cd tp
python manage.py check
python manage.py test api
python manage.py makemigrations api
python manage.py migrate
```

The backend loads optional environment variables from:

- `backend/.env`
- `backend/tp/.env`

Start from:

```sh
cp backend/.env.example backend/.env
```

Assistant integration is optional:

```sh
ASSISTANT_API=
ASSISTANT_API_URL=
ASSISTANT_MODEL=
```

Leave these empty for normal local development without an external LLM provider.

## Frontend Development

The frontend app is in `frontend`.

```sh
cd frontend
npm ci
npm run dev
npm run lint
npm run build
```

The frontend sends API requests to `${backendUrl}/api`. The backend URL is selected on the login screen and stored in browser session storage.
