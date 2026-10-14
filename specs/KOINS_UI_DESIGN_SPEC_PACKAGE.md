# Koins Savings App – Master UI/UX Design Specification Package

> **Design Agent Handoff Package**  
> **Target Audience:** UI/UX Design Agents, Design Systems Engineers, Product Designers  
> **Application:** Koins Savings App (Consumer Fintech / Digital Microfinance Bank)  
> **Market:** Nigeria / Sub-Saharan Africa (`₦` NGN currency)  

---

## 1. Executive Design Brief & Creative Vision

### Brand Identity
- **Product Name:** Koins Savings (Koins MFB)
- **Category:** Modern Consumer WealthTech & Micro-Savings App
- **Benchmark / Competitor Aesthetics:** Revolut, Monzo, Kuda Bank, PiggyVest, Cowrywise, Cash App.
- **Core Emotional Tone:** Trustworthy, effortless, vibrant, modern, and encouraging. It should feel like a premier digital private vault, not a boring legacy banking portal.

### Current Problem Statement
The current implementation adheres functionally to user flows, but appears visually flat, sterile, and boxy:
1. **Lack of Elevation & Depth:** Cards rely on hard 1px outline borders (`#CBD5E1`) rather than soft ambient shadows and layered depth.
2. **Typography Monotony:** Numbers and balances lack typographic dynamism, character spacing, and modern tabular lining.
3. **Flat Backgrounds:** Screens use a flat single-tone `#F0FDF4` background without subtle mesh gradients, blur filters, or tactile card surfaces.
4. **Sterile Micro-Components:** Input fields, dropdowns, and quick actions lack micro-animations, rich tactile press states, and elevated badge styling.

### Creative Goal for the Design Agent
Create a **next-generation, award-winning fintech interface** (iOS & Android) that elevates Koins into a sleek, premium, high-retention savings experience while preserving 100% of the underlying business logic.

---

## 2. Global Design System & Foundations

### Core Color Palette (Calibrated via Pixel Litmus Test)

| Token | Hex Code | Role | Description |
| :--- | :--- | :--- | :--- |
| `primary` | `#0B9234` | Brand Primary | Deep authoritative banking emerald (sampled from proposed mockup hero balances and action buttons) |
| `primaryDark` | `#076B24` | Primary Dark | Pressed button states, deep active borders |
| `primaryContainer` | `#E2F8E7` | Surface Tint | Soft mint circular containers and pill badges |
| `textPrimary` | `#001D0B` | Primary Text | Deep forest black for ultra-crisp headings and text legibility |
| `textSecondary` | `#475569` | Secondary Text | Muted slate for subtitles, secondary labels |
| `textTertiary` | `#94A3B8` | Tertiary Text | Subtle borders and placeholder text |
| `surface` | `#FFFFFF` | Card Surface | Pure crisp white for cards and input containers |
| `background` | `#FFFFFF` | App Canvas | Pure white canvas (eliminating murky green haze across screens) |
| `backgroundSubtle`| `#FAFCFA` | Subtle Backdrop | Barely perceptible off-white for ambient card separation |
| `error` | `#EF4444` | Semantic Error | Validation warnings, error banners |

### Typography Tokens (Inter / Plus Jakarta Sans)

| Role | Size | Weight | Line Height | Usage |
| :--- | :--- | :--- | :--- | :--- |
| **Display Large** | 32–36sp | Bold (800) | 1.15 | Main Hero Balances (e.g. `₦850,000` in `#0B9234`) |
| **Headline Medium** | 22–24sp | Bold (700) | 1.25 | Screen titles ("Welcome Back", "Dashboard") |
| **Title Medium** | 16–18sp | Semi-Bold (600)| 1.3 | Card headers, section titles |
| **Body Medium** | 14sp | Regular (400) | 1.5 | Explanatory descriptions, tips |
| **Label Small** | 11–12sp | Bold (700) | 1.0 | Micro-badges (`NGN`, `% p.a.`, `Active`) |

### Surface, Elevation & Radius Tokens (`AppRadius`)
- **Base Border Radius:** 
  - `AppRadius.input`: 14px (input field containers)
  - `AppRadius.button`: 14px (buttons)
  - `AppRadius.card`: 16px (elevated cards)
  - `AppRadius.tag`: 6px (`NGN` currency tag)
  - `AppRadius.badge`: 4px (`View All` touch target)
  - `AppRadius.snackBar`: 12px (floating snackbar)
- **Shadow Style:** Ambient soft shadow (`box-shadow: 0 4px 16px -2px rgba(0, 29, 11, 0.05)`)
- **Card Borders:** 1px border with `#E5E7EB` or `rgba(0, 29, 11, 0.08)` for clean separation against pure white canvas.

---

## 3. Screen Specifications & Reference Benchmarks

### Screen 00: Splash Screen
![Splash Screen Reference](00_splash.jpg)

- **Purpose:** First impression brand splash while session is restored (1.8s duration).
- **Core Elements:**
  - Official Koins geometric faceted/origami "K" brand emblem.
  - "Koins" wordmark + "MFB" sub-brand.
  - Minimal animated loader (2.5px stroke emerald ring).
- **Design Directives:** Clean, confident, uncluttered. Soft ambient light behind the emblem.

---

### Screen 01: Authentication / Login
![Login Screen Reference](01_login.jpg)

- **Purpose:** Frictionless biometric/credential authentication.
- **Layout Flow (Top → Bottom):**
  1. Top spacing + Koins emblem.
  2. "Welcome Back" greeting (`#064E3B`, bold 24sp).
  3. "Sign in to continue to Koins" subtitle.
  4. **Email Field:** Outlined white pill card, leading green mail icon, clear floating label.
  5. **Password Field:** Outlined white pill card, leading green lock icon, eye toggle suffix.
  6. **"Forgot Password?"**: Right-aligned green text action.
  7. **Primary Button:** Full-width 52px emerald green pill with white bold "Login".
  8. **Footer:** "Don't have an account? Register".
- **Design Directives:** High-trust feel, generous touch targets (≥48dp), zero visual noise.

---

### Screen 02: Dashboard (Home Hub)
![Dashboard Reference](02_dashboard.jpg)

- **Purpose:** Primary hub displaying aggregate net worth, quick actions, active plans, and financial advice.
- **Key Sections:**
  1. **Top Bar:** "Dashboard" title + circular Profile avatar icon.
  2. **Personalized Greeting:** "Good Morning, John Doe" (dynamic based on time of day).
  3. **Total Savings Hero Card:**
     - Label: "Total Savings" in muted slate.
     - Value: `₦850,000` displayed in prominent deep emerald `#0B9234` typography.
  4. **Quick Actions (Row of 2 Cards):**
     - Card A: `[+]` Soft mint badge + "Create Savings" + chevron `>`.
     - Card B: `[Piggy/Vault]` Soft mint badge + "View Products" + chevron `>`.
  5. **Recent Savings Section:**
     - Header: "Recent Savings" + right-aligned "View All >" link.
     - 3 Active Plan Cards: Icon badge + Plan Name + Frequency + Amount (`₦120,000 >`).
  6. **Financial Tips (API-Driven):**
     - Clean elevated white cards with leading topic badges (lightbulb, target, shield), clean 2-line preview, and options overflow icon (`⋮`).
  7. **Bottom Navigation Bar:**
     - 4 Tabs: `Dashboard` (active, filled icon + green label), `Savings` (wallet), `Transactions` (receipt), `More` (dots).
- **Design Directives:** Clean white canvas (`#FFFFFF`), high visual hierarchy; primary numbers must pop instantly in deep emerald `#0B9234`; anchored with bottom navigation bar.

---

### Screen 03: Savings Products Catalog
![Products Screen Reference](03_products.jpg)

- **Purpose:** Showcase 4 distinct savings instruments with their yields and lock-in terms.
- **Product Matrix:**
  1. **Target Savings:** 12% p.a. | 12 Months | Flag icon | Goal-oriented returns.
  2. **Fixed Deposit:** 18% p.a. | 6 Months | Lock icon | High-yield term deposit.
  3. **Education Savings:** 10% p.a. | Flexible | School cap icon | School & tuition fund.
  4. **Vacation Savings:** 8% p.a. | Flexible | Airplane icon | Travel & lifestyle pool.
- **Card Architecture:**
  - Header row: Circular icon container + Product Name + Duration + Bold Green Yield (`12% p.a.` in `#0B9234`).
  - Short description (2 lines maximum).
  - Outlined "View Details" button spanning full card width with `AppRadius.button`.
- **Design Directives:** Pure white canvas (`#FFFFFF`), cards separated with subtle 1px border (`#E5E7EB`) and soft shadows.

---

### Screen 04: Product Details / Plan Overview
![Product Details Reference](04_product_details.jpg)

- **Purpose:** Deep dive on a single savings instrument before onboarding.
- **Layout Architecture:**
  1. **Hero Header:** Large 96dp soft green circular badge with prominent theme icon.
  2. **Title & Rate:** e.g., "Target Savings" with large display `12% p.a.` in `#0B9234`.
  3. **Feature Specifications Card:**
     - Key Metric 1: Minimum Deposit (`₦5,000`) with circular wallet badge.
     - Key Metric 2: Duration (`12 Months`) with circular calendar badge.
  4. **Product Terms & Benefits Body:** Clean descriptive text with 1.5 line height.
  5. **Sticky CTA:** Full-width deep emerald "Create Savings" button pinned at bottom with `AppRadius.button`.
- **Design Directives:** Crisp key-value layout, pure white canvas (`#FFFFFF`), reassuring financial terms.

---

### Screen 05: Create Savings Plan (Goal Setup)
![Create Savings Reference](05_create_savings.jpg)

- **Purpose:** Multi-step or seamless single-page setup for user's new savings target.
- **Two-Tier Field Container Pattern (Critical Visual Match):**
  - Rather than floating notch labels that break the border, each field is built as a distinct labeled card/block:
    1. **Field Title:** Prominently placed outside and directly above the input box (14sp, Semi-Bold, `#001D0B`).
    2. **Input Box Container:** White 52dp box with `AppRadius.input` (14px) and subtle 1px border (`#E2E8F0`).
    3. **Vertical Alignment:** Prefix symbol/icon (`₦` / pencil / piggy bank / calendar), editable text hint/value, and suffix tag (`NGN`) MUST be strictly vertically centered on the exact same horizontal axis (`Alignment.center`).
- **Form Architecture:**
  1. Header: "Create Savings Plan" + explanatory subtitle.
  2. **Savings Name Block:** Title "Savings Name" on top; input box with pencil icon and hint "Enter savings name".
  3. **Product Type Block:** Title "Product Type" on top; dropdown container with piggy bank icon and dropdown arrow.
  4. **Target Amount Block:** Title "Target Amount" on top; input box with centered `₦` prefix, hint "Enter target amount", and right-aligned centered `NGN` chip (`AppRadius.tag`).
  5. **Monthly Contribution Block:** Title "Monthly Contribution" on top; input box with centered `₦` prefix, hint "Enter monthly contribution", and right-aligned centered `NGN` chip (`AppRadius.tag`).
  6. **Duration Block:** Title "Duration" on top; dropdown container with calendar icon and "Select duration".
  7. **Motivational Banner:** Mint green security banner with `Icons.verified_user` (*"Your savings plan helps you stay consistent and achieve your financial goals."*) with `AppRadius.card`.
  8. **Action Button:** Full-width "Create" CTA with `AppRadius.button`.
- **Design Directives:** Two-tier standalone label on top + inner box below pattern; perfect vertical centering; crisp white canvas (`#FFFFFF`).

---

### Screen 06: Profile & Security
![Profile Reference](06_profile.jpg)

- **Purpose:** User profile overview, account verification badges, and secure logout.
- **Key Elements:**
  1. **Avatar Circle:** Enlarged soft mint circle (radius 64 / diameter 128) with person emblem stacked above large bold "JD" initials (`32sp` bold `#001D0B`).
  2. **User Identity:** "John Doe" (bold 24sp `#001D0B`).
  3. **Verified Credentials:** High legibility with bold icons and clear typography:
     - Email row: `Icons.mail_outline` + `test@bank.com`.
     - Phone row: `Icons.phone_outlined` + `+234 801 234 5678`.
  4. **Logout Action:** Outlined forest green button (`#001D0B`) with logout icon and `AppRadius.button`.
- **Design Directives:** Clean pure white background (`#FFFFFF`), generous avatar scale, high legibility.

---

## 4. Ready-to-Use Prompts for Design Agents

### Prompt A: For Generative UI Tools (v0 / Galileo / Figma AI)
```text
Design a hyper-modern, award-winning mobile fintech app called "Koins Savings".
Theme: Clean soft mint (#F0FDF4) canvas, pure white floating cards with soft ambient drop-shadows,
vibrant emerald green (#22C55E) primary buttons and accents, deep forest green (#064E3B) typography.
Currency: Nigerian Naira (₦).
Include:
1. Splash Screen with faceted geometric origami "K" logo.
2. Login Screen with pill inputs, green icon prefixes, and clean typography.
3. Dashboard with total savings card (₦850,000), quick actions with circular badges and chevrons,
   recent savings list tiles, and white financial tips cards with topic icons.
4. Products Catalog with 4 cards highlighting interest rates (12%, 18%, 10%, 8% p.a.).
5. Product Details with large hero icon and key spec cards.
6. Create Savings Plan form with NGN currency chips and motivational security banner.
7. Profile Screen with initials avatar and clean outline icons.
Make the design look like Revolut meets Apple Design Awards.
```

### Prompt B: For Visual Concept Generation (Midjourney / DALL-E)
```text
Mobile app UI design for a high-end modern savings and investment app, Koins Bank.
Sleek fintech mobile screens displayed in an iPhone 16 mockup, emerald green and mint color palette,
clean card layouts, bold currency typography ₦850,000, minimalist icons,
Apple design style, Dribbble trending, soft ambient lighting, ultra-clean UI/UX, 8k resolution. --ar 16:9
```
