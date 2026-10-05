---
name: Sobujayon Botanical
colors:
  surface: '#f8faf9'
  surface-dim: '#d8dada'
  surface-bright: '#f8faf9'
  surface-container-lowest: '#ffffff'
  surface-container-low: '#f2f4f3'
  surface-container: '#eceeed'
  surface-container-high: '#e6e9e8'
  surface-container-highest: '#e1e3e2'
  on-surface: '#191c1c'
  on-surface-variant: '#414844'
  inverse-surface: '#2e3131'
  inverse-on-surface: '#eff1f0'
  outline: '#717973'
  outline-variant: '#c1c8c2'
  surface-tint: '#3f6653'
  primary: '#012d1d'
  on-primary: '#ffffff'
  primary-container: '#1b4332'
  on-primary-container: '#86af99'
  inverse-primary: '#a5d0b9'
  secondary: '#2c694e'
  on-secondary: '#ffffff'
  secondary-container: '#aeeecb'
  on-secondary-container: '#316e52'
  tertiary: '#3e1e00'
  on-tertiary: '#ffffff'
  tertiary-container: '#583311'
  on-tertiary-container: '#d09b70'
  error: '#ba1a1a'
  on-error: '#ffffff'
  error-container: '#ffdad6'
  on-error-container: '#93000a'
  primary-fixed: '#c1ecd4'
  primary-fixed-dim: '#a5d0b9'
  on-primary-fixed: '#002114'
  on-primary-fixed-variant: '#274e3d'
  secondary-fixed: '#b1f0ce'
  secondary-fixed-dim: '#95d4b3'
  on-secondary-fixed: '#002114'
  on-secondary-fixed-variant: '#0e5138'
  tertiary-fixed: '#ffdcc2'
  tertiary-fixed-dim: '#f4bb8e'
  on-tertiary-fixed: '#2e1500'
  on-tertiary-fixed-variant: '#653e1b'
  background: '#f8faf9'
  on-background: '#191c1c'
  surface-variant: '#e1e3e2'
typography:
  display:
    fontFamily: Inter, Hind Siliguri, sans-serif
    fontSize: 36px
    fontWeight: '600'
    lineHeight: 44px
    letterSpacing: -0.02em
  headline-lg:
    fontFamily: Inter, Hind Siliguri, sans-serif
    fontSize: 28px
    fontWeight: '600'
    lineHeight: 36px
    letterSpacing: -0.015em
  headline-md:
    fontFamily: Inter, Hind Siliguri, sans-serif
    fontSize: 22px
    fontWeight: '600'
    lineHeight: 28px
    letterSpacing: -0.01em
  headline-sm:
    fontFamily: Inter, Hind Siliguri, sans-serif
    fontSize: 18px
    fontWeight: '600'
    lineHeight: 24px
  body-lg:
    fontFamily: Inter, Hind Siliguri, sans-serif
    fontSize: 16px
    fontWeight: '400'
    lineHeight: 24px
  body-md:
    fontFamily: Inter, Hind Siliguri, sans-serif
    fontSize: 14px
    fontWeight: '400'
    lineHeight: 20px
  body-sm:
    fontFamily: Inter, Hind Siliguri, sans-serif
    fontSize: 12px
    fontWeight: '400'
    lineHeight: 16px
  label-lg:
    fontFamily: Inter, Hind Siliguri, sans-serif
    fontSize: 14px
    fontWeight: '500'
    lineHeight: 18px
    letterSpacing: 0.01em
  label-md:
    fontFamily: Inter, Hind Siliguri, sans-serif
    fontSize: 12px
    fontWeight: '500'
    lineHeight: 16px
    letterSpacing: 0.02em
  label-sm:
    fontFamily: Inter, Hind Siliguri, sans-serif
    fontSize: 11px
    fontWeight: '600'
    lineHeight: 14px
    letterSpacing: 0.04em
  numeric-price:
    fontFamily: Inter, sans-serif
    fontSize: 20px
    fontWeight: '600'
    lineHeight: 24px
    letterSpacing: -0.02em
rounded:
  sm: 0.25rem
  DEFAULT: 0.5rem
  md: 0.75rem
  lg: 1rem
  xl: 1.5rem
  full: 9999px
spacing:
  gutter: 1rem
  gutter-sm: 0.75rem
  margin: 1.25rem
  margin-compact: 1rem
  space-xs: 0.25rem
  space-sm: 0.5rem
  space-md: 1rem
  space-lg: 1.5rem
  space-xl: 2rem
---

## Brand & Style

This design system expresses a luxury botanical marketplace crafted with high-end iOS sensibilities. It merges organic serenity with disciplined, gallery-like minimalism. The experience is tailored for urban plant collectors, interior curators, and botanical enthusiasts who value clean lines, tranquil pacing, and premium product presentation.

The visual style synthesizes soft minimalism and refined glassmorphism:
- **Spatial Tranquility:** Expansive negative space allows plant specimens, bespoke ceramic vessels, and horticultural narratives to breathe.
- **Glassmorphism:** Polished, semi-translucent frosted surfaces with delicate specular highlights mirror dew on leaf foliage and high-end greenhouse architecture.
- **Tactile Softness:** Substantial card rounding (up to 30px) paired with feathered ambient shadows creates a soft, thumb-friendly mobile canvas that feels native to modern iOS interfaces.
- **Atmospheric Palette:** Deep evergreen tones establish authority and luxury, balanced against airy botanical whites and grounded terracotta warmth.

## Colors

The palette draws directly from living canopies and artisan pottery, carefully calibrated for balanced contrast on iOS displays:

- **Primary Canvas (`#F9FBFA`):** A whisper-soft, mint-tinted white base that eliminates glare while providing an organic freshness superior to sterile grey.
- **Elevated Surfaces (`#FFFFFF`):** Pure white reserved for layered cards, modals, and input fields to construct crisp foreground hierarchy.
- **Deep Forest Evergreen (`#1B4332`):** The primary anchor used for prominent headlines, dark navigation bars, and luxury badge accents.
- **Action Emerald (`#2D6A4F`):** The primary interaction tone for high-priority CTA buttons, active tab indicators, and progress tracks.
- **Terracotta Accent (`#B5835A`):** Warm clay undertones applied selectively for price tags, care requirement badges (light/water meters), seasonal tags, and bookmark states.
- **Typography Neutrals:** Primary text (`#111E16`) guarantees WCAG AAA legibility with deep botanical warmth; secondary body and metadata (`#607268`) remain calm and de-emphasized.
- **Micro-Borders (`#E8EFEA`):** Subtle leaf-vein borders for glass edges, hair-thin dividers, and stroke accents that structure elements without heavy visual noise.

## Typography

The dual-script typographic pairing balances technical precision with graceful Eastern script geometry.

- **Primary Latin & Numerals (`Inter`):** Renders prices, botanical taxonomic indices, measurements (cm/in/liters), and structural UI labels with high metric neutrality and tabular legibility.
- **Bengali Script (`Hind Siliguri`):** Handles all Bengali headings, narrative product descriptions, plant origins, and cultural curation tags. Its open counters and clean humanist terminal strokes echo natural botanical structures.
- **Fallback Chain:** Fonts must fall back seamlessly: `Inter, 'Hind Siliguri', -apple-system, BlinkMacSystemFont, sans-serif`.
- **Rhythm & Optical Alignment:** Display and large headlines leverage subtle negative tracking (`-0.015em` to `-0.02em`) to echo contemporary iOS editorial layout, while micro labels adopt slight positive tracking for scannability on dense care guides.

## Layout & Spacing

The layout is optimized for high-density, touch-centric iOS interactions centered around a 390px base viewport width.

- **Grid Architecture:** A fluid 4-column layout engineered for standard mobile screen widths with `1.25rem` (20px) outer margins and `1rem` (16px) gutters between product columns.
- **Vertical Cadence:** Strict 4px/8px baseline rhythm across layout components. Small spacing (`0.5rem` / 8px) clusters related tags (light, water, humidity meters), medium spacing (`1rem` / 16px) establishes card interior margins, and large spacing (`1.5rem` / 24px to `2rem` / 32px) separates curated nursery sections.
- **Viewport Safe Zones:** Bottom navigation and floating checkout CTAs reserve an extra `2.125rem` (34px) bottom clearance accommodating the iOS home indicator bar. Top app headers accommodate notch and dynamic island clearances dynamically.

## Elevation & Depth

Visual hierarchy uses ethereal daylight physics rather than dark, muddy dropshadows:

- **Level 0 (Base Canvas):** Flat `#F9FBFA` canvas without shadow.
- **Level 1 (Botanical Cards & Carousels):** Layered on white (`#FFFFFF`) with a dual-stage feathered shadow:
  - `box-shadow: 0 4px 20px -2px rgba(27, 67, 50, 0.04), 0 2px 6px -1px rgba(27, 67, 50, 0.02)`
  - Encapsulated by a crisp `1px solid #E8EFEA` outer border.
- **Level 2 (Floating Floating Action Trays & Bottom Sheets):** Elevated interactive planes:
  - `box-shadow: 0 12px 32px -4px rgba(27, 67, 50, 0.08), 0 4px 12px -2px rgba(27, 67, 50, 0.04)`
- **Glass Surfaces (Frosted Header & Care Overlays):**
  - Background: `rgba(255, 255, 255, 0.82)`
  - Blur Filter: `backdrop-filter: blur(20px) saturate(160%)`
  - Border: `1px solid rgba(255, 255, 255, 0.65)` on top and side edges; `rgba(232, 239, 234, 0.7)` underneath.

## Shapes

The design system adopts hyper-soft, pebble-like organic radii that reflect smooth stones and living leaves:

- **Large Surfaces & Cards:** Primary product cards, modal sheets, and gallery frames use generous `24px` to `30px` corner radii (`1.5rem` to `1.875rem`).
- **Input Fields & Interactive Tiles:** Standard text inputs, filter sheets, and care metrics feature `16px` (`1rem`) rounding for high touch ergonomics.
- **Buttons & System Pills:** Buttons, status badges, botanical difficulty indicators, and micro filter chips utilize fully pill-shaped geometries (`9999px`) to invite natural fingertip engagement.

## Components

### Buttons
- **Primary CTA:** Pill-shaped (`rounded-full`), height `52px`. Background `#2D6A4F`, text `#FFFFFF`, label weight `600`. Subtle downward glow: `0 8px 16px -4px rgba(45, 106, 79, 0.3)`. Active press reduces scale to `0.98` with standard iOS spring animation.
- **Secondary / Ghost Button:** Transparent background, `1.5px solid #2D6A4F`, text `#2D6A4F`, `rounded-full`.
- **Terracotta Accent Action:** Used for bespoke artisanal accessories, clay pots, and limited botanicals. Background `#B5835A`, text `#FFFFFF`.

### Cards (Product & Story)
- **Structure:** Rounded container with `26px` border-radius, background `#FFFFFF`, border `1px solid #E8EFEA`.
- **Image Treatment:** Aspect ratio 1:1 or 4:5, set against soft botanical neutral backdrop (`#F3F6F4`), seamless edge-to-edge top integration.
- **Card Content:** Compact vertical stack containing Bengali/Latin species name (`#111E16`), ceramic pot pairing badge, numeric price formatted in `Inter` (`#1B4332`), and a floating circular glass add-to-bag icon button (`36px` diameter).

### Botanical Badges & Chips
- **Care Attribute Chips (Water / Sunlight / Pet Safe):** Height `28px`, background `rgba(45, 106, 79, 0.08)`, text `#2D6A4F`, icon prefix `14px`, border-radius `9999px`.
- **Terracotta Highlight Chip:** Background `rgba(181, 131, 90, 0.12)`, text `#B5835A`, font size `11px`, letter-spacing `0.02em`.

### Lists & Care Specifications
- Row elements separated by inset dividers (`border-bottom: 1px solid #E8EFEA; margin-left: 56px`).
- Leading elements feature circular frosted-glass icons (`40px` size) housing botanical vector glyphs (watering can, daylight meter, humidity droplet).
- Trailing navigation indicator uses lightweight iOS chevron with `#607268` tint.

### Inputs & Search Bars
- **Search Header:** Height `44px`, background `rgba(240, 244, 241, 0.75)`, border `1px solid #E8EFEA`, border-radius `22px`. Left magnifying glyph `#607268`, placeholder text "অনুসন্ধান করুন (Search plants, pots...)" in `#607268`.
- **Form Inputs:** Height `52px`, background `#FFFFFF`, border `1px solid #E8EFEA`, focus state transitions to `1.5px solid #2D6A4F` without harsh browser focus rings.

### Selection Controls (Checkboxes & Radios)
- **Checkboxes:** `20px` square with `6px` radius. Inactive: `#FFFFFF` with `1.5px solid #E8EFEA`. Active: Solid `#2D6A4F` with `#FFFFFF` crisp check glyph.
- **Radio Buttons:** `20px` circle. Inactive: `#FFFFFF` with `1.5px solid #E8EFEA`. Active: White background with centered `#2D6A4F` interior dot (`10px`).