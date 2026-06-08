# IA-TARA Backend

Django REST Framework backend for the IA-TARA application. It provides JWT auth, project data APIs, risk calculations, report generation, MITRE endpoints, and optional assistant integration.

Run it from `backend/`:

```sh
python -m venv .venv
source .venv/bin/activate
pip install -r requirements.txt
cd tp
python manage.py migrate
python manage.py runserver 0.0.0.0:8000
```

Useful commands:

```sh
cd backend/tp
python manage.py check
python manage.py test api
python manage.py createsuperuser
python manage.py makemigrations api
python manage.py migrate
```

Optional assistant settings are loaded from `backend/.env` or `backend/tp/.env`. Start from `backend/.env.example`.
