# Test Plan — PlantHub Bangladesh

**Document Version:** 1.0
**Status:** Draft — Development Phase
**Last Updated:** 2026-08-06

---

## 1. Testing Levels

| Level | Tool (Proposed) | Scope |
|---|---|---|
| Unit | Jest | Service-layer business logic, in isolation from Express/DB |
| Integration | Jest + Supertest + test MongoDB instance | Full request → controller → service → repository → DB flow |
| End-to-End | Postman/Newman collection or Playwright (once frontend exists) | Full user journeys across roles |
| Load | k6 or Artillery | Verify NFR-PERF targets before launch |

## 2. Priority Test Coverage (Phase 1)

High-priority flows that require both unit and integration tests before being considered "done":

- [ ] User registration + OTP verification + login (FR-AUTH-01–05)
- [ ] RBAC enforcement — verify each role is blocked from other roles' routes (NFR-SEC-04)
- [ ] Product creation, stock update, low-stock alert trigger (FR-NUR-01–03)
- [ ] Order placement with stock validation and decrement (FR-MKT / FR-NUR-06)
- [ ] Order status transition state machine — valid and invalid transitions (FR-NUR-06)
- [ ] Payment confirmation idempotency (NFR-REL-02)
- [ ] Consultation booking with payment gate (FR-CON-01–04)
- [ ] Nursery verification approval flow (FR-VER-01–03)
- [ ] Commission attribution within the 30-day window (FR-KH-03)

## 3. Test Case Template

| Field | Example |
|---|---|
| ID | TC-ORD-001 |
| Requirement | FR-NUR-06 |
| Description | Order cannot transition from PENDING directly to DELIVERED |
| Preconditions | Order exists with status PENDING |
| Steps | PATCH /orders/:id/status with `{ "status": "DELIVERED" }` |
| Expected Result | `422 INVALID_STATUS_TRANSITION` |

## 4. Environments

| Environment | Purpose |
|---|---|
| Local | Developer machine, local MongoDB / Docker |
| Staging | Mirrors production config, used for QA and client demos |
| Production | Live environment |

## 5. Bug Severity Classification

| Severity | Definition | Example |
|---|---|---|
| Critical | Blocks a core flow, no workaround | Orders cannot be placed |
| High | Major feature broken, workaround exists | Invoice PDF fails to generate |
| Medium | Non-blocking functional issue | Filter doesn't reset properly |
| Low | Cosmetic / minor | Misaligned button on mobile |

## 6. Exit Criteria (Before Production Launch)

- [ ] All Critical/High severity bugs resolved
- [ ] All Priority Test Coverage items above passing
- [ ] Load test confirms NFR-PERF-01 (p95 < 500ms on product listing/search) under expected launch traffic
- [ ] Security checklist from `02_Requirement/NonFunctionalRequirements.md` §3 reviewed and signed off

---

*See also: [08_Development/CodingStandards.md](../08_Development/CodingStandards.md)*
