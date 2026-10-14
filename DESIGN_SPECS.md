# Koins Savings App – Design Specifications

> Last updated to match 100% of the original Technical Assessment requirements.

---

## Shared / Global Patterns

### Theme
- Material 3 + Koins brand colours
- Primary: `#22C55E`
- Background: Soft mint `#F0FDF4`
- Surface: White
- Text: Dark green `#064E3B`
- Consistent 12–16px border radius
- Inter typography

### Common Components
- Primary Button: Full-width, filled green, height 52px
- Secondary Button: Outlined green
- Input Fields: Outlined, filled white, clear focus state
- Cards: White, subtle border or light elevation, 12–16px radius
- Loading: Centered circular progress (green)
- Empty State: Icon + title + optional subtitle + action
- Error State: Icon + message + Retry button
- AppBar: Clean white, title left-aligned, optional actions
- Snackbar: Floating, dark background for success/error messages
- **Icons**: Used consistently on quick actions, product cards, profile, and empty/error states

### Navigation
```
Login
  └── Dashboard
        ├── Create Savings
        ├── Savings Products
        │     └── Savings Details
        │           └── Create Savings (pre-filled)
        └── Profile
              └── Logout → Login
```
- No bottom navigation for v1
- Use AppBar back buttons + Dashboard as hub

### Currency
- Always display as `₦` with thousand separators (e.g. ₦850,000)

---

## 1. Login Screen

**Purpose**  
Allow user to sign in with mock credentials and proceed to the app.

**Layout Hierarchy (top → bottom)**
1. Safe area / status bar
2. Top spacing + App Logo (centered)
3. Title: “Welcome Back”
4. Subtitle: “Sign in to continue to Koins”
5. Email field
6. Password field (with show/hide toggle)
7. “Forgot Password?” (right-aligned, non-functional)
8. Primary Login button
9. “Don’t have an account? Register” (non-functional)
10. Bottom safe area

**Key Components**
- Logo
- Two text form fields
- Primary button
- Two text buttons (Forgot Password, Register)

**States**
- Default
- Loading (button shows spinner, fields disabled)
- Validation errors under fields
- Error snackbar on wrong credentials

**Validation**
- Email: required + valid email format
- Password: required + minimum 8 characters

**Interactions**
- Successful login (mock: `test@bank.com` / `Password123`) → navigate to Dashboard and persist login state
- Wrong credentials → show error snackbar “Invalid email or password”
- Forgot Password / Register → do nothing (or show “Coming soon” snackbar)

**Notes**
- Keyboard should push content up
- Autofill hints enabled
- Password obscured by default

---

## 2. Dashboard Screen

**Purpose**  
Home screen showing greeting, total savings, quick actions, recent savings plans, and API-driven content.

**Layout Hierarchy**
1. AppBar: “Dashboard” (optional logo)
2. Greeting section: “Good Morning, John Doe”
3. Total Savings card (large, prominent)
   - Label: “Total Savings”
   - Value: ₦850,000
4. Quick Actions row (two equal cards/buttons **with icons**)
   - Create Savings (icon: add / savings)
   - View Products (icon: list / grid)
5. Section header: “Recent Savings”
6. List of 3 recent savings cards
7. **“Financial Tips” section** (API-driven)
   - Header: “Financial Tips”
   - 2–3 cards showing title + body from public API (dummyjson posts)
8. Bottom safe area

**Key Components**
- Greeting text
- Large summary card
- Two quick-action cards/buttons with icons
- List of savings summary cards
- API content cards (Financial Tips)

**Recent Savings Card Content**
- Plan name (e.g. Emergency Fund)
- Amount (₦120,000)
- Frequency (Monthly)

**States**
- Default (with mock data)
- Empty recent savings (if none created yet)
- Loading (initial + API section)
- Error state on API failure (show retry on tips section only)

**Interactions**
- “Create Savings” → Create Savings screen
- “View Products” → Savings Products screen
- Tap recent savings card → (optional) Details or do nothing for v1
- Pull-to-refresh (bonus)

**Notes**
- Greeting changes based on time of day
- Total savings can later become dynamic (sum of created plans)
- **API Integration location**: Financial Tips section on Dashboard (using `https://dummyjson.com/posts`)

---

## 3. Savings Products Screen

**Purpose**  
Display list of available savings products.

**Layout Hierarchy**
1. AppBar: “Savings Products” + back button
2. Optional search bar (bonus)
3. Vertical list of product cards
4. Bottom safe area

**Product Card Content**
- Leading icon (recommended)
- Product name (bold)
- Interest rate (highlighted in green)
- Short Description
- Duration
- “View Details” button

**Products with Descriptions**

| Product            | Interest | Duration   | Short Description                                      |
|--------------------|---------|------------|--------------------------------------------------------|
| Target Savings     | 12%     | 12 Months  | Save towards a specific goal with competitive returns. |
| Fixed Deposit      | 18%     | 6 Months   | Lock funds for a fixed period and earn higher interest.|
| Education Savings  | 10%     | Flexible   | Flexible savings plan designed for education goals.    |
| Vacation Savings   | 8%      | Flexible   | Build your travel fund at your own pace.               |

**States**
- Loading
- Success (list)
- Empty
- Error (with retry)

**Interactions**
- Tap card or “View Details” → Savings Details screen (pass selected product)
- Back → Dashboard

**Notes**
- Cards should have consistent height and spacing
- Interest rate should stand out (green colour)

---

## 4. Savings Details Screen

**Purpose**  
Show detailed information about a selected savings product and allow user to start creating a plan.

**Layout Hierarchy**
1. AppBar: Product name or “Plan Details” + back
2. Optional hero / header section
3. Plan Name (large)
4. Interest Rate (prominent)
5. Minimum Deposit
6. Duration
7. Short description
8. Primary button: “Create Savings”
9. Bottom safe area

**Data to Display**
- Plan Name: e.g. Target Savings
- Interest Rate: 12%
- Minimum Deposit: ₦5,000
- Duration: 12 Months
- Short description (from product data)

**States**
- Default
- Loading (if fetching)

**Interactions**
- “Create Savings” → Create Savings screen (pre-select the product in dropdown)
- Back → Products list

---

## 5. Create Savings Screen

**Purpose**  
Allow user to create a new savings plan.

**Layout Hierarchy**
1. AppBar: “Create Savings Plan” + back
2. Form fields (scrollable):
   - Savings Name (text)
   - Product Type (dropdown)
   - Target Amount (number)
   - Monthly Contribution (number)
   - Duration (text or dropdown)
3. Primary button: “Create”
4. Bottom safe area

**Validation**
- All fields required
- Amounts must be valid positive numbers

**States**
- Default
- Validation errors under fields
- Loading (button spinner)
- Success → Snackbar “Savings Created Successfully” → navigate back to Dashboard

**Interactions**
- On success: save plan locally + show success message + return to Dashboard
- Back → previous screen

**Notes**
- Dropdown options come from the products list
- If navigated from Details, pre-select that product
- Use number keyboard for amount fields

---

## 6. Profile Screen

**Purpose**  
Show user information and allow logout.

**Layout Hierarchy**
1. AppBar: “Profile” + back
2. Avatar / initials circle (with person icon)
3. Full Name
4. Email
5. Phone Number
6. Spacer
7. Logout button (outlined or text)
8. Bottom safe area

**Data (Mock)**
- Full Name: John Doe
- Email: test@bank.com
- Phone: +234 801 234 5678

**Interactions**
- Logout → clear local session → navigate to Login (clear back stack)

**Notes**
- Keep simple and clean
- No edit functionality required

---

## Data & API Notes

- Login is mock only
- Products are hardcoded with full descriptions
- Created savings plans must be persisted locally (Hive or SharedPreferences)
- Logged-in user must be persisted
- **API Integration**: Fetch posts from `https://dummyjson.com/posts` and display 2–3 items in the “Financial Tips” section on the Dashboard
- Total Savings on Dashboard starts as static ₦850,000 (can later sum created plans)

---

## Coverage Checklist (vs Original Assessment)

- [x] Login fields + non-functional links
- [x] Email & Password validation
- [x] Mock credentials & navigate to Dashboard
- [x] Dashboard greeting + Total Savings ₦850,000
- [x] Quick actions with icons
- [x] Recent Savings – 3 mock plans
- [x] Products list – Name, Interest, Short Description, View Details
- [x] Example products with rates, durations & descriptions
- [x] Details – Name, Interest, Min Deposit ₦5,000, Duration, Create button
- [x] Create Savings – all 5 fields + validation
- [x] Success message + return to Dashboard
- [x] Profile – Name, Email, Phone, Logout
- [x] Material 3, spacing, typography, icons
- [x] Loading / Empty / Error states
- [x] Persist logged-in user + created plans
- [x] API – retrieve at least one dataset and display it
