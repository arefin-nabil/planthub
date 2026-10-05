# API — Authentication

**Document Version:** 1.0
**Status:** Draft — Development Phase
**Last Updated:** 2026-08-06
**Base Path:** `/v1/auth`

---

## POST /auth/register

Registers a new user (Customer, Nursery Owner, or Plant Expert).

**Body:**
```json
{
  "name": "string",
  "email": "string",
  "phone": "string",
  "password": "string",
  "role": "CUSTOMER | NURSERY_OWNER | PLANT_EXPERT"
}
```

**Response `201`:**
```json
{
  "success": true,
  "data": { "userId": "...", "role": "CUSTOMER" },
  "message": "Registration successful. Please verify OTP."
}
```

**Errors:** `409 EMAIL_ALREADY_EXISTS`, `409 PHONE_ALREADY_EXISTS`, `400 VALIDATION_ERROR`

---

## POST /auth/verify-otp

**Body:** `{ "phone": "string", "otp": "string" }`
**Response `200`:** `{ "success": true, "message": "Phone verified." }`
**Errors:** `400 INVALID_OTP`, `410 OTP_EXPIRED`

---

## POST /auth/login

**Body:** `{ "email": "string", "password": "string" }`
**Response `200`:**
```json
{
  "success": true,
  "data": {
    "accessToken": "jwt...",
    "refreshToken": "jwt...",
    "user": { "id": "...", "name": "...", "role": "CUSTOMER" }
  }
}
```
**Errors:** `401 INVALID_CREDENTIALS`, `403 ACCOUNT_NOT_VERIFIED`

---

## POST /auth/refresh-token

**Body:** `{ "refreshToken": "string" }`
**Response `200`:** `{ "success": true, "data": { "accessToken": "jwt..." } }`
**Errors:** `401 INVALID_REFRESH_TOKEN`, `401 TOKEN_REVOKED`

---

## POST /auth/logout

**Auth required.** Revokes the current refresh token (added to Redis revocation list).
**Response `204`**

---

## POST /auth/forgot-password

**Body:** `{ "email": "string" }`
**Response `200`:** `{ "success": true, "message": "Reset instructions sent." }`

---

## POST /auth/reset-password

**Body:** `{ "token": "string", "newPassword": "string" }`
**Response `200`:** `{ "success": true, "message": "Password updated." }`
**Errors:** `400 INVALID_OR_EXPIRED_TOKEN`

---

## Token Design

| Token | Lifetime | Storage (client) | Notes |
|---|---|---|---|
| Access Token | 15 minutes | Memory / short-lived cookie | Used on every request |
| Refresh Token | 7 days | HttpOnly cookie or secure storage | Rotated on every refresh; old one revoked |

**JWT Payload:**
```json
{ "sub": "userId", "role": "CUSTOMER", "iat": 0, "exp": 0 }
```

---

*See also: [API_Standards.md](./API_Standards.md) · [../02_Requirement/FunctionalRequirements.md#1-fr-auth--authentication--account-management](../02_Requirement/FunctionalRequirements.md)*
