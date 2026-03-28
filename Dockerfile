# ── Stage 1: build dependencies ──────────────────────────────────────────────
FROM python:3.10-slim AS builder

WORKDIR /app

RUN apt-get update && apt-get install -y --no-install-recommends \
    gcc \
    libjpeg-dev \
    zlib1g-dev \
    && rm -rf /var/lib/apt/lists/*

COPY requirements.txt .
RUN pip install --upgrade pip \
    && pip install --prefix=/install -r requirements.txt \
    && pip install --prefix=/install gunicorn==21.2.0

# ── Stage 2: runtime image ────────────────────────────────────────────────────
FROM python:3.10-slim

ENV PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1

WORKDIR /app

RUN apt-get update && apt-get install -y --no-install-recommends \
    libjpeg62-turbo \
    zlib1g \
    && rm -rf /var/lib/apt/lists/*

COPY --from=builder /install /usr/local
COPY . .

RUN SECRET_KEY=build-time-placeholder \
    DEBUG=0 \
    ALLOWED_HOSTS=localhost \
    python manage.py collectstatic --noinput

EXPOSE 8000

CMD ["sh", "-c", "DJANGO_SETTINGS_MODULE=online_shop.settings python manage.py migrate --noinput && \
     DJANGO_SETTINGS_MODULE=online_shop.settings gunicorn online_shop.wsgi:application \
     --bind 0.0.0.0:8000 \
     --workers ${GUNICORN_WORKERS:-3} \
     --timeout 120 \
     --access-logfile - \
     --error-logfile -"]