FROM python:3.12-slim

ENV PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1

WORKDIR /app

# תלויות
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# קוד האפליקציה
COPY . .

# (אופציונלי – משתמש לא-root)
# RUN useradd -m appuser && chown -R appuser /app
# USER appuser

# Flask app factory
ENV FLASK_APP=app:create_app
ENV PORT=8080
EXPOSE 8080

# שרת פרודקשן ל-Flask
CMD ["gunicorn","-b","0.0.0.0:8080","app:create_app()"]
