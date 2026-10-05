# Folder Structure — PlantHub Bangladesh (Backend)

**Document Version:** 1.0
**Status:** Draft — Development Phase
**Last Updated:** 2026-08-06

---

## 1. Project Root

```
planthub-backend/
│
├── src/
│   ├── modules/                  # Feature-based modules (see below)
│   ├── common/                   # Shared, cross-module code
│   ├── config/                   # Environment & app configuration
│   ├── middlewares/              # Global Express middlewares
│   ├── sockets/                  # Socket.io namespaces/handlers
│   ├── jobs/                     # Scheduled/background jobs (e.g. campaign expiry, low-stock sweep)
│   ├── app.ts                    # Express app setup
│   └── server.ts                 # Entry point (HTTP + Socket.io bootstrap)
│
├── prisma/
│   ├── schema.prisma
│   └── migrations/
│
├── docs/                         # This documentation set
├── tests/                        # Test suites (see 09_Testing/TestPlan.md)
├── .env.example
├── package.json
├── tsconfig.json
└── README.md
```

## 2. Module Structure (per feature)

Every module under `src/modules/<name>/` follows the same internal shape, so any developer can navigate any module the same way:

```
src/modules/orders/
│
├── order.routes.ts        # Express route definitions
├── order.controller.ts    # Request/response handling
├── order.service.ts       # Business logic
├── order.repository.ts    # Prisma queries, isolated DB access
├── order.validation.ts    # Zod/Joi schemas for input validation
├── order.types.ts         # TypeScript types/interfaces
└── order.test.ts          # Unit tests for this module
```

## 3. Phase 1 Module List

```
src/modules/
├── auth/
├── users/
├── nurseries/
├── products/
├── inventory/
├── pricing/
├── orders/
├── payments/
├── reviews/
├── experts/
├── consultations/
├── knowledge-hub/
├── notifications/
├── admin/
└── analytics/
```

## 4. `common/` Contents

```
src/common/
├── errors/            # Custom error classes, error handler
├── utils/             # Shared helper functions
├── constants/         # Enums, fixed values (order status, roles, etc.)
├── interfaces/         # Shared cross-module TypeScript interfaces
└── pagination/         # Shared pagination helper
```

## 5. `middlewares/` Contents

```
src/middlewares/
├── auth.middleware.ts        # JWT verification
├── rbac.middleware.ts        # Role/permission checks
├── validate.middleware.ts    # Runs Zod/Joi schemas against requests
├── rateLimit.middleware.ts
└── errorHandler.middleware.ts
```

## 6. Naming Conventions

- Files: `camelCase.ts` for utilities, `PascalCase` only for class-based files if used
- Modules: lowercase, plural where the entity is a collection (`orders`, `products`)
- Prisma models: `PascalCase` singular (e.g. `Order`, `Product`, `NurseryProfile`)
- MongoDB collections (via Prisma `@@map`): lowercase plural, matching module names

## 7. Rationale

This structure is intentionally **feature-first, not layer-first at the top level** — i.e., you find everything about "orders" in one folder, rather than hunting across a global `controllers/`, `services/`, `routes/` split. This keeps the codebase navigable as new roles and modules (Delivery Partner, Affiliate, etc.) are added later, without growing a handful of giant shared folders.

---

*See also: [Architecture.md](./Architecture.md)*
