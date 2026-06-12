# IA-TARA

IA-TARA is a web application for creating Threat Analysis and Risk Assessment projects. It lets users model a system, connect components and assets, define damage and threat scenarios, add attack steps and controls, calculate risks, choose risk treatment, and export a PDF report.

For the detailed project write-up and TARA background, see `documentation/main.pdf` or the LaTeX source in `documentation/main.tex`. For a step-by-step usage guide, see [documentation/user_guide/program_guide.md](documentation/user_guide/program_guide.md).

## Repository Layout

- `frontend/` - React, TypeScript, Vite, Tailwind, shadcn-style components, Zustand, and React Flow.
- `backend/` - Django REST Framework API with JWT auth, SQLite, risk calculation, MITRE endpoints, assistant integration, and PDF reports.
- `documentation/` - project report, user guide, screenshots, diagrams, and generated documentation PDF.

## Requirements

- Python 3.12 or newer
- Node.js 22 recommended
- npm
- Docker and Docker Compose, if using the containerized app

## Run with Docker

The Docker setup builds the React frontend and serves it from the Django backend container. There is one app container and one named Docker volume for SQLite data.

```sh
docker compose up --build
```

Open `http://localhost:8000`.

Routes:

- React app: `http://localhost:8000/`
- Backend API: `http://localhost:8000/api/`
- Django admin: `http://localhost:8000/admin/`

Useful container commands:

```sh
docker compose exec app python manage.py migrate
docker compose exec app python manage.py createsuperuser
docker compose exec app python manage.py test api
```

The container starts by copying the checked-in demo database into the named SQLite volume if the volume is empty, then runs migrations. Remove the volume if you want to reset container data:

```sh
docker compose down -v
```

If you previously ran the old two-service Compose setup and port `8000` is still allocated, remove orphaned services:

```sh
docker compose down --remove-orphans
```

This container setup is suitable for local demos and review. For a real deployment, set a proper `DJANGO_SECRET_KEY`, restrict `DJANGO_ALLOWED_HOSTS`, and review the remaining Django security settings.

## Demo Credentials

The checked-in SQLite database contains demo users:

| Username | Password |
| --- | --- |
| `john_doe` | `pass1234` |
| `oliver` | `pass1234` |
| `richard` | `pass1234` |

These are normal application users, not Django admin users. Create an admin account with `python manage.py createsuperuser` if you need `/admin/`.

You can also create a new user from the login screen. For a fresh local database, run:

```sh
cd backend/tp
python manage.py migrate
python manage.py seeddb
```

## Local Development

For day-to-day development, run the backend and frontend separately. This keeps Django auto-reload and Vite hot reload.

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

Open `http://localhost:5173`. In Vite development, the frontend automatically calls the backend at `http://localhost:8000/api`.

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

Useful settings:

```sh
DJANGO_DEBUG=true
DJANGO_ALLOWED_HOSTS=localhost,127.0.0.1,0.0.0.0
DJANGO_SECRET_KEY=change-me-for-real-deployments
ASSISTANT_API=
ASSISTANT_API_URL=
ASSISTANT_MODEL=deepseek-chat
```

Leave the assistant values empty for normal local development without an external LLM provider.

## Frontend Development

The frontend app is in `frontend`.

```sh
cd frontend
npm ci
npm run dev
npm run lint
npm run build
```

API base behavior:

- Vite development: `http://<current-host>:8000/api`
- Vite preview on port `4173`: `http://<current-host>:8000/api`
- Built app served by Django: same-origin `/api`
