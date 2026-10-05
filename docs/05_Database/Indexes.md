# Database Indexes — PlantHub Bangladesh

**Document Version:** 1.0
**Status:** Draft — Development Phase
**Last Updated:** 2026-08-06

---

## 1. Purpose

This document tracks intentional indexes on MongoDB collections (via Prisma `@@index`/`@@unique`), the query pattern each one supports, and why it exists — so indexes aren't added or removed without understanding their impact.

## 2. Index Plan

| Collection | Field(s) | Type | Supports |
|---|---|---|---|
| `users` | `email` | unique | Login lookup, duplicate prevention |
| `users` | `phone` | unique | OTP login/verification lookup |
| `nursery_profiles` | `ownerId` | unique | 1:1 lookup from User |
| `nursery_profiles` | `slug` | unique | Public profile page routing (`/nursery/:slug`) |
| `products` | `nurseryId` | index | "All products for this nursery" (dashboard) |
| `products` | `category, isIndoor, plantType, sunlightNeed, waterNeed` | compound index | Marketplace filter queries (FR-MKT-03) |
| `products` | `name` | text index | Plant name search (FR-MKT-02) |
| `inventory` | `productId` | unique | 1:1 lookup from Product |
| `inventory_logs` | `inventoryId, createdAt` | compound index | Stock history, sorted by time |
| `price_tiers` | `productId, type` | compound index | Fetch active price for a given tier |
| `orders` | `customerId, createdAt` | compound index | "My orders" list, sorted recent-first |
| `orders` | `nurseryId, status` | compound index | Nursery order-management dashboard filtered by status |
| `order_items` | `orderId` | index | Fetch line items for an order |
| `order_items` | `productId` | index | Best-selling product analytics |
| `reviews` | `productId, createdAt` | compound index | Product page review list |
| `growth_photos` | `reviewId, dayLabel` | compound index | Ordered growth timeline |
| `time_slots` | `expertId, startTime` | compound index | Expert's available slots, chronological |
| `time_slots` | `isBooked` | index | Filter free slots quickly |
| `consultations` | `customerId, createdAt` | compound index | Customer's consultation history |
| `consultations` | `expertId, status` | compound index | Expert's active/upcoming bookings |
| `blogs` | `authorId` | index | Expert's own blog list |
| `blogs` | `isApproved, category` | compound index | Public knowledge hub browsing |
| `wishlists` | `customerId, productId` | unique | Prevent duplicate wishlist entries |
| `follows` | `customerId, nurseryId` | unique | Prevent duplicate follows |
| `campaigns` | `nurseryId, startDate, endDate` | compound index | Active campaign lookups |
| `notifications` | `userId, isRead, createdAt` | compound index | Unread-first notification feed |

## 3. Guidelines for Adding New Indexes

- Every new index must map to a real, documented query pattern (list it here with the requirement/use-case it supports)
- Avoid indexing low-cardinality boolean fields alone (e.g. `isArchived`) — combine with a more selective field
- Text search indexes (`name`) should be reviewed if/when Elasticsearch or Atlas Search is introduced for the "Future AI Search" roadmap item
- Re-evaluate this table during load testing (see `09_Testing/TestPlan.md`) before production launch

---

*See also: [Schema.md](./Schema.md)*
