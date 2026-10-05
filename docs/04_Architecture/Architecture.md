# Architecture — PlantHub Bangladesh

**Document Version:** 1.0
**Status:** Draft — Development Phase
**Last Updated:** 2026-08-06

---

## 1. Architecture Style

**Layered, modular, feature-based REST API** with real-time capability, built to allow new roles/modules to be added without touching existing ones.

```
┌──────────────────────────────────────────────┐
│                  Client Layer                 │
│   Web (customer/nursery/expert/admin views)   │
└───────────────────────┬────────────────────────┘
                         │ REST + WebSocket
┌───────────────────────▼────────────────────────┐
│                  API Gateway Layer              │
│   Express.js routes · Auth (JWT) · RBAC · Rate  │
│   Limiting · Validation (input schemas)         │
└───────────────────────┬────────────────────────┘
                         │
┌───────────────────────▼────────────────────────┐
│                Controller Layer                 │
│   Parses request, calls service, shapes response│
└───────────────────────┬────────────────────────┘
                         │
┌───────────────────────▼────────────────────────┐
│                 Service Layer                   │
│   Business logic, orchestration, transactions   │
└───────────────────────┬────────────────────────┘
                         │
┌───────────────────────▼────────────────────────┐
│               Repository Layer                  │
│   Prisma Client — all DB access isolated here   │
└───────────────────────┬────────────────────────┘
                         │
┌───────────────────────▼────────────────────────┐
│                   MongoDB                       │
└──────────────────────────────────────────────────┘

  Cross-cutting: Socket.io (real-time events)
                 Cloudinary/S3 (media storage)
                 Redis (cache, rate-limit, session revocation list)
                 Email/Push service (notifications)
```

## 2. Why This Pattern

- **Repository Pattern** isolates all Prisma/MongoDB access — if the DB or ORM ever changes, only the repository layer changes
- **Service Layer** holds business rules independently of HTTP concerns, making logic unit-testable without spinning up Express
- **Controller Layer** stays thin — purely request/response shaping
- **Modular/Feature-based structure** (see `FolderStructure.md`) means each domain (products, orders, consultations, notifications) is self-contained, so new roles like Delivery Partner or Affiliate can be added as new modules without editing existing ones

## 3. Core Modules (Phase 1)

| Module | Responsibility |
|---|---|
| `auth` | Registration, login, JWT issuance/refresh, RBAC middleware |
| `users` | Shared user profile logic across roles |
| `nurseries` | Nursery profile, verification status |
| `products` | Product CRUD, categories, search/filter |
| `inventory` | Stock tracking, stock history, low-stock alerts |
| `pricing` | Price tiers per product |
| `orders` | Cart → order → status lifecycle |
| `payments` | Payment method handling, gateway integration, settlement |
| `reviews` | Product reviews, growth timeline |
| `experts` | Expert profile, verification |
| `consultations` | Booking, time slots, chat/image-review sessions |
| `knowledge-hub` | Blogs, guides, creator commission attribution |
| `notifications` | In-app, real-time (Socket.io), email dispatch |
| `admin` | User management, verification review, moderation, commission config |
| `analytics` | Aggregation endpoints for nursery/admin dashboards |

## 4. Role-Based Access Control (RBAC)

- Roles at launch: `CUSTOMER`, `NURSERY_OWNER`, `PLANT_EXPERT`, `ADMIN`
- Reserved for future phases (schema-ready, not yet implemented): `SUPER_ADMIN`, `DELIVERY_PARTNER`, `NURSERY_EMPLOYEE`, `AFFILIATE`, `CONTENT_MODERATOR`
- Enforcement: Express middleware reads role from decoded JWT and checks against a per-route permission list before the controller runs
- Design principle: permissions are checked centrally in middleware, never re-implemented per-controller

## 5. Real-Time Layer (Socket.io)

Used for:
- Order status change events (nursery ↔ customer)
- New notification push to a connected client
- Chat consultation sessions (message delivery)

Design: a single Socket.io namespace per concern (`/orders`, `/notifications`, `/consultations`), with room-based scoping per user ID so events are only delivered to the relevant connected clients.

## 6. Data Storage Strategy

- **MongoDB** (via Prisma) — primary data store for all core entities
- **Redis** — caching hot reads (product listings, nursery profiles), rate limiting, and refresh-token/session revocation
- **Cloudinary / S3** — media storage for product images, review photos, verification documents (access-restricted)

## 7. Non-Functional Alignment

This architecture directly supports the NFRs defined in `02_Requirement/NonFunctionalRequirements.md`:
- Stateless API + Redis session handling → NFR-SCAL-03
- Repository/Service separation → NFR-MAINT-02
- Centralized RBAC middleware → NFR-SEC-04
- Modular feature folders → NFR-SCAL-01

## 8. Open Decisions (To Be Finalized)

- [ ] Frontend framework/stack (not yet fixed — client suggested Next.js/React; to confirm)
- [ ] Deployment targets (backend hosting, MongoDB hosting — Atlas vs self-hosted)
- [ ] Payment gateway priority order (bKash vs Nagad vs SSLCommerz first)

---

*See also: [FolderStructure.md](./FolderStructure.md) · [05_Database/Schema.md](../05_Database/Schema.md)*
