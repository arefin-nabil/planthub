# API — Notifications

**Document Version:** 1.0
**Status:** Draft — Development Phase
**Last Updated:** 2026-08-06
**Base Path:** `/v1/notifications`

---

## GET /notifications *(Authenticated user)*

Query: `page, limit, isRead`

**Response `200`:**
```json
{
  "success": true,
  "data": [
    { "id": "...", "type": "ORDER_UPDATE", "message": "Your order has shipped", "isRead": false, "createdAt": "..." }
  ],
  "pagination": { }
}
```

## PATCH /notifications/:id/read
Marks a single notification as read. **Response `200`**

## PATCH /notifications/read-all
Marks all of the current user's notifications as read. **Response `200`**

---

## Notification Types (`type` field)

| Type | Recipient | Trigger |
|---|---|---|
| `NEW_ARRIVAL` | Customer (followers) | Nursery publishes new product |
| `FOLLOWED_NURSERY_UPDATE` | Customer | Followed nursery posts campaign/product |
| `ORDER_UPDATE` | Customer | Order status changes |
| `DELIVERY_UPDATE` | Customer | Delivery status changes |
| `PAYMENT_CONFIRMATION` | Customer | Payment succeeds |
| `WISHLIST_RESTOCK` | Customer | Wishlisted product back in stock |
| `SEASONAL_CAMPAIGN` | Customer | New campaign launched |
| `CARE_REMINDER` | Customer | Scheduled plant-care reminder |
| `CONSULTATION_REMINDER` | Customer, Expert | Upcoming booked consultation |
| `NEW_BLOG_POST` | Customer (followers) | Followed expert publishes a blog |
| `NEW_ORDER` | Nursery Owner | Customer places an order |
| `LOW_STOCK` | Nursery Owner | Product stock ≤ threshold |
| `NEW_REVIEW` | Nursery Owner | Customer reviews a product |
| `CUSTOMER_MESSAGE` | Nursery Owner | New chat message |
| `PAYMENT_SETTLEMENT` | Nursery Owner | Payout processed |
| `CAMPAIGN_PERFORMANCE` | Nursery Owner | Periodic campaign summary |
| `CONSULTATION_BOOKING` | Expert | New booking received |
| `PAYMENT_RECEIVED` | Expert | Consultation payment received |
| `VERIFICATION_REQUEST` | Admin | New nursery/expert verification submitted |
| `ABUSE_REPORT` | Admin | Content/user reported |
| `FAILED_PAYMENT` | Admin | Payment webhook failure |
| `PLATFORM_ALERT` | Admin | System-level alert |

## Delivery Channels

| Channel | Mechanism |
|---|---|
| In-App | Stored `Notification` record, fetched via this API |
| Real-Time | Socket.io event `notification:new` pushed to the user's room on creation |
| Push (Mobile) | Firebase Cloud Messaging — planned |
| Email | Transactional email service — for order confirmation, payment, verification results |
| SMS | Out of scope for Phase 1 (see `01_Project_Overview/Scope.md`) |

## Socket.io Event Contract

```
Namespace: /notifications
Room: user:<userId>

Server → Client event: "notification:new"
Payload: { id, type, message, createdAt }
```

---

*See also: [API_Standards.md](./API_Standards.md) · [../02_Requirement/FunctionalRequirements.md#9-fr-notif--notifications](../02_Requirement/FunctionalRequirements.md)*
