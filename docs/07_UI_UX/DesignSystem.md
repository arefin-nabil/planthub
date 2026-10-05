# UI/UX Design System — PlantHub Bangladesh

**Document Version:** 1.0
**Status:** Draft — Development Phase
**Last Updated:** 2026-08-06

---

## 1. Design Philosophy

- **Modern** — clean layouts, no visual clutter
- **Nature-Inspired** — organic shapes, green palette, imagery-forward
- **Clean & Minimal** — generous whitespace, restrained UI chrome
- **Image-Focused** — plants are a visual product; photography leads
- **Mobile-First** — designed for small screens first, scaled up
- **Fast & User-Friendly** — low cognitive load, especially for nursery owners with limited technical literacy

## 2. Design Inspiration Reference

| Reference | What We Borrow |
|---|---|
| Amazon | Marketplace browsing, filtering, and trust patterns (reviews, ratings) |
| Shopify | Seller/nursery-owner dashboard clarity and simplicity |
| Pinterest | Visual, image-grid discovery experience |

## 3. Color Palette

| Role | Color | Usage |
|---|---|---|
| Primary Green | `#2E7D32` | Primary buttons, active states, brand |
| Dark Green | `#1B5E20` | Headers, emphasis, hover states |
| Light Green | `#81C784` | Secondary accents, badges |
| Forest Green | `#0F3D24` | Dark backgrounds/text-on-light contexts |
| Leaf Green (accent) | `#43A047` | Links, highlights |
| Light Lime (accent) | `#AEEA00` | Sparingly — promo/campaign highlights only |
| Soft White | `#FAFAF7` | Page backgrounds |
| Natural Gray | `#6B6F68` | Secondary text, borders |

*(Exact hex values are a starting proposal — to be finalized with a visual designer/Figma file; kept here as the working reference until then.)*

## 4. Typography

- **Headings:** A clean geometric or humanist sans-serif (e.g. Inter, Poppins) — friendly but professional
- **Body:** Same family or a highly-legible pairing at 16px base size for mobile readability
- **Numerals:** Tabular figures for price displays and dashboard tables

## 5. Core UI Patterns

### 5.1 Product Card
Image (dominant) → Name → Price → Nursery name/badge → Wishlist icon

### 5.2 Trust Signals
Verification badge, star rating, review count, and "X sold" surfaced consistently on product cards, product pages, and nursery profile headers

### 5.3 Nursery Dashboard
Left sidebar navigation (Products / Inventory / Orders / Analytics / Customers), top summary cards (today's sales, pending orders, low-stock count), following the Shopify-style seller dashboard pattern

### 5.4 Order Status Display
Horizontal stepper: Pending → Confirmed → Packed → Shipped → Delivered, with Cancelled/Returned shown as a distinct state style (not on the happy-path stepper)

### 5.5 Notification Feed
Grouped by unread/read, icon per notification type, relative timestamps ("2h ago")

## 6. Responsive Breakpoints (Proposed)

| Breakpoint | Width | Primary Target |
|---|---|---|
| `sm` | ≥ 375px | Mobile (design baseline) |
| `md` | ≥ 768px | Tablet |
| `lg` | ≥ 1024px | Desktop / Nursery Dashboard |
| `xl` | ≥ 1280px | Large desktop |

## 7. Accessibility Baseline

- Minimum 4.5:1 text contrast ratio against backgrounds
- All interactive elements reachable via keyboard
- Form inputs always have visible labels (not placeholder-only)
- Images (especially plant photos used for identification) carry descriptive `alt` text

## 8. Open Items

- [ ] Finalize exact color hex values and full type scale in Figma
- [ ] Icon set selection (e.g. Lucide, Phosphor)
- [ ] Component library decision (custom vs. Shadcn/UI-equivalent for chosen frontend framework)

---

*Related: [04_Architecture/Architecture.md](../04_Architecture/Architecture.md)*
