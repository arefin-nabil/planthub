# Database Schema — PlantHub Bangladesh

**Document Version:** 1.0
**Status:** Draft — Development Phase
**Last Updated:** 2026-08-06
**ORM:** Prisma · **Database:** MongoDB

---

## 1. Entity Overview

```
User ──┬── NurseryProfile ──┬── Product ──┬── InventoryLog
       │                    │             ├── PriceTier
       │                    │             └── Review ── GrowthPhoto
       │                    ├── Order ── OrderItem
       │                    └── Campaign / Bundle
       │
       ├── ExpertProfile ── Consultation ── TimeSlot
       │
       ├── Wishlist
       ├── Follow
       ├── Notification
       └── Blog ── CommissionAttribution
```

## 2. Prisma Schema (`prisma/schema.prisma`)

```prisma
generator client {
  provider = "prisma-client-js"
}

datasource db {
  provider = "mongodb"
  url      = env("DATABASE_URL")
}

// ─────────────────────────────
// ENUMS
// ─────────────────────────────

enum Role {
  CUSTOMER
  NURSERY_OWNER
  PLANT_EXPERT
  ADMIN
}

enum VerificationLevel {
  UNVERIFIED
  VERIFIED
  PREMIUM_VERIFIED
}

enum OrderStatus {
  PENDING
  CONFIRMED
  PACKED
  SHIPPED
  DELIVERED
  CANCELLED
  RETURNED
}

enum PaymentMethod {
  COD
  BKASH
  NAGAD
  SSLCOMMERZ
}

enum PaymentStatus {
  UNPAID
  PAID
  SETTLED
  FAILED
  REFUNDED
}

enum ConsultationType {
  CHAT
  IMAGE_REVIEW
}

enum ConsultationStatus {
  BOOKED
  IN_PROGRESS
  COMPLETED
  CANCELLED
}

// ─────────────────────────────
// CORE USER MODELS
// ─────────────────────────────

model User {
  id            String   @id @default(auto()) @map("_id") @db.ObjectId
  name          String
  email         String   @unique
  phone         String   @unique
  passwordHash  String
  role          Role
  isOtpVerified Boolean  @default(false)
  createdAt     DateTime @default(now())
  updatedAt     DateTime @updatedAt

  nurseryProfile NurseryProfile?
  expertProfile  ExpertProfile?
  orders         Order[]
  wishlist       Wishlist[]
  follows        Follow[]
  reviews        Review[]
  notifications  Notification[]
  blogs          Blog[]

  @@map("users")
}

model NurseryProfile {
  id                 String             @id @default(auto()) @map("_id") @db.ObjectId
  ownerId            String             @unique @db.ObjectId
  owner              User               @relation(fields: [ownerId], references: [id])
  shopName           String
  slug               String             @unique
  description        String?
  address            String?
  latitude            Float?
  longitude           Float?
  verificationLevel  VerificationLevel  @default(UNVERIFIED)
  nationalIdDocUrl   String?
  galleryUrls        String[]
  createdAt          DateTime           @default(now())
  updatedAt          DateTime           @updatedAt

  products   Product[]
  campaigns  Campaign[]
  bundles    Bundle[]

  @@map("nursery_profiles")
}

model ExpertProfile {
  id                String             @id @default(auto()) @map("_id") @db.ObjectId
  userId            String             @unique @db.ObjectId
  user              User               @relation(fields: [userId], references: [id])
  bio               String?
  experienceYears   Int?
  portfolioUrls     String[]
  verificationLevel VerificationLevel  @default(UNVERIFIED)
  createdAt         DateTime           @default(now())

  consultations Consultation[]
  timeSlots     TimeSlot[]

  @@map("expert_profiles")
}

// ─────────────────────────────
// PRODUCT / INVENTORY / PRICING
// ─────────────────────────────

model Product {
  id             String   @id @default(auto()) @map("_id") @db.ObjectId
  nurseryId      String   @db.ObjectId
  nursery        NurseryProfile @relation(fields: [nurseryId], references: [id])
  name           String
  category       String
  isIndoor       Boolean
  plantType      String[]   // e.g. ["fruit", "flower", "medicinal", "air-purifying"]
  sunlightNeed   String     // e.g. "low" | "medium" | "high"
  waterNeed      String     // e.g. "low" | "medium" | "high"
  description    String?
  careGuide      String?
  imageUrls      String[]
  videoUrls      String[]
  isArchived     Boolean  @default(false)
  createdAt      DateTime @default(now())
  updatedAt      DateTime @updatedAt

  inventory   Inventory?
  priceTiers  PriceTier[]
  reviews     Review[]
  orderItems  OrderItem[]
  wishlistedBy Wishlist[]

  @@map("products")
}

model Inventory {
  id               String   @id @default(auto()) @map("_id") @db.ObjectId
  productId        String   @unique @db.ObjectId
  product          Product  @relation(fields: [productId], references: [id])
  currentStock     Int      @default(0)
  incomingStock    Int      @default(0)
  lowStockThreshold Int     @default(5)
  updatedAt        DateTime @updatedAt

  history InventoryLog[]

  @@map("inventory")
}

model InventoryLog {
  id          String   @id @default(auto()) @map("_id") @db.ObjectId
  inventoryId String   @db.ObjectId
  inventory   Inventory @relation(fields: [inventoryId], references: [id])
  change      Int       // positive = restock, negative = sold/adjustment
  reason      String    // "sale" | "restock" | "manual_adjustment"
  createdAt   DateTime  @default(now())

  @@map("inventory_logs")
}

model PriceTier {
  id          String   @id @default(auto()) @map("_id") @db.ObjectId
  productId   String   @db.ObjectId
  product     Product  @relation(fields: [productId], references: [id])
  type        String   // "retail" | "wholesale" | "dealer" | "campaign" | "discount"
  price       Float
  validFrom   DateTime?
  validTo     DateTime?

  @@map("price_tiers")
}

// ─────────────────────────────
// ORDERS / PAYMENTS
// ─────────────────────────────

model Order {
  id             String        @id @default(auto()) @map("_id") @db.ObjectId
  customerId     String        @db.ObjectId
  customer       User          @relation(fields: [customerId], references: [id])
  nurseryId      String        @db.ObjectId
  status         OrderStatus   @default(PENDING)
  deliveryAddress String
  totalAmount    Float
  paymentMethod  PaymentMethod
  paymentStatus  PaymentStatus @default(UNPAID)
  createdAt      DateTime      @default(now())
  updatedAt      DateTime      @updatedAt

  items OrderItem[]

  @@map("orders")
}

model OrderItem {
  id         String  @id @default(auto()) @map("_id") @db.ObjectId
  orderId    String  @db.ObjectId
  order      Order   @relation(fields: [orderId], references: [id])
  productId  String  @db.ObjectId
  product    Product @relation(fields: [productId], references: [id])
  quantity   Int
  unitPrice  Float

  @@map("order_items")
}

// ─────────────────────────────
// REVIEWS / GROWTH TIMELINE
// ─────────────────────────────

model Review {
  id         String   @id @default(auto()) @map("_id") @db.ObjectId
  productId  String   @db.ObjectId
  product    Product  @relation(fields: [productId], references: [id])
  customerId String   @db.ObjectId
  customer   User     @relation(fields: [customerId], references: [id])
  rating     Int
  comment    String?
  createdAt  DateTime @default(now())

  growthPhotos GrowthPhoto[]

  @@map("reviews")
}

model GrowthPhoto {
  id        String   @id @default(auto()) @map("_id") @db.ObjectId
  reviewId  String   @db.ObjectId
  review    Review   @relation(fields: [reviewId], references: [id])
  dayLabel  Int      // 1, 30, 90, 180
  imageUrl  String
  createdAt DateTime @default(now())

  @@map("growth_photos")
}

// ─────────────────────────────
// CONSULTATION
// ─────────────────────────────

model TimeSlot {
  id         String         @id @default(auto()) @map("_id") @db.ObjectId
  expertId   String         @db.ObjectId
  expert     ExpertProfile  @relation(fields: [expertId], references: [id])
  startTime  DateTime
  endTime    DateTime
  isBooked   Boolean        @default(false)

  @@map("time_slots")
}

model Consultation {
  id         String              @id @default(auto()) @map("_id") @db.ObjectId
  customerId String              @db.ObjectId
  expertId   String              @db.ObjectId
  expert     ExpertProfile       @relation(fields: [expertId], references: [id])
  type       ConsultationType
  status     ConsultationStatus  @default(BOOKED)
  timeSlotId String              @db.ObjectId
  amountPaid Float
  createdAt  DateTime            @default(now())

  @@map("consultations")
}

// ─────────────────────────────
// KNOWLEDGE HUB
// ─────────────────────────────

model Blog {
  id           String   @id @default(auto()) @map("_id") @db.ObjectId
  authorId     String   @db.ObjectId
  author       User     @relation(fields: [authorId], references: [id])
  title        String
  content      String
  category     String   // "guide" | "disease" | "fertilizer" | "seasonal-tip" | "success-story"
  isApproved   Boolean  @default(false)
  linkedProductId    String? @db.ObjectId
  linkedConsultationOfferId String?
  createdAt    DateTime @default(now())

  attributions CommissionAttribution[]

  @@map("blogs")
}

model CommissionAttribution {
  id          String   @id @default(auto()) @map("_id") @db.ObjectId
  blogId      String   @db.ObjectId
  blog        Blog     @relation(fields: [blogId], references: [id])
  triggeringOrderId String?
  triggeringConsultationId String?
  commissionAmount Float
  createdAt   DateTime @default(now())

  @@map("commission_attributions")
}

// ─────────────────────────────
// ENGAGEMENT
// ─────────────────────────────

model Wishlist {
  id         String   @id @default(auto()) @map("_id") @db.ObjectId
  customerId String   @db.ObjectId
  customer   User     @relation(fields: [customerId], references: [id])
  productId  String   @db.ObjectId
  product    Product  @relation(fields: [productId], references: [id])
  createdAt  DateTime @default(now())

  @@unique([customerId, productId])
  @@map("wishlists")
}

model Follow {
  id         String   @id @default(auto()) @map("_id") @db.ObjectId
  customerId String   @db.ObjectId
  customer   User     @relation(fields: [customerId], references: [id])
  nurseryId  String   @db.ObjectId
  createdAt  DateTime @default(now())

  @@unique([customerId, nurseryId])
  @@map("follows")
}

model Campaign {
  id         String   @id @default(auto()) @map("_id") @db.ObjectId
  nurseryId  String   @db.ObjectId
  nursery    NurseryProfile @relation(fields: [nurseryId], references: [id])
  title      String
  startDate  DateTime
  endDate    DateTime

  @@map("campaigns")
}

model Bundle {
  id          String   @id @default(auto()) @map("_id") @db.ObjectId
  nurseryId   String   @db.ObjectId
  nursery     NurseryProfile @relation(fields: [nurseryId], references: [id])
  title       String
  productIds  String[] @db.ObjectId
  bundlePrice Float

  @@map("bundles")
}

// ─────────────────────────────
// NOTIFICATIONS
// ─────────────────────────────

model Notification {
  id         String   @id @default(auto()) @map("_id") @db.ObjectId
  userId     String   @db.ObjectId
  user       User     @relation(fields: [userId], references: [id])
  type       String   // e.g. "ORDER_UPDATE", "LOW_STOCK", "NEW_REVIEW"
  message    String
  isRead     Boolean  @default(false)
  createdAt  DateTime @default(now())

  @@map("notifications")
}
```

## 3. Notes on Modeling Choices

- **References over embedding:** Because Prisma's MongoDB connector models relations via `@db.ObjectId` references (not native embedded documents), all relations here use reference IDs — this keeps the schema close to a relational mental model, which is easier to reason about and migrate later if needed.
- **`Inventory` split from `Product`:** kept as its own model (1:1) so inventory writes (high frequency) don't require rewriting the whole product document.
- **`InventoryLog`** gives a full audit trail for stock changes — required for `NFR-MAINT` traceability and for the Analytics Dashboard's inventory reports.
- **Price as an array (`PriceTier`)** instead of fixed columns, so new price types can be added without a schema migration.
- **`Blog.linkedConsultationOfferId`** is left as a loose string for now — to be tightened once the consultation "offer" concept (vs. ad-hoc booking) is finalized.

---

*See also: [Indexes.md](./Indexes.md) · [04_Architecture/Architecture.md](../04_Architecture/Architecture.md)*
