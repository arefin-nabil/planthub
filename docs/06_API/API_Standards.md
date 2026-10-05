# API Standards — PlantHub Bangladesh

**Document Version:** 1.0
**Status:** Draft — Development Phase
**Last Updated:** 2026-08-06

---

## 1. Base URL & Versioning

```
https://api.planthub.com.bd/v1/...
```

All routes are versioned under `/v1` from day one so future breaking changes can ship as `/v2` without disrupting existing clients (NFR-COMP-02).

## 2. Request/Response Conventions

### 2.1 Standard Success Response
```json
{
  "success": true,
  "data": { },
  "message": "Optional human-readable message"
}
```

### 2.2 Standard Error Response
```json
{
  "success": false,
  "error": {
    "code": "PRODUCT_OUT_OF_STOCK",
    "message": "This product is currently out of stock."
  }
}
```

### 2.3 Pagination
List endpoints accept `?page=1&limit=20` and respond with:
```json
{
  "success": true,
  "data": [ ],
  "pagination": { "page": 1, "limit": 20, "total": 134, "totalPages": 7 }
}
```

## 3. HTTP Status Code Usage

| Code | Meaning |
|---|---|
| 200 | Success (GET/PUT/PATCH) |
| 201 | Resource created (POST) |
| 204 | Success, no content (DELETE) |
| 400 | Validation error |
| 401 | Not authenticated (missing/invalid JWT) |
| 403 | Authenticated but not authorized (RBAC failure) |
| 404 | Resource not found |
| 409 | Conflict (e.g. duplicate email) |
| 422 | Business rule violation (e.g. insufficient stock) |
| 429 | Rate limited |
| 500 | Unexpected server error |

## 4. Authentication Header

```
Authorization: Bearer <jwt_access_token>
```

## 5. Naming Conventions

- Resource routes are plural nouns: `/products`, `/orders`, `/consultations`
- Nested resources reflect ownership: `/nurseries/:nurseryId/products`
- Actions that aren't pure CRUD use a verb sub-path: `/orders/:id/cancel`, `/products/:id/duplicate`

## 6. Input Validation

- Every route validates its input against a schema (Zod) in a `validate.middleware.ts` step before reaching the controller
- Validation errors return `400` with a field-level error map:
```json
{
  "success": false,
  "error": {
    "code": "VALIDATION_ERROR",
    "message": "Invalid input",
    "fields": { "price": "Price must be a positive number" }
  }
}
```

## 7. Rate Limiting

- Auth endpoints (`/auth/login`, `/auth/register`): 10 requests/minute/IP
- Payment endpoints: 20 requests/minute/user
- General API: 100 requests/minute/user

## 8. Idempotency

- Payment confirmation and order-creation endpoints accept an optional `Idempotency-Key` header to safely retry without duplicate side effects (NFR-REL-02)

---

*See also: [Authentication.md](./Authentication.md) · [Plants.md](./Plants.md) · [Orders.md](./Orders.md) · [Notifications.md](./Notifications.md)*
