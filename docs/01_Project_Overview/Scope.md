# Project Scope — PlantHub Bangladesh

**Document Version:** 1.0
**Status:** Draft — Development Phase
**Last Updated:** 2026-08-06

---

## 1. Purpose

This document defines the functional boundaries of the PlantHub Bangladesh platform for the current development phase. It answers: *what are we building now, and what are we deliberately deferring?*

## 2. In Scope — Phase 1 (Current Development)

### 2.1 User Roles
- Customer
- Nursery Owner
- Plant Expert
- Platform Administrator

### 2.2 Marketplace
- Product browsing, search, and filtering (name, category, indoor/outdoor, plant type, sunlight/water requirement, price range)
- Product detail pages (images, price, stock, care guide, delivery info, reviews, related products, nursery info)
- Wishlist
- Bundle products (e.g., Kitchen Garden Set)
- Seasonal campaigns

### 2.3 Nursery Management
- Product management (create/update/delete/archive/duplicate)
- Inventory management (current stock, incoming stock, stock history, low-stock alerts, out-of-stock status)
- Pricing management (retail, wholesale, dealer, campaign, discount price)
- Order management with defined status flow: Pending → Confirmed → Packed → Shipped → Delivered / Cancelled / Returned
- Customer management (profile, purchase history, favourites, total spend)
- Analytics dashboard (sales, revenue, orders, customer growth, best sellers)
- Automatic invoice generation (PDF)

### 2.4 Public Nursery Profile
- Gallery, owner info, description, address/location, contact info, products, reviews, ratings, verified badge

### 2.5 Verification System
- Nursery verification (Unverified → Verified → Premium Verified)
- Expert verification (experience, portfolio, optional certificates/interview)

### 2.6 Expert Consultation
- Expert selection, appointment booking, time slot selection, online payment
- Consultation type at launch: **Chat** and **Image Review** (Audio/Video deferred — see Non-Goals)

### 2.7 Knowledge Hub
- Blogs, plant guides, disease guides, fertilizer guides, seasonal tips, success stories
- Creator economy: blog → purchase / blog → consultation commission attribution (30-day window)

### 2.8 Reviews & Growth Timeline
- Photo reviews; Day 1 / 30 / 90 / 180 growth timeline per purchased plant

### 2.9 Notifications
- In-app notifications
- Real-time notifications via Socket.io
- Push notifications (mobile) — planned
- Email notifications
- (SMS is out of scope for Phase 1 — see below)

### 2.10 Payments
- Cash on Delivery
- Online payment gateway integration (bKash / Nagad / SSLCommerz — to be finalized in `06_API/Payments.md`)

## 3. Out of Scope — Phase 1

| Feature | Deferred To |
|---|---|
| AI Disease Detection, AI Recommendation, AI Smart Search, AI Product Description Generator, AI Analytics, AI Chat Assistant | Phase 3 |
| Video / Audio consultation calls | Phase 2/3 |
| Courier API integration, live delivery tracking | Phase 2 |
| SMS notifications | Phase 2 |
| Multi-branch nursery, employee management | Phase 2 |
| Produce marketplace, Plant Passport | Phase 2 |
| Weather-based care reminders | Phase 2 |
| Additional roles: Delivery Partner, Nursery Employee, Affiliate, Content Moderator, Super Admin | Architecture must allow adding these later without redesign (see `04_Architecture.md`) |

## 4. Technology Boundary

This project's implementation stack (as decided by the development team, distinct from the client's originally suggested stack) is fixed as:

- **Backend:** Node.js, Express.js, TypeScript
- **ORM:** Prisma
- **Database:** MongoDB
- **Auth:** JWT + Role-Based Access Control (RBAC)
- **Real-time:** Socket.io
- Common supporting packages as needed (validation, logging, file upload, etc. — tracked in `04_Architecture.md`)

Frontend, storage, and deployment stack choices will be documented in `04_Architecture.md` once decided.

## 5. Assumptions & Constraints

- Single-country launch: Bangladesh only, BDT currency
- Mobile-first usage pattern assumed for the majority of customers
- Nursery owners may have limited technical literacy — dashboard UX must stay simple
- Development is ongoing and may pause/resume over long gaps — documentation must remain self-sufficient (no undocumented tribal knowledge)

---

*Related documents: [Vision.md](./Vision.md) · [Goals.md](./Goals.md)*
