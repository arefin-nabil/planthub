# Non-Functional Requirements — PlantHub Bangladesh

**Document Version:** 1.0
**Status:** Draft — Development Phase
**Last Updated:** 2026-08-06

---

## Notation
Each requirement has an ID `NFR-<Category>-<Number>` for traceability.

## 1. Performance

| ID | Requirement |
|---|---|
| NFR-PERF-01 | API endpoints for product listing/search shall respond within 500ms under normal load (p95) |
| NFR-PERF-02 | Image assets shall be served through a CDN/optimized delivery layer, not directly from the application server |
| NFR-PERF-03 | The system shall support pagination or cursor-based fetching for all list endpoints (products, orders, notifications) to avoid unbounded payloads |
| NFR-PERF-04 | Real-time notification delivery (Socket.io) shall have a target latency under 2 seconds |

## 2. Scalability

| ID | Requirement |
|---|---|
| NFR-SCAL-01 | The backend shall follow a modular, feature-based architecture so new modules (e.g. Delivery Partner, Affiliate) can be added without restructuring existing modules |
| NFR-SCAL-02 | The database schema shall be designed to accommodate future roles and entities without breaking existing collections |
| NFR-SCAL-03 | The system shall be stateless at the application layer (session/auth state in JWT + Redis/cache, not in-memory) so multiple instances can run behind a load balancer |

## 3. Security

| ID | Requirement |
|---|---|
| NFR-SEC-01 | All passwords shall be hashed (bcrypt/argon2) — never stored in plaintext |
| NFR-SEC-02 | All API traffic shall be served over HTTPS |
| NFR-SEC-03 | JWT access tokens shall have a short expiry; refresh tokens shall be rotated and revocable |
| NFR-SEC-04 | The system shall implement RBAC middleware validated on every protected route, not just on the frontend |
| NFR-SEC-05 | The system shall validate and sanitize all user input (using a schema validation library) to prevent injection attacks |
| NFR-SEC-06 | File uploads (images, ID documents for verification) shall be validated for type/size and scanned before storage |
| NFR-SEC-07 | Sensitive verification documents (National ID) shall be stored with restricted access, visible only to Admin roles |
| NFR-SEC-08 | The system shall rate-limit authentication and payment endpoints to mitigate brute-force/abuse |

## 4. Reliability & Availability

| ID | Requirement |
|---|---|
| NFR-REL-01 | The system shall target 99.5% uptime for core marketplace and order flows during business hours |
| NFR-REL-02 | Payment and order-status operations shall be transactional/idempotent to prevent duplicate charges or lost orders |
| NFR-REL-03 | The system shall log and alert on failed payment webhooks for manual reconciliation |

## 5. Usability

| ID | Requirement |
|---|---|
| NFR-USE-01 | The interface shall be mobile-first and usable on low-to-mid range Android devices common in Bangladesh |
| NFR-USE-02 | The nursery dashboard shall be usable by owners with limited technical literacy (minimal jargon, clear guided flows) |
| NFR-USE-03 | Core flows (browse → order, product → inventory update) shall be completable in a small number of steps (target: ≤5 taps/clicks) |

## 6. Maintainability

| ID | Requirement |
|---|---|
| NFR-MAINT-01 | Code shall follow a consistent style enforced by linting/formatting tools (see `08_Development/CodingStandards.md`) |
| NFR-MAINT-02 | The codebase shall follow Repository Pattern + Service Layer separation so business logic is decoupled from data access |
| NFR-MAINT-03 | All modules shall include documentation sufficient for a new developer to onboard without verbal handoff |
| NFR-MAINT-04 | Database schema changes shall be tracked via Prisma migrations with clear, dated migration history |

## 7. Compatibility

| ID | Requirement |
|---|---|
| NFR-COMP-01 | The system shall support modern evergreen browsers (Chrome, Firefox, Safari, Edge — last 2 versions) |
| NFR-COMP-02 | The API shall be versioned to allow backward-compatible evolution as mobile apps or new frontends are added |

## 8. Localization

| ID | Requirement |
|---|---|
| NFR-LOC-01 | The system shall support BDT currency formatting throughout |
| NFR-LOC-02 | The system shall be designed to allow Bengali-language UI in a future phase without major restructuring (text externalized, not hardcoded) |

## 9. Data & Privacy

| ID | Requirement |
|---|---|
| NFR-DATA-01 | Personally identifiable information (National ID, phone, address) shall be handled per applicable data protection practices and shared only with authorized roles |
| NFR-DATA-02 | The system shall provide a mechanism for data backup and recovery for the MongoDB database |

---

*See also: [FunctionalRequirements.md](./FunctionalRequirements.md)*
