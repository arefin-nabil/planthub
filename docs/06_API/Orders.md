# API — Orders

**Document Version:** 1.0
**Status:** Draft — Development Phase
**Last Updated:** 2026-08-06
**Base Path:** `/v1/orders`

---

## POST /orders *(Customer)*

Places a new order.

**Body:**
```json
{
  "items": [ { "productId": "...", "quantity": 2 } ],
  "deliveryAddress": "string",
  "paymentMethod": "COD | BKASH | NAGAD | SSLCOMMERZ"
}
```
**Headers:** `Idempotency-Key: <uuid>` (recommended)

**Response `201`:**
```json
{
  "success": true,
  "data": { "id": "...", "status": "PENDING", "totalAmount": 700 }
}
```
**Errors:** `422 INSUFFICIENT_STOCK`, `400 VALIDATION_ERROR`

**Side effects:**
- Decrements product stock, writes `InventoryLog` entry
- Emits Socket.io event to nursery owner: `order:new`
- Sends notification to nursery owner (FR-NOTIF-03)
- Sends order confirmation notification to customer

---

## GET /orders *(Customer — own orders)*
Query: `page, limit, status`
**Response `200`:** paginated list of the customer's orders

## GET /orders *(Nursery Owner — own nursery's orders)*
Same endpoint, scoped server-side by role: nursery owners see orders for their `nurseryId` only.

## GET /orders/:id
Order detail — accessible to the owning customer, the fulfilling nursery, or an admin.
**Errors:** `403 FORBIDDEN`, `404 ORDER_NOT_FOUND`

---

## PATCH /orders/:id/status *(Nursery Owner)*

**Body:** `{ "status": "CONFIRMED | PACKED | SHIPPED | DELIVERED | CANCELLED | RETURNED" }`

**Response `200`:** updated order

**Rules:**
- Status transitions must follow the defined flow (`Pending → Confirmed → Packed → Shipped → Delivered`); `Cancelled`/`Returned` are valid from any pre-`Delivered` state
- Invalid transition → `422 INVALID_STATUS_TRANSITION`

**Side effects:**
- Emits Socket.io event to customer: `order:statusUpdate`
- Sends push/email/in-app notification to customer (FR-NOTIF-02)
- On `CANCELLED`, restores product stock and writes a reversing `InventoryLog` entry

---

## GET /orders/:id/invoice *(Customer, Nursery Owner, Admin)*
Returns a generated PDF invoice (FR-NUR-09).
**Response `200`:** `application/pdf` stream, or `{ "data": { "invoiceUrl": "..." } }` if stored/pre-generated.

---

## Order Status State Machine

```
PENDING → CONFIRMED → PACKED → SHIPPED → DELIVERED
   │           │          │
   └────────── CANCELLED ─┘
                  │
              RETURNED  (only from DELIVERED)
```

---

*See also: [API_Standards.md](./API_Standards.md) · [Notifications.md](./Notifications.md) · [../02_Requirement/FunctionalRequirements.md#3-fr-nur--nursery-management](../02_Requirement/FunctionalRequirements.md)*
