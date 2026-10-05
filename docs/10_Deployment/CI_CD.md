# CI/CD & Deployment — PlantHub Bangladesh

**Document Version:** 1.0
**Status:** Draft — Development Phase
**Last Updated:** 2026-08-06

---

## 1. Environments

| Environment | Trigger | Purpose |
|---|---|---|
| Local | Developer machine | Active development |
| Staging | Push/merge to `develop` | QA, client demo, integration testing |
| Production | Tag/release on `main` | Live traffic |

## 2. Proposed CI Pipeline (per PR)

```
1. Install dependencies
2. Lint (ESLint) + format check (Prettier)
3. Type-check (tsc --noEmit)
4. Run unit tests (Jest)
5. Run integration tests against ephemeral test MongoDB
6. Build (tsc build)
```

A PR cannot merge to `develop` unless all steps pass (see `08_Development/GitWorkflow.md` §3).

## 3. Proposed CD Pipeline (on release)

```
1. Build production bundle
2. Run prisma migrate deploy (against target DB)
3. Deploy to hosting target
4. Run smoke test against health-check endpoint
5. Notify team of deployment result
```

## 4. Hosting (To Be Finalized)

| Component | Candidate Options | Status |
|---|---|---|
| Backend (Node/Express) | Railway, Render, DigitalOcean App Platform | Not yet decided |
| MongoDB | MongoDB Atlas (managed) vs. self-hosted | Leaning Atlas for managed backups/scaling |
| Redis | Managed Redis (Upstash, Railway add-on) | Not yet decided |
| Media Storage | Cloudinary | Proposed |
| Frontend | Depends on chosen frontend framework | Not yet decided (see `04_Architecture/Architecture.md` open decisions) |

## 5. Environment Variables

Managed via `.env` per environment, never committed. Reference list maintained in `.env.example` at the project root. Minimum required at launch:

```
DATABASE_URL=
JWT_ACCESS_SECRET=
JWT_REFRESH_SECRET=
REDIS_URL=
CLOUDINARY_URL=
PAYMENT_GATEWAY_KEY=
EMAIL_SERVICE_API_KEY=
```

## 6. Monitoring & Alerts (Proposed for Launch)

- Application error tracking (e.g. Sentry)
- Uptime monitoring against the health-check endpoint
- Alert channel (email/Slack) for failed deployments and payment webhook failures (NFR-REL-03)

## 7. Rollback Strategy

- Keep the previous release's build artifact deployable
- Database migrations should be additive/backward-compatible where possible so a code rollback doesn't require a matching down-migration
- Maintain a documented rollback runbook once the first production deployment ships

## 8. Docker (Optional, Recommended for Local Parity)

A `docker-compose.yml` for local MongoDB + Redis is recommended so local development matches staging/production data services without each developer installing them natively.

---

*This document will be filled in with concrete configuration once hosting decisions in §4 are finalized — see `04_Architecture/Architecture.md` Open Decisions.*
