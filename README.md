# Myafrimall: Full Stack Technical Assessment (SecureByPay)

A full-stack shipping/logistics web application built for the SecureByPay technical assessment. It replicates the provided Figma design (Sign Up, Sign In, Dashboard) with a fully responsive Flutter Web frontend and a Node.js/Express REST API backend.

**Live demo:** https://securebypay-fullstack-assessment.vercel.app
**Repository:** https://github.com/Nebenmor/securebypay-fullstack-assessment

---

## Tech Stack

| Layer | Technology |
|---|---|
| Frontend | Flutter Web (Dart) |
| Backend | Node.js, Express 5 (ES modules) |
| Database | PostgreSQL |
| Auth | JWT (JSON Web Tokens), bcrypt password hashing |
| Frontend hosting | Vercel |
| Backend hosting | Render |
| CI/CD | GitHub Actions (auto-build & deploy frontend on push to `main`) |

---

## Project Structure

```
securebypay-assessment/
├── .github/workflows/deploy-frontend.yml   # CI/CD pipeline
├── backend/
│   └── src/
│       ├── config/db.js                    # Postgres connection pool
│       ├── db/                             # Schema init + demo data seeding
│       ├── middleware/                     # JWT auth guard, error handler
│       ├── controllers/                    # Route handlers
│       ├── routes/                         # auth, dashboard, shipments
│       ├── app.js                          # Express app setup
│       └── server.js                       # Entry point
└── frontend/
    └── lib/
        ├── core/
        │   ├── api/api_client.dart         # HTTP client with cold-start retry logic
        │   ├── theme/                      # Colors, typography (from Figma spec)
        │   ├── utils/responsive.dart       # Breakpoint helper
        │   └── router.dart                 # go_router with auth guard
        └── features/
            ├── auth/                       # Sign up / Sign in screens + service
            └── dashboard/                  # Sidebar, overview, chart, shipments
```

---

## Features

- **Responsive UI**: matches the Figma design across desktop, tablet, and mobile breakpoints, including a collapsible sidebar (hamburger drawer) on mobile.
- **Authentication**: full register/login flow with JWT issued on success, persisted client-side via `shared_preferences`, and field-level validation errors returned from the API.
- **Dashboard**: wallet balance, shipment stats (with live data from the backend), a company growth chart with Year/Month/Week toggles (`fl_chart`), and an expandable recent-shipments list with status-based actions.
- **Cold-start handling**: the backend runs on Render's free tier, which sleeps after 15 minutes of inactivity. The frontend pings `/health` on load and automatically retries failed requests with backoff, showing a friendly "waking up the server" banner instead of a broken screen.

---

## Running Locally

### Backend

```bash
cd backend
npm install
cp .env.example .env   # then fill in your own values
npm run dev
```

Required environment variables (see `.env.example`):
```
PORT=5000
DATABASE_URL=postgresql://user:password@localhost:5432/securebypay
JWT_SECRET=<a long random string>
CORS_ORIGIN=*
DB_SSL=false
```

The server creates its own tables on startup, no separate migration step needed.

### Frontend

```bash
cd frontend
flutter pub get
flutter run -d chrome --dart-define=API_URL=http://localhost:5000
```

Omit the `--dart-define` flag to point at the live Render backend instead of a local one.

---

## API Endpoints

| Method | Endpoint | Auth | Description |
|---|---|---|---|
| GET | `/health` | No | Health check / server wake-up ping |
| POST | `/api/auth/register` | No | Create account, returns JWT |
| POST | `/api/auth/login` | No | Authenticate, returns JWT |
| GET | `/api/auth/me` | Yes | Current user profile |
| GET | `/api/dashboard/overview` | Yes | Wallet balance + shipment stats |
| GET | `/api/dashboard/growth` | Yes | Chart data by range (`year`/`month`/`week`) |
| GET | `/api/shipments` | Yes | Recent shipments list |

Authenticated requests use `Authorization: Bearer <token>`.

---

## Deployment

- **Backend:** Render Web Service + Render PostgreSQL (free tier). Auto-deploys on push to `main`.
  - ⚠️ Note: the free Render Postgres database expires 30 days after creation.
- **Frontend:** Vercel, deployed via GitHub Actions. Every push to `main` under `frontend/**` triggers a fresh Flutter web build and production deploy.

---

## Notes

- "Forgot Password" is a UI link only; the reset flow itself was out of scope for this assessment's requirements.
- The Render free-tier backend may take up to ~60 seconds to respond on first load after inactivity. This is expected and handled gracefully by the retry UI described above, not a bug.
- Dashboard stat/growth figures are seeded per-user on registration for demo purposes.

---

## Author

Anthony Nebenmor
GitHub: [@Nebenmor](https://github.com/Nebenmor)
Portfolio: [devanthon.vercel.app](https://devanthon.vercel.app)