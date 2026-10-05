# API — Plants (Products)

**Document Version:** 1.0
**Status:** Draft — Development Phase
**Last Updated:** 2026-08-06
**Base Path:** `/v1/products`

---

## GET /products

Browse/search/filter plants. Public endpoint.

**Query Params:**
`page, limit, search, category, isIndoor, plantType, sunlightNeed, waterNeed, minPrice, maxPrice, nurseryId`

**Response `200`:**
```json
{
  "success": true,
  "data": [ { "id": "...", "name": "...", "category": "...", "price": 350, "imageUrls": ["..."] } ],
  "pagination": { "page": 1, "limit": 20, "total": 210, "totalPages": 11 }
}
```

---

## GET /products/:id

Product detail page.

**Response `200`:**
```json
{
  "success": true,
  "data": {
    "id": "...",
    "name": "...",
    "description": "...",
    "careGuide": "...",
    "imageUrls": ["..."],
    "videoUrls": ["..."],
    "priceTiers": [ { "type": "retail", "price": 350 } ],
    "stock": { "currentStock": 12, "isLowStock": false },
    "reviews": [ ],
    "relatedProducts": [ ],
    "nursery": { "id": "...", "shopName": "...", "verificationLevel": "VERIFIED" }
  }
}
```
**Errors:** `404 PRODUCT_NOT_FOUND`

---

## POST /products *(Nursery Owner only)*

**Auth:** Bearer token, role `NURSERY_OWNER`

**Body:**
```json
{
  "name": "string",
  "category": "string",
  "isIndoor": true,
  "plantType": ["fruit"],
  "sunlightNeed": "medium",
  "waterNeed": "low",
  "description": "string",
  "careGuide": "string",
  "imageUrls": ["string"],
  "initialStock": 20,
  "prices": [ { "type": "retail", "price": 350 } ]
}
```
**Response `201`:** `{ "success": true, "data": { "id": "..." } }`
**Errors:** `400 VALIDATION_ERROR`, `403 FORBIDDEN`

---

## PUT /products/:id *(Nursery Owner — own product only)*
Updates product fields. Same body shape as create (partial allowed).
**Errors:** `403 NOT_PRODUCT_OWNER`, `404 PRODUCT_NOT_FOUND`

## DELETE /products/:id *(Nursery Owner)*
Soft-deletes (archives) the product — see `POST /products/:id/archive` for explicit archive action.
**Response `204`**

## POST /products/:id/archive *(Nursery Owner)*
Sets `isArchived = true` without deleting historical order data.

## POST /products/:id/duplicate *(Nursery Owner)*
Creates a copy of the product (new id, same fields, stock reset to 0).
**Response `201`:** `{ "success": true, "data": { "id": "<new-id>" } }`

---

## Wishlist

### POST /products/:id/wishlist *(Customer)*
Adds product to wishlist. **Response `201`**

### DELETE /products/:id/wishlist *(Customer)*
Removes product from wishlist. **Response `204`**

---

## Inventory (Nursery Owner)

### PATCH /products/:id/inventory
**Body:** `{ "change": 10, "reason": "restock" }`
**Response `200`:** `{ "success": true, "data": { "currentStock": 22 } }`
**Side effect:** creates an `InventoryLog` entry; triggers `FR-NOTIF-03` low-stock alert if resulting stock ≤ threshold

### GET /products/:id/inventory/history
Returns paginated `InventoryLog` entries for the product.

---

*See also: [API_Standards.md](./API_Standards.md) · [../02_Requirement/FunctionalRequirements.md#2-fr-mkt--marketplace](../02_Requirement/FunctionalRequirements.md)*
