# Use Cases — PlantHub Bangladesh

**Document Version:** 1.0
**Status:** Draft — Development Phase
**Last Updated:** 2026-08-06

---

## 1. Actors

- **Customer**
- **Nursery Owner**
- **Plant Expert**
- **Platform Administrator**
- *(System)* — automated processes (notifications, invoice generation, low-stock alerts)

## 2. Use Case Diagram (Textual)

```
Customer ──> Browse Plants
Customer ──> Search / Filter Plants
Customer ──> Manage Wishlist
Customer ──> Follow Nursery
Customer ──> Place Order
Customer ──> Track Order
Customer ──> Submit Review / Growth Timeline
Customer ──> Book Consultation
Customer ──> Read Blog / Guide

Nursery Owner ──> Manage Products
Nursery Owner ──> Manage Inventory
Nursery Owner ──> Manage Pricing
Nursery Owner ──> Manage Orders
Nursery Owner ──> View Analytics
Nursery Owner ──> Manage Customers
Nursery Owner ──> Generate Invoice
Nursery Owner ──> Apply for Verification

Plant Expert ──> Manage Profile
Plant Expert ──> Accept Consultation Booking
Plant Expert ──> Conduct Chat / Image Review Consultation
Plant Expert ──> Write Blog
Plant Expert ──> View Earnings

Administrator ──> Verify Nursery / Expert
Administrator ──> Moderate Content
Administrator ──> Manage Users
Administrator ──> Manage Commission Rates
Administrator ──> View Platform Analytics
```

## 3. Detailed Use Cases

### UC-01: Place Order
- **Actor:** Customer
- **Preconditions:** Customer is logged in; product is in stock
- **Main Flow:**
  1. Customer adds product(s) to cart
  2. Customer proceeds to checkout, selects delivery address
  3. Customer selects payment method (COD or online)
  4. System validates stock availability
  5. System creates order with status `Pending`
  6. System notifies nursery owner of new order
  7. System sends order confirmation to customer
- **Alternate Flow:** If stock is insufficient at checkout, system blocks order and notifies customer
- **Related Requirements:** FR-MKT-04, FR-NUR-06, FR-NOTIF-03

### UC-02: Manage Inventory
- **Actor:** Nursery Owner
- **Preconditions:** Nursery owner is verified and logged in
- **Main Flow:**
  1. Owner opens Inventory Management screen
  2. Owner updates current stock or logs incoming stock
  3. System records the change in stock history
  4. System checks stock against low-stock threshold
  5. If below threshold, system triggers a low-stock alert notification
- **Related Requirements:** FR-NUR-02, FR-NUR-03, FR-NOTIF-03

### UC-03: Book Consultation
- **Actor:** Customer, Plant Expert
- **Preconditions:** Expert has an active, verified profile with available time slots
- **Main Flow:**
  1. Customer browses expert list, selects an expert
  2. Customer selects an available time slot
  3. Customer completes online payment
  4. System confirms booking and notifies both parties
  5. At the scheduled time, chat/image-review consultation session opens
- **Related Requirements:** FR-CON-01–04, FR-NOTIF-02

### UC-04: Nursery Verification
- **Actor:** Nursery Owner, Administrator
- **Main Flow:**
  1. Owner submits verification request with mobile OTP, National ID, nursery photos, business info
  2. System marks status as "Pending Review"
  3. Admin reviews submitted documents
  4. Admin approves (status → Verified) or rejects with reason
  5. Owner may later apply for Premium Verified (manual admin review)
- **Related Requirements:** FR-VER-01–03, FR-ADM-02

### UC-05: Submit Growth Timeline Review
- **Actor:** Customer
- **Preconditions:** Customer has a delivered order for the product
- **Main Flow:**
  1. Customer uploads a photo + rating at Day 1
  2. System prompts customer at Day 30/90/180 to add further photos
  3. Growth timeline is displayed on the product/nursery page
- **Related Requirements:** FR-REV-01, FR-REV-02

### UC-06: Creator Commission Attribution
- **Actor:** Plant Expert (as content creator), System
- **Main Flow:**
  1. Expert publishes a blog referencing a product or consultation offer
  2. Customer reads the blog and, within 30 days, purchases the referenced product or books the referenced consultation
  3. System attributes the transaction to the blog and calculates creator commission
- **Related Requirements:** FR-KH-03

---

*See also: [UserStories.md](./UserStories.md) · [02_Requirement/FunctionalRequirements.md](../02_Requirement/FunctionalRequirements.md)*
