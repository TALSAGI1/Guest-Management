**Guest Management (Flask)
**
A simple, educational Guest Management app: create, view, edit, and delete guests via a web UI. The project includes automated tests, containerization, and CI/CD.

Features

Home page listing all guests

Form to add a new guest (name, email)

Edit and delete actions

Health endpoint: GET /healthz

Tech Stack

Backend: Flask (Python)

Templates: Jinja2 (HTML/CSS)

Database: SQLite (guest.db)

Optional: MongoDB via Flask-PyMongo (see “Mongo option” below)

Testing: pytest

Prod Web Server: Gunicorn (inside Docker)

Containers: Docker (+ optional Docker Compose)

CI/CD: GitHub Actions

CI: installs deps, runs tests, builds the image locally, runs it, and checks /healthz

CD: builds & pushes a versioned Docker image to GHCR

Project Structure
guest-management/
├─ app/
│  ├─ __init__.py        # create_app(), config, /healthz
│  ├─ routes.py          # routes, HTML pages, CRUD
│  ├─ models.py          # SQLAlchemy model (Guest) for SQLite
│  └─ templates/
│     ├─ index.html      # table of guests
│     └─ guest_form.html # create/edit form
├─ migrations/           # Flask-Migrate files (auto-generated)
├─ tests/test_app.py     # basic health test (extend with CRUD tests)
├─ requirements.txt
├─ Dockerfile
├─ .dockerignore
└─ .github/workflows/
   ├─ ci.yml             # tests + container health-check
   └─ cd.yml             # build & push image to GHCR

Run Locally (Windows PowerShell)
python -m venv .venv
. .venv\Scripts\activate
pip install -r requirements.txt

# Initialize DB (first time)
$env:FLASK_APP = "app:create_app"
flask db init
flask db migrate -m "init"
flask db upgrade

# Run
python -c "from app import create_app; create_app().run(host='0.0.0.0', port=8080, debug=True)"
# Open: http://localhost:8080  (health: /healthz)

Tests
. .venv\Scripts\activate
pytest -q

Docker (Build & Run)
docker build -t guest-mgmt:dev .
docker run --rm -p 8080:8080 guest-mgmt:dev
# http://localhost:8080

Docker Compose (Optional: example with Mongo)
# docker-compose.yml (example)
services:
  mongo:
    image: mongo:7
    volumes: [ "mongo_data:/data/db" ]
    ports: [ "27017:27017" ]
  app:
    image: ghcr.io/<OWNER>/<REPO>/app:latest
    ports: [ "8080:8080" ]
    environment:
      MONGO_URI: "mongodb://mongo:27017/guestdb"
    depends_on: [ mongo ]
volumes:
  mongo_data:

docker compose up -d
docker compose down

CI/CD (GitHub Actions)

CI (.github/workflows/ci.yml)

Checkout → setup Python → pip install -r requirements.txt → pytest

Build image with docker/build-push-action (load: true) → run container → curl /healthz

CD (.github/workflows/cd.yml)

Build & push to GHCR with tags: latest and <commit-sha>

Image appears under Packages: ghcr.io/<owner>/<repo>/app:<tag>

Configuration

Common env vars

FLASK_APP=app:create_app

PORT=8080

(Optional) MONGO_URI=mongodb://localhost:27017/guestdb

SQLite uses sqlite:///guest.db by default (no env needed)

Mongo Option (Optional)

Install: Flask-PyMongo, pymongo

In app/__init__.py: configure MONGO_URI and mongo = PyMongo(app)

In routes.py: use mongo.db.guests instead of SQLAlchemy

Local Mongo for dev:

docker run -d -p 27017:27017 -v mongo_data:/data/db --name mongo mongo:7

License

Add a license (MIT/Apache-2.0) as needed.
