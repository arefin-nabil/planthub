# Functional Requirements — PlantHub Bangladesh

**Document Version:** 1.0
**Status:** Draft — Development Phase
**Last Updated:** 2026-08-06
**Standard Reference:** Structured per IEEE 830 conventions (full SRS in `IEEE830_SRS.md`)

---

## Notation
Each requirement has an ID in the form `FR-<Module>-<Number>` for traceability into use cases, API docs, and test cases.

---

## 1. FR-AUTH — Authentication & Account Management

| ID | Requirement |
|---|---|
| FR-AUTH-01 | The system shall allow a user to register as Customer, Nursery Owner, or Plant Expert with email/phone + password |
| FR-AUTH-02 | The system shall authenticate users using JWT (access + refresh token pattern) |
| FR-AUTH-03 | The system shall enforce Role-Based Access Control (RBAC) on every protected route |
| FR-AUTH-04 | The system shall support mobile OTP verification during nursery/expert registration |
| FR-AUTH-05 | The system shall allow password reset via email/OTP |

## 2. FR-MKT — Marketplace

| ID | Requirement |
|---|---|
| FR-MKT-01 | The system shall allow customers to browse plants with pagination |
| FR-MKT-02 | The system shall support search by plant name |
| FR-MKT-03 | The system shall support filtering by category, indoor/outdoor, plant type (fruit/flower/medicinal/air-purifying), sunlight requirement, water requirement, and price range |
| FR-MKT-04 | The system shall allow customers to view a product detail page including images, video, price, stock, care guide, delivery info, reviews, related products, and nursery info |
| FR-MKT-05 | The system shall allow customers to add/remove products to/from a wishlist |
| FR-MKT-06 | The system shall allow customers to follow a nursery |
| FR-MKT-07 | The system shall support bundle products (grouped product listings sold as a set) |
| FR-MKT-08 | The system shall support seasonal campaigns with campaign-specific pricing and visibility windows |

## 3. FR-NUR — Nursery Management

| ID | Requirement |
|---|---|
| FR-NUR-01 | The system shall allow a nursery owner to create, update, delete, archive, and duplicate a product |
| FR-NUR-02 | The system shall track current stock, incoming stock, and stock history per product |
| FR-NUR-03 | The system shall trigger a low-stock alert when stock falls below a configurable threshold |
| FR-NUR-04 | The system shall automatically mark a product "Out of Stock" when stock reaches zero |
| FR-NUR-05 | The system shall support multiple price tiers per product: retail, wholesale, dealer, campaign, discount |
| FR-NUR-06 | The system shall allow nursery owners to manage orders through the status flow: Pending → Confirmed → Packed → Shipped → Delivered, with Cancelled/Returned as terminal alternate states |
| FR-NUR-07 | The system shall maintain a customer profile per nursery including purchase history, favourite plants, and total spend |
| FR-NUR-08 | The system shall provide an analytics dashboard: daily/monthly sales, revenue, orders, customer growth, best-selling and most-viewed products, inventory reports |
| FR-NUR-09 | The system shall auto-generate a downloadable/printable PDF invoice per order |

## 4. FR-PROF — Public Nursery Profile

| ID | Requirement |
|---|---|
| FR-PROF-01 | The system shall expose a public nursery profile page at a unique slug (e.g. `/nursery/:slug`) |
| FR-PROF-02 | The profile shall display gallery, owner info, description, address/map, contact info, products, reviews, ratings, and verification badge |

## 5. FR-VER — Verification

| ID | Requirement |
|---|---|
| FR-VER-01 | The system shall support a 3-tier nursery verification status: Unverified, Verified, Premium Verified |
| FR-VER-02 | Verified status shall require mobile OTP, National ID, nursery photos, and business information |
| FR-VER-03 | Premium Verified status shall require manual admin review and grant higher search ranking |
| FR-VER-04 | The system shall support expert verification based on experience, portfolio, and optional certificates/interview |

## 6. FR-CON — Expert Consultation

| ID | Requirement |
|---|---|
| FR-CON-01 | The system shall allow a customer to browse and select a plant expert |
| FR-CON-02 | The system shall allow a customer to book an appointment in an available time slot |
| FR-CON-03 | The system shall require online payment to confirm a consultation booking |
| FR-CON-04 | The system shall support Chat and Image Review consultation types at launch |

## 7. FR-KH — Knowledge Hub

| ID | Requirement |
|---|---|
| FR-KH-01 | The system shall allow verified experts/creators to write and submit blogs for admin approval |
| FR-KH-02 | The system shall support content categories: plant guides, disease guides, fertilizer guides, seasonal tips, success stories |
| FR-KH-03 | The system shall track blog-to-purchase and blog-to-consultation attribution within a 30-day window and calculate creator commission accordingly |

## 8. FR-REV — Reviews & Growth Timeline

| ID | Requirement |
|---|---|
| FR-REV-01 | The system shall allow customers to submit a photo review with rating for a purchased product |
| FR-REV-02 | The system shall allow a customer to upload growth-timeline photos at Day 1, 30, 90, and 180 for a purchased plant |

## 9. FR-NOTIF — Notifications

| ID | Requirement |
|---|---|
| FR-NOTIF-01 | The system shall deliver real-time notifications via Socket.io for order status changes |
| FR-NOTIF-02 | The system shall send in-app notifications for: new arrivals, followed-nursery updates, order/delivery/payment updates, wishlist restock, campaigns, care reminders, consultation reminders, new blog posts |
| FR-NOTIF-03 | The system shall send nursery notifications for: new order, low stock, new review, customer message, payment settlement, campaign performance |
| FR-NOTIF-04 | The system shall send admin notifications for: verification requests, abuse reports, failed payments, platform alerts |
| FR-NOTIF-05 | The system shall support email notification channel in addition to in-app/real-time |

## 10. FR-ADM — Platform Administration

| ID | Requirement |
|---|---|
| FR-ADM-01 | The system shall allow admins to manage users (view, suspend, delete) |
| FR-ADM-02 | The system shall allow admins to approve/reject nursery and expert verification requests |
| FR-ADM-03 | The system shall allow admins to moderate content (blogs, reviews) |
| FR-ADM-04 | The system shall allow admins to configure and manage commission rates |
| FR-ADM-05 | The system shall provide platform-wide analytics and reporting to admins |

## 11. FR-PAY — Payments

| ID | Requirement |
|---|---|
| FR-PAY-01 | The system shall support Cash on Delivery as a payment method |
| FR-PAY-02 | The system shall support online payment gateway integration (bKash / Nagad / SSLCommerz) |
| FR-PAY-03 | The system shall record payment settlement status per order and make it visible to the nursery owner |

---

*See also: [NonFunctionalRequirements.md](./NonFunctionalRequirements.md) · [03_System_Analysis/UseCases.md](../03_System_Analysis/UseCases.md)*
