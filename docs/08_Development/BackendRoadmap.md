# Backend Roadmap — PlantHub Bangladesh

**Document Version:** 1.0
**Status:** Draft — Development Phase
**Last Updated:** 2026-08-06

---

## Purpose

Build order for the backend, sequenced so each stage is independently testable and unlocks the next. Check items off as they're completed — this is the single source of truth for "where are we" when picking the project back up after a gap.

## Stage 1 — Foundation
- [ ] Project scaffolding: Express + TypeScript + folder structure (`04_Architecture/FolderStructure.md`)
- [ ] Prisma + MongoDB connection, base schema migration
- [ ] Global middleware: error handler, request logger, validation wrapper
- [ ] `.env` configuration and secrets management setup

## Stage 2 — Auth & Users
- [ ] `auth` module: register, OTP verify, login, refresh, logout, password reset
- [ ] JWT issuance + Redis-backed refresh token revocation
- [ ] `rbac.middleware.ts` with role/permission checks
- [ ] `users` module: profile get/update

## Stage 3 — Nursery & Product Core
- [ ] `nurseries` module: profile CRUD, public profile route
- [ ] `products` module: CRUD, search/filter, duplicate/archive
- [ ] `inventory` module: stock tracking, history, low-stock alert trigger
- [ ] `pricing` module: price tier management

## Stage 4 — Orders & Payments
- [ ] `orders` module: cart→order flow, status transitions, state machine enforcement
- [ ] `payments` module: COD flow first, then one online gateway (bKash or SSLCommerz)
- [ ] Invoice generation (PDF)

## Stage 5 — Engagement Features
- [ ] `wishlist` and `follow` endpoints
- [ ] `reviews` module including growth-timeline photo uploads
- [ ] `campaigns` and `bundles`

## Stage 6 — Real-Time & Notifications
- [ ] Socket.io server setup, namespaces (`/orders`, `/notifications`, `/consultations`)
- [ ] `notifications` module: creation, fetch, mark-read
- [ ] Email notification service integration

## Stage 7 — Experts & Consultation
- [ ] `experts` module: profile, verification
- [ ] Time slot management
- [ ] `consultations` module: booking, payment gate, chat session handling

## Stage 8 — Knowledge Hub
- [ ] `blogs` module: create/submit/approve
- [ ] Commission attribution tracking (30-day window)

## Stage 9 — Admin & Analytics
- [ ] `admin` module: user management, verification review, moderation, commission config
- [ ] `analytics` module: nursery dashboard aggregations, admin platform analytics

## Stage 10 — Hardening for Launch
- [ ] Rate limiting on auth/payment endpoints
- [ ] Load testing against `09_Testing/TestPlan.md` targets
- [ ] Security review against `02_Requirement/NonFunctionalRequirements.md` §3
- [ ] Deployment pipeline (`10_Deployment/CI_CD.md`)

---

*Update the checkboxes above as each stage progresses — this file is the authoritative build-order tracker.*
