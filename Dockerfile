# syntax=docker/dockerfile:1

FROM node:22-alpine AS frontend-build
WORKDIR /app/frontend
COPY frontend/package*.json ./
RUN npm ci
COPY frontend/ ./
ENV VITE_BASE=/static/
RUN npm run build

FROM python:3.13-slim AS app
ENV PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1 \
    PIP_NO_CACHE_DIR=1

WORKDIR /app/backend
COPY backend/requirements.txt ./requirements.txt
RUN python -m pip install --upgrade pip \
    && python -m pip install -r requirements.txt

COPY backend/ ./
COPY --from=frontend-build /app/frontend/dist ./frontend_dist
WORKDIR /app/backend/tp

RUN python manage.py collectstatic --noinput

EXPOSE 8000
ENTRYPOINT ["sh", "/app/backend/docker-entrypoint.sh"]
CMD ["gunicorn", "tp.wsgi:application", "--bind", "0.0.0.0:8000", "--workers", "3"]
