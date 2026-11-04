# MyBoardingHouse - Complete Technical Documentation

**Document Version:** 1.0  
**App Name:** (Splash: "UniStay")  
**Package Name:** com.example.myboardinghouse  
**API Level:** Min 24 | Target 34 | Compile 36  
**Technology Stack:** Jetpack Compose, Navigation Compose, Google Maps SDK, Flutterwave Payment SDK

---

## 1. SYSTEM OVERVIEW & CORE INTENT

### 1.1 Problem Statement
Unistay is a property rental platform designed to connect students/renters with landlords offering accommodation near universities. The app simplifies the boarding house discovery, comparison, and booking process for students while providing landlords with property management tools.

### 1.2 Target Users
- **Students:** University students seeking affordable boarding house accommodation
- **Landlords:** Property owners/managers renting rooms to students

### 1.3 Primary Features & Modules

| Module | Purpose | User Role |
|--------|---------|-----------|
| **Authentication** | Login/SignUp with role selection | Both |
| **House Discovery** | Browse available boarding houses with filters | Student |
| **Room Listing** | View available rooms in selected house | Student |
| **Payment Processing** | Process room booking payments via Flutterwave | Student |
| **Map Navigation** | Locate boarding houses and distance to universities | Student |
| **University Search** | Filter by proximity to educational institutions | Student |
| **Landlord Dashboard** | Manage properties, rooms, amenities | Landlord |
| **Profile Management** | User profile, accommodation history, settings | Both |
| **Customer Support** | In-app customer care contact | Both |

### 1.4 User Journey - Student Flow
```
Splash Screen (2s delay)
  ↓
Login/Signup (role: Student)
  ↓
Email Verification (OTP)
  ↓
Home Screen (Browse Houses)
  ├─ Filter by University / Location
  ├─ View House Details
  ├─ Check Available Rooms
  └─ Process Payment (Book Room)
  ↓
Success Screen → Receipt
  ↓
Account Management (Profile, Settings, My Accommodation)
```

### 1.5 User Journey - Landlord Flow
```
Splash Screen (2s delay)
  ↓
Login/Signup (role: Landlord)
  ↓
Email Verification (OTP)
  ↓
Landlord Dashboard
  ├─ View/Add Properties
  ├─ Manage Rooms
  ├─ Configure Amenities
  ├─ View Payment Details
  └─ Profile Settings
```

---

## 2. COMPLETE UI LAYOUT – EVERY SCREEN & FUNCTIONALITY

### 2.1 Splash Screen
**Route:** `splash` | **Duration:** 2 seconds

**Layout:**
- **Center Content:**
  - House emoji icon (🏠) - 120sp
  - App name "UniStay" - 48sp, Bold, Gray color
  
**Behavior:**
- Auto-navigates to Login after 2 seconds
- Pops splash from back stack to prevent return

**State Variables:**
- `LaunchedEffect` triggers timeout with `delay(2000)`

---

### 2.2 Login Screen
**Route:** `login`

**Layout:**
```
┌─────────────────────────┐
│  [Person Icon] (120dp)  │
│                         │
│     Login (42sp)        │  (Orange color)
│                         │
│ ┌─────────────────────┐ │
│ │ [Error Message]     │ │  (Red, if validation fails)
│ └─────────────────────┘ │
│                         │
│ ┌─────────────────────┐ │
│ │ Role Selector ▼     │ │  (Dropdown: Student/Landlord)
│ │ Student             │ │
│ └─────────────────────┘ │
│                         │
│ ┌─────────────────────┐ │
│ │ Phone Number        │ │  (Max 10 digits, numeric only)
│ └─────────────────────┘ │
│                         │
│ ┌─────────────────────┐ │
│ │ Password            │ │  (Hidden input)
│ └─────────────────────┘ │
│                         │
│  [Login Button]         │  (Orange background)
│  [Create Account]       │  (Text link)
└─────────────────────────┘
```

**State Variables:**
```kotlin
var phone: String                    // 0-10 digits
var password: String                 // Any
var selectedRole: String             // "Student" | "Landlord"
var expanded: Boolean                // Role dropdown expanded?
var errorMessage: String             // Validation feedback
```

**UI Elements:**

| Element | Type | Validation | Appearance |
|---------|------|-----------|-----------|
| Person Icon | Icon | N/A | Black, 120dp |
| "Login" Title | Text | N/A | Orange, 42sp, Bold |
| Error Message | Text | Empty by default | Red when error |
| Role Dropdown | OutlinedButton + DropdownMenu | "Student" \| "Landlord" | Rounded 25dp, Orange border |
| Phone Input | OutlinedTextField | 10 digits, numeric | Rounded 25dp, Orange border |
| Password Input | OutlinedTextField | Any length | Rounded 25dp, Orange border, masked |
| Login Button | Button | See validation | Orange background, Rounded 25dp |
| Create Account Link | Text (clickable) | N/A | Text color |

**Validation Rules:**
- Phone: Must be exactly 10 digits
- Password: Cannot be empty
- Both fields required

**Navigation:**
- **On Login Success:** Navigate to "home" (Student) or "landlord_home" (Landlord) with `popUpTo("login") { inclusive = true }`
- **On Create Account Click:** Navigate to "signup"

**Animation:**
- Heartbeat animation on icon (infinite 800ms scale 1.0 → 1.05)

---

### 2.3 Sign Up Screen
**Route:** `signup`

**Layout:** (Scrollable Column)
```
┌─────────────────────────┐
│  [Person Icon] (100dp)  │
│                         │
│     Sign up (42sp)      │  (Orange)
│                         │
│ ┌─────────────────────┐ │
│ │ [Error Message]     │ │
│ └─────────────────────┘ │
│                         │
│ ┌─────────────────────┐ │
│ │ Role Selector ▼     │ │  (Default: Student)
│ └─────────────────────┘ │
│                         │
│ ┌─────────────────────┐ │
│ │ Full Name           │ │
│ ├─────────────────────┤ │
│ │ Phone Number        │ │
│ ├─────────────────────┤ │
│ │ Email               │ │
│ ├─────────────────────┤ │
│ │ Password            │ │
│ ├─────────────────────┤ │
│ │ Confirm Password    │ │
│ └─────────────────────┘ │
│                         │
│  [Sign Up Button]       │
│  [Already have account? │
│   Login]                │
└─────────────────────────┘
```

**State Variables:**
```kotlin
var fullName: String
var phone: String              // 0-10 digits
var email: String
var password: String
var confirmPassword: String
var selectedRole: String       // "Student" | "Landlord"
var expanded: Boolean
var errorMessage: String
```

**Validation Rules:**
- Full Name: Required, non-empty
- Phone: Exactly 10 digits, numeric only
- Email: Required, non-empty
- Password: Required, non-empty
- Confirm Password: Must match password field

**Navigation:**
- **On Sign Up Success:** Navigate to "verification"

**Component Reuse:**
- Uses `SignUpTextField()` component for text inputs
- Uses same role selector dropdown as Login

---

### 2.4 Verification Screen
**Route:** `verification`

**Layout:**
```
┌─────────────────────────┐
│                         │
│   Verification (42sp)   │  (Orange)
│                         │
│ ┌─ ┐ ┌─ ┐ ┌─ ┐ ┌─ ┐ ┌─ ┐ │
│ │ │ │ │ │ │ │ │ │ │ │ │ │  (5 OTP input boxes)
│ └─ ┘ └─ ┘ └─ ┘ └─ ┘ └─ ┘ │
│                         │
│ Please enter the code   │
│ sent to your email      │  (Instructions)
│                         │
│ Didn't get code?        │
│ Resend in: 50s          │  (Countdown timer)
│                         │
│   [Verify Button]       │
│                         │
└─────────────────────────┘
```

**State Variables:**
```kotlin
var timerSeconds: Int = 50     // Countdown timer
```

**UI Elements:**

| Element | Type | Notes |
|---------|------|-------|
| OTP Boxes (x5) | Box with Border | 60dp each, rounded 30dp, Orange border |
| Countdown Timer | Text | Updates every 1000ms, displayed as "Resend in: Ns" |
| Instructions | Text | "Please enter the code sent to your email" |
| Verify Button | Button | 180dp width, Orange, Rounded 28dp |

**Timer Behavior:**
- Starts at 50 seconds on screen load
- Decrements every 1 second via `LaunchedEffect`
- Stops at 0 seconds
- "Resend" becomes clickable when timer reaches 0

**Navigation:**
- **On Verify Success:** Navigate to "home"

---

### 2.5 Student Home Screen
**Route:** `home`

**Layout:** (Full-screen with animated header)
```
┌──────────────────────────────┐
│  [Animated Orange Header]    │
│  [Location: Lusaka]          │  (Collapses on scroll)
│  [Search Bar] (optional)     │
└──────────────────────────────┘
│  [Sliding Advertisement]     │
│                              │
│  [Filter Buttons Row]        │
│  [University] [Filter] [▼]   │
│                              │
│  [Active Filters Grid]       │
│  (e.g., "K1000-K1500")       │
│                              │
│  [Flutterwave Test Button]   │
│  (Dev feature)               │
│                              │
│  ┌────────────────────────┐  │
│  │  House Grid Item       │  │
│  │  ┌──────────────────┐  │  │
│  │  │  [Image]         │  │  │
│  │  │  Mr Chanda BH    │  │  │
│  │  │  Kalingalinga    │  │  │
│  │  │  K1,200/m        │  │  │
│  │  └──────────────────┘  │  │
│  └────────────────────────┘  │
│                              │
└──────────────────────────────┘
     [Bottom Navigation Bar]
     [Home] [Map] [Account]
```

**State Variables:**
```kotlin
var scrollState: LazyListState         // Track scroll position
var currentTab: Int = 0                // Bottom nav selected tab
var previousIndex: Int = 0             // Track scroll direction
var previousScrollOffset: Int = 0      // Track scroll position
var isBottomBarVisible: Boolean = true // Show/hide bottom nav
var isHeaderCollapsed: Boolean         // Header collapse state
```

**Dynamic Behaviors:**

1. **Header Animation:**
   - Full height (180dp) when at top
   - Collapsed (80dp) after scrolling past first item
   - Rounded corners collapse to square
   - Uses `animateDpAsState` with 500ms tween

2. **Bottom Navigation Bar:**
   - Hidden when scrolling down (scroll offset > previous)
   - Visible when scrolling up or at top
   - Uses `slideInVertically` + `fadeIn` animations
   - Tab 0: Home | Tab 1: Map | Tab 2: Account

3. **Search Bar (Header):**
   - Only visible when header is expanded
   - Placeholder: "search town or School"
   - Leading icon: Search icon

4. **Sections (Sequential LazyColumn items):**
   - Sliding Advertisement (auto-scrolling banner)
   - Filter Buttons (University Search, Filters)
   - Active Filters Grid (displays selected criteria)
   - Flutterwave Test Button (development feature)
   - House Grid (lazy-loaded, 5+ items)

**Navigation Callbacks:**
```kotlin
onHouseClick: () -> Unit              // Navigate to "house_detail"
onUniversityClick: () -> Unit         // Navigate to "university_search"
onFilterClick: () -> Unit             // Navigate to "filters"
onMapsClick: () -> Unit               // Navigate to "map"
onAccountClick: () -> Unit            // Navigate to "account"
onLaunchCustomFlutterwave: () -> Unit // Navigate to "custom_flutterwave_launcher"
```

---

### 2.6 House Detail Screen
**Route:** `house_detail`

**Layout:** (Scrollable)
```
┌──────────────────────────────┐
│  [Large Image Banner]        │  (250dp height)
│  [Back Button (overlay)]     │
│                              │
│  Mr Chanda BH      K1,200/m  │
│  [Home Icon]                 │
│                              │
│  [Location Icon] Kalingalinga│
│                              │
│  ┌──────────────────────────┐│
│  │  Distance to University  ││  (Orange background)
│  │  [Walk Icon] 10min       ││
│  │  [Car Icon] <2mi         ││
│  └──────────────────────────┘│
│                              │
│  [Rating: ★★★★★]            │
│  (Placeholder)               │
│                              │
│  [View Rooms Button]         │  (Full width, Orange)
│                              │
│  House Amenities:            │
│  - Parking                   │
│  - WiFi                      │
│  - Kitchen                   │
│  - Water 24/7                │
│                              │
│  Contact Landlord:           │
│  [Call] [WhatsApp] [Email]   │
│                              │
└──────────────────────────────┘
```

**State Variables:**
```kotlin
// Managed by parent navigation - no local state
```

**UI Components:**

| Element | Type | Appearance |
|---------|------|-----------|
| Image Banner | Box | LightGray background, 250dp height |
| Back Button | IconButton | Positioned with statusBarsPadding |
| House Name | Text | 24sp, Bold, with home icon |
| Price | Text | 24sp, Bold, Mint Green (#2EBD8A) |
| Location | Row | With location icon |
| Distance Card | Surface | Orange background (OrangePrimary), rounded 25dp |
| Distance Icons | Icons + Text | Walking/Car icons with white tint |
| Rating Stars | Text | Placeholder (★) |
| Amenities List | Column | Grid of amenity items |
| Contact Buttons | Row | Three buttons: Call, WhatsApp, Email |
| View Rooms Button | Button | Full width, Orange, rounded 25dp |

**Navigation:**
- **Back Button:** `onBack()` → popBackStack()
- **View Rooms:** `onViewRoomsClick()` → navigate to "room_list"

---

### 2.7 Room List Screen
**Route:** `room_list`

**Layout:**
```
┌──────────────────────────────┐
│  [Back Button]               │
│                              │
│  ┌────────────────────────┐  │
│  │ ┌─────────┐            │  │
│  │ │ [Image] │ Room Type  │  │  (120dp height item)
│  │ │ 100x100 │ K1,200/m   │  │
│  │ └─────────┘            │  │
│  │         [Book] [Enquire]  │
│  └────────────────────────┘  │
│  ─────────────────────────── │  (Divider)
│                              │
│  (5+ identical items)        │
│                              │
└──────────────────────────────┘
```

**State Variables:**
```kotlin
// No local state - displays list of rooms
```

**Room Item Component:**

| Element | Type | Details |
|---------|------|---------|
| Room Image | Box | 100dp, rounded 20dp, LightGray |
| Room Type | Text | "Single Room, Selfcontained" |
| Price | Text | "K1,200/m", 24sp, Mint Green, Bold |
| Book Button | Button | Orange, rounded 20dp, flex 1 |
| Enquire Button | Button | Orange, rounded 20dp, flex 1 |

**Navigation:**
- **Back Button:** `onBackClick()`
- **Book Button:** `onBookClick()` → navigate to "payment"
- **Enquire Button:** (Placeholder, no implementation shown)

---

### 2.8 Payment Screen
**Route:** `payment`

**Layout:** (Scrollable)
```
┌──────────────────────────┐
│  [Back Button]           │
│                          │
│  ┌────────────────────┐  │
│  │ [Image]            │  │
│  │ Single Room,   K1, │  │
│  │ Selfcontained 200  │  │
│  └────────────────────┘  │
│  ═════════════════════   │
│                          │
│  Move in Date: 25/1/2025 │
│  Move out Date: 25/1/2025│
│  *note: payments monthly │
│                          │
│  ═════════════════════   │
│  Security Deposit: K250  │
│  ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ │  (Dotted)
│  Rent:         K1,200    │
│  ═════════════════════   │
│  Total:        K1,450    │  (Bold)
│                          │
│  ═════════════════════   │
│                          │
│      [Pay Button]        │  (Orange)
│                          │
└──────────────────────────┘
```

**State Variables:**
```kotlin
var toastMessage: String?      // Display feedback
```

**UI Elements:**

| Element | Type | Details |
|---------|------|---------|
| Back Button | Icon | KeyboardArrowLeft, 48dp |
| Room Card | Row | 110dp height, displays image + details |
| Date Selectors | Pair of DateSelector | "Move in Date" & "Move out Date" |
| Cost Rows | CostRow Component | Label + Amount |
| Dividers | HorizontalDivider or DottedDivider | 2dp thick (solid) or dashed pattern |
| Pay Button | Button | 70% width, 50dp height, Orange |

**Payment Flow:**
1. User clicks "Pay" button
2. Creates Intent to `FlutterwaveCheckoutActivity` with extras:
   - `EXTRA_AMOUNT`: 100.0 (test amount)
   - `EXTRA_CURRENCY`: "ZMW"
   - `EXTRA_EMAIL`: User email
   - `EXTRA_PHONE`: User phone
   - `EXTRA_FNAME`: First name
   - `EXTRA_LNAME`: Last name
   - `EXTRA_TX_REF`: Unique transaction reference
3. Launcher receives result with status (success/error/cancelled)
4. Toast message displayed with result
5. On success, calls `onPaymentSuccess()` → navigate to "success"

**Payment Integration:**
- Uses `rememberLauncherForActivityResult` with `ActivityResultContracts.StartActivityForResult()`
- Flutterwave checkout activity handles payment processing

**Navigation:**
- **Back Button:** `onBack()` → popBackStack()
- **Pay Success:** `onPaymentSuccess()` → navigate to "success"

---

### 2.9 Success Screen
**Route:** `success`

**Layout:**
```
┌──────────────────────────┐
│                          │
│  ✓ Payment Successful    │
│                          │
│  Your booking is          │
│  confirmed!               │
│                          │
│      [View Receipt]       │  (Orange button)
│      [Home]               │  (Gray button)
│      [Maps]               │  (Gray button)
│      [Account]            │  (Gray button)
│                          │
└──────────────────────────┘
```

**State Variables:**
```kotlin
// Stateless - displays success confirmation
```

**Navigation:**
```kotlin
onViewReceipt: () -> Unit      // Navigate to "receipt"
onHomeClick: () -> Unit        // Navigate to "home"
onMapsClick: () -> Unit        // Navigate to "map"
onAccountClick: () -> Unit     // Navigate to "account"
```

---

### 2.10 Receipt Screen
**Route:** `receipt`

**Layout:**
```
┌──────────────────────────┐
│  [Back Button]           │
│  Receipt                 │
│                          │
│  Booking Reference:      │
│  #BH-2025-001234         │
│                          │
│  ┌────────────────────┐  │
│  │ Room Details       │  │
│  │ Single Room        │  │
│  │ K1,200/m           │  │
│  └────────────────────┘  │
│                          │
│  Move-in: 25/1/2025      │
│  Move-out: 25/1/2025     │
│                          │
│  ┌────────────────────┐  │
│  │ Cost Breakdown     │  │
│  │ Security: K250     │  │
│  │ Rent: K1,200       │  │
│  │ ─────────────────  │  │
│  │ Total: K1,450      │  │
│  └────────────────────┘  │
│                          │
│  Paid via Flutterwave    │
│  Transaction ID: xxxxx   │
│                          │
└──────────────────────────┘
```

**State Variables:**
```kotlin
// Displays data passed from payment screen via navigation
```

---

### 2.11 Account Screen (Student)
**Route:** `account`

**Layout:**
```
┌──────────────────────────┐
│                          │
│    ┌────────────┐        │
│    │  Profile   │        │  (150dp circle, orange background)
│    │ [Person]   │        │  (Person icon inside, blue)
│    └────────────┘        │
│                          │
│    Bruce Mainza          │  (Username)
│                          │
│  ┌────────────────────┐  │
│  │ My Accommodation   │  │  (Menu items)
│  │ [Home Icon]        ├──→ onAccommodationClick
│  └────────────────────┘  │
│                          │
│  ┌────────────────────┐  │
│  │ My Profile         │  │
│  │ [Account Icon]     ├──→ onProfileClick
│  └────────────────────┘  │
│                          │
│  ┌────────────────────┐  │
│  │ Customer Care      │  │
│  │ [Call Icon]        ├──→ onCustomerCareClick
│  └────────────────────┘  │
│                          │
│  ┌────────────────────┐  │
│  │ Settings           │  │
│  │ [Settings Icon]    ├──→ onSettingsClick
│  └────────────────────┘  │
│                          │
│      [Log out Button]    │  (Orange)
│                          │
└──────────────────────────┘
     [Bottom Nav Bar]
     (Tab 2: Account highlighted)
```

**State Variables:**
```kotlin
// Stateless - displays menu items
```

**Menu Item Component (`AccountMenuItem`):**
```kotlin
@Composable
fun AccountMenuItem(label: String, icon: Int, onClick: () -> Unit) {
    // Button with icon on left, label on right
    // Full width, clickable
}
```

**Navigation:**
- **My Accommodation:** `onAccommodationClick()` → navigate to "my_accommodation"
- **My Profile:** `onProfileClick()` → navigate to "profile"
- **Customer Care:** `onCustomerCareClick()` → navigate to "customer_care"
- **Settings:** `onSettingsClick()` → navigate to "settings"
- **Log out:** `onLogoutClick()` → navigate to "login" with `popUpTo(0) { inclusive = true }`
- **Bottom Nav Home:** `onHomeClick()` → navigate to "home"
- **Bottom Nav Maps:** `onMapsClick()` → navigate to "map"

---

### 2.12 Map Screen
**Route:** `map`

**Layout:**
```
┌──────────────────────────┐
│                          │
│  ┌────────────────────┐  │
│  │                    │  │
│  │                    │  │
│  │   [Google Map]     │  │
│  │   Lusaka, Zambia   │  │  (Initial: -15.4167, 28.2833)
│  │   Zoom: 12         │  │
│  │   [Marker]         │  │
│  │                    │  │
│  │                    │  │
│  │                    │  │
│  └────────────────────┘  │
│                          │
│  ┌────────────────────┐  │
│  │ 🔍 Search for...   │  │  (Search bar overlay)
│  │    locations       │  │
│  └────────────────────┘  │
│                          │
└──────────────────────────┘
     [Bottom Nav Bar]
     (Tab 1: Map highlighted)
```

**State Variables:**
```kotlin
var searchQuery: String                 // Current search text
var cameraPositionState: CameraPositionState  // Map camera position
```

**Google Map Features:**
- Initial position: Lusaka, Zambia (latitude: -15.4167, longitude: 28.2833)
- Initial zoom: 12
- Marker: Lusaka (title, snippet)
- Zoom controls disabled
- Full screen fill

**Search Functionality:**
1. User types location name in search bar
2. Presses search (IME action)
3. Uses `Geocoder` to convert location name → lat/lng
4. Animates camera to new position with `CameraUpdateFactory.newLatLngZoom()`
5. Toast feedback for success/error

**Navigation:**
- **Bottom Nav Home:** `onHomeClick()` → navigate to "home"
- **Bottom Nav Maps:** (current tab, no action)
- **Bottom Nav Account:** `onAccountClick()` → navigate to "account"

---

### 2.13 Profile Screen (Student)
**Route:** `profile`

**Layout:** (Placeholder)
```
┌──────────────────────────┐
│  [Back Button]           │
│                          │
│  Profile Screen          │
│  Placeholder             │
│                          │
│  (Full implementation    │
│   not yet provided)      │
│                          │
└──────────────────────────┘
```

**Current Implementation:** Minimal placeholder with back button.

---

### 2.14 My Accommodation Screen
**Route:** `my_accommodation`

**Layout:** (Not detailed in code - appears to be a list of user's bookings)

---

### 2.15 Customer Care Screen
**Route:** `customer_care`

**Layout:** (Contact information and support options)

---

### 2.16 Settings Screen
**Route:** `settings`

**Layout:** (User preferences and app settings)

---

### 2.17 University Search Screen
**Route:** `university_search`

**Layout:** (Search/filter by university proximity)

---

### 2.18 Filter Screen
**Route:** `filters`

**Layout:**
```
┌──────────────────────────┐
│  [Back] Filters          │
│                          │
│  Filter options coming   │
│  soon...                 │
│                          │
│  (Future: Price range,   │
│   amenities, distance)   │
│                          │
└──────────────────────────┘
```

**Current Implementation:** Placeholder for future filters implementation.

---

### 2.19 Landlord Home Screen
**Route:** `landlord_home`

**Layout:**
```
┌──────────────────────────┐
│  ← my UniStay      [☰]   │  (CenterAlignedTopAppBar)
│                          │
│  ┌────────────────────┐  │
│  │ [Image]            │  │
│  │ Mr Chanda BH       │  │
│  │ [Location] Kaling. │  │
│  │ 50 Spaces Avail.   │  │
│  └────────────────────┘  │
│                          │
│  (4+ property cards)     │
│                          │
│  ┌─┐                     │
│  │+│  (FAB - Add House)  │
│  └─┘                     │
│                          │
│  [Home] [Notifications]  │  (BottomAppBar)
│                          │
└──────────────────────────┘
```

**Top App Bar:**
- Title: "my UniStay" (White text, Bold)
- Navigation Icon: Left arrow (KeyboardArrowLeft)
- Action Icon: Menu (hamburger)
- Background: Orange primary
- Centered layout

**Menu Dropdown:**
- Profile → `onProfileClick()`
- Customer Care → `onCustomerCareClick()`
- Log out button (Orange) → `onLogoutClick()`

**Floating Action Button (FAB):**
- White background with Orange border
- Add icon (+) inside
- Positioned at bottom center
- Size: 64dp
- Shape: Circle

**House Cards:**
- 4 cards displayed in LazyColumn
- Each card shows:
  - Image placeholder (100dp, rounded 20dp)
  - House name with icon
  - Location with icon
  - Available spaces with icon
- Click callback: `onHouseClick()`

**Bottom App Bar:**
- Orange background
- Home icon (left side)
- Notifications icon (right side)
- Height: 60dp

**Navigation:**
- **Menu Profile:** `onProfileClick()` → "landlord_profile"
- **Menu Customer Care:** `onCustomerCareClick()` → "customer_care"
- **Menu Logout:** `onLogoutClick()` → "login" with popUpTo full clear
- **FAB Add House:** `onAddHouseClick()` → "landlord_house_reg_success"
- **House Card:** `onHouseClick()` → "landlord_house_detail"

---

### 2.20 Landlord House Detail Screen
**Route:** `landlord_house_detail`

**Navigation:**
- **Rooms Button:** `onRoomsClick()` → "landlord_rooms"
- **Amenities Button:** `onAmenitiesClick()` → "landlord_amenities"
- **Back:** `onBack()` → popBackStack()

---

### 2.21 Landlord Rooms Screen
**Route:** `landlord_rooms`

**Navigation:**
- **Back:** `onBack()` → popBackStack()

---

### 2.22 Landlord Amenities Screen
**Route:** `landlord_amenities`

**Navigation:**
- **Back:** `onBack()` → popBackStack()

---

### 2.23 Landlord Profile Screen
**Route:** `landlord_profile`

**Navigation:**
- **Payment Details:** `onPaymentDetailsClick()` → "landlord_payment_details"
- **Back:** `onBack()` → popBackStack()

---

### 2.24 Landlord Payment Details Screen
**Route:** `landlord_payment_details`

**Navigation:**
- **Back:** `onBack()` → popBackStack()

---

### 2.25 Landlord Registration Success Screen
**Route:** `landlord_house_reg_success`

**Navigation:**
- **Done:** `onDone()` → popBackStack()

---

### 2.26 Bottom Navigation Bar (Reusable Component)
**Location:** `ui/components/BottomNavigationBar.kt`

**Layout:**
```
┌──────────────────────────┐
│  [Home] [Map] [Account]  │  (Rounded pill shape)
│                          │
└──────────────────────────┘
```

**Properties:**
```kotlin
selectedTabIndex: Int           // Current active tab (0, 1, or 2)
onTabSelected: (Int) -> Unit   // Callback when tab clicked
```

**Tab Configuration:**

| Tab Index | Icon | Name | Color When Selected |
|-----------|------|------|-------------------|
| 0 | ic_home | Home | Orange background, white icon |
| 1 | ic_location | Map | Orange background, white icon |
| 2 | ic_account | Account | Orange background, white icon |

**Styling:**
- Surface with white background
- Rounded 36dp corners
- Shadow elevation: 12dp
- Padding: 24dp horizontal, 12dp bottom
- Height: 72dp
- Icons when inactive: Black on transparent
- Icons when active: White on orange background (rounded 16dp)

**Appearance Pattern:**
- Inactive icon: 26dp, black, no background
- Active icon: 26dp, white, Orange background, rounded 16dp box (48dp)

---

## 3. VISUAL DESIGN SYSTEM

### 3.1 Color Palette

**Primary Colors:**
```
OrangePrimary:    #FF8C00  (RGB: 255, 140, 0)
MintGreen:        #2EBD8A  (RGB: 46, 189, 138)
```

**Neutrals:**
```
White:            #FFFFFF
Black:            #000000
GrayText:         #757575  (Neutral gray for secondary text)
LightGray:        #F5F5F5  (Background, placeholders)
BorderGray:       #E0E0E0  (Borders, dividers)
DottedLineGray:   #BDBDBD  (Dashed dividers)
LightOrange:      #FFE0B2  (Light orange tint)
```

**Material 3 Theme:**
- **Primary:** OrangePrimary (#FF8C00)
- **OnPrimary:** White
- **Secondary:** MintGreen (#2EBD8A)
- **OnSecondary:** White
- **Background:** White
- **OnBackground:** Black
- **Surface:** White
- **OnSurface:** Black
- **Outline:** OrangePrimary

**Usage Guidelines:**
- **OrangePrimary:** Buttons, headers, highlights, interactive elements
- **MintGreen:** Price displays, success states
- **White:** Backgrounds, text on orange
- **Black:** Primary text, icons
- **GrayText:** Secondary/hint text, disabled states
- **LightGray:** Placeholders, cards, section backgrounds

**Light/Dark Mode:**
- Currently light theme only
- No dark mode variants implemented

---

### 3.2 Typography

**Font Family:** Default (system sans-serif)

**Type Scale (Material 3 default with custom bodyLarge):**

| Style | Size | Weight | Line Height | Letter Spacing | Usage |
|-------|------|--------|-------------|---|---------|
| bodyLarge | 16sp | Normal | 24sp | 0.5sp | Main body text |
| Page Titles | 42sp | Bold | Default | Default | Screen titles (Login, SignUp) |
| Section Headers | 24sp | Bold | Default | Default | House names, prices |
| Subtitles | 20sp | Normal | Default | Default | Location, secondary info |
| Button Text | 20sp | Bold | Default | Default | Call-to-action buttons |
| Caption | 14sp | Normal | Default | Default | Helper text, details |
| Small Text | 11sp | Normal | Default | Default | Notes, disclaimers |

**Font Definitions:**
```kotlin
// From Type.kt
val Typography = Typography(
    bodyLarge = TextStyle(
        fontFamily = FontFamily.Default,
        fontWeight = FontWeight.Normal,
        fontSize = 16.sp,
        lineHeight = 24.sp,
        letterSpacing = 0.5.sp
    )
)
```

---

### 3.3 Icon Set

**Icon Library:** Material Icons (androidx.compose.material.icons)

**Icons Used in App:**

| Icon Name | Material Icon | Context | Size | Color |
|-----------|---------------|---------|------|-------|
| Person | Icons.Default.Person | Login, SignUp, Profile | 100-120dp | Black |
| Back/Arrow Left | Icons.Default.KeyboardArrowLeft | Navigation | 32-48dp | Black |
| Arrow Back (AutoMirrored) | Icons.AutoMirrored.Filled.ArrowBack | Navigation | 32dp | Varies |
| Dropdown | Icons.Default.KeyboardArrowDown | Dropdown toggle | Default | Black |
| Settings | Icons.Default.Settings | Settings menu | Default | Black |
| Add | Icons.Default.Add | FAB | 40dp | Black |
| Home | R.drawable.ic_home | Bottom nav, icons | 20-26dp | Varies |
| Location | R.drawable.ic_location | Location displays | 20-24dp | Varies |
| Search | Icons.Default.Search | Search bar | 24dp | Black |
| Menu | Icons.Default.Menu | Drawer toggle | 32dp | White (in Landlord) |
| Notifications | Icons.Default.Notifications | Notifications icon | Default | Varies |
| Call Center | R.drawable.ic_call_center | Customer care | 32dp | White |
| Book | R.drawable.ic_book | Amenities | 20dp | Default |
| Car | R.drawable.ic_car | Distance/Transport | 32dp | White (in card) |
| Walking | R.drawable.ic_walking | Distance/Transport | 32dp | White (in card) |
| Account | R.drawable.ic_account | Bottom nav, menus | 20-26dp | Varies |

**Custom Drawables (from resources):**
- `ic_home` - House icon
- `ic_location` - Map pin
- `ic_account` - User profile
- `ic_call_center` - Phone/support
- `ic_search` - Magnifying glass
- `ic_book` - Book/document
- `ic_car` - Vehicle
- `ic_walking` - Pedestrian
- `ic_back` - Back arrow
- `ic_launcher_foreground` / `ic_launcher_background` - App icon

**Icon Styling:**
- Default size: 24dp (for most contexts)
- Navigation: 32dp
- FAB: 40dp
- Bottom nav: 26dp
- Status bar padding: 12dp horizontal padding for icons in headers
- Tint colors: Vary by context (black on light backgrounds, white on orange)

---

### 3.4 Spacing & Grid System

**Base Unit:** 4dp (Material Design convention)

**Common Spacing Values:**

| Spacing | Value | Usage |
|---------|-------|-------|
| Extra Small | 4dp | Internal padding in compact components |
| Small | 8dp | Between inline elements, padding in buttons |
| Medium | 12dp | Between form fields, icon-text spacing |
| Standard | 16dp | Screen content padding, between sections |
| Large | 24dp | Top-level screen padding, major section gaps |
| XLarge | 32dp | Between large content blocks |
| XXLarge | 48dp | Dialog spacing |

**Padding Conventions:**

```kotlin
// Screen-level content padding
modifier = Modifier.padding(16.dp)          // Standard

// Between stacked elements
Spacer(modifier = Modifier.height(16.dp))   // Standard
Spacer(modifier = Modifier.height(32.dp))   // Large gap

// Horizontal padding for text fields
modifier = Modifier.padding(24.dp)          // Large (screen edges)

// Internal element spacing
modifier = Modifier.padding(8.dp)           // Button content
modifier = Modifier.padding(12.dp)          // Text field padding
```

**Corner Radius (Rounding):**

| Radius | Value | Usage |
|--------|-------|-------|
| Compact | 16dp | Bottom nav tab backgrounds |
| Medium | 20dp | Image placeholders, small cards |
| Standard | 25dp | Text fields, buttons, small surfaces |
| Large | 28dp | Button corner radius, dialog corners |
| Extra Large | 36dp | Bottom nav bar |
| Full Circle | 50% or `CircleShape` | Profile avatars, FAB |

**Height/Width Standards:**

| Component | Height | Width |
|-----------|--------|-------|
| Text Input | 56dp | Full width |
| Button (standard) | 50-56dp | Full width or constrained |
| Button (compact) | 40dp | Flexible width |
| FAB (Landlord) | 64dp | 64dp (circle) |
| Profile Avatar | 150dp | 150dp (circle) |
| Room Card | 120dp | Full width |
| House Card | Dynamic | Full width |
| Bottom Nav | 72dp | Full width |
| Bottom App Bar | 60dp | Full width |

---

## 4. SCREEN LINKING & NAVIGATION LOGIC

### 4.1 Complete Navigation Map (Directed Graph)

```
                         ┌─────────────┐
                         │ Splash (2s) │
                         └──────┬──────┘
                                │ (auto-navigate after timeout)
                                ▼
                    ┌───────────────────────────┐
                    │   Login Screen            │
                    │ (Role Selector)           │
                    └───┬─────────────┬─────────┘
                        │ (login)     │ (signup)
            ┌───────────┘             └──────────┐
            │                                    │
            ▼                                    ▼
        ┌──────────────┐               ┌──────────────┐
        │ Home Screen  │               │ SignUp Scr   │
        │ (Student)    │               │              │
        └──┬──┬──┬──┬──┘               └──────┬───────┘
           │  │  │  │                        │ (verify)
           │  │  │  │                        ▼
           │  │  │  │                    ┌──────────────┐
           │  │  │  │                    │ Verify Scr   │
           │  │  │  │                    │ (OTP)        │
           │  │  │  │                    └──────┬───────┘
           │  │  │  │                           │
           │  │  │  └──────┬──────┬────────┬───┼────────┐
           │  │  │         │      │        │   │        │
           ▼  ▼  ▼         ▼      ▼        ▼   ▼        ▼
        ┌────┬────┬────┬────────┬────────┬──────────┬──────────────┐
        │    │    │    │        │        │          │              │
     House Det Univ  Filters Custom  Map Screen   Account    My Accommodation
        │    │    │    │Flutt  │        │          │        │
        │    │    │    │       │        │          │        │
        ▼    ▼    ▼    ▼       ▼        ▼          ▼        ▼
    Room List         (Launch  │      [Bottom Nav Analysis]
        │            Activity) │       ├─ 0: Home
        │                      │       ├─ 1: Map
        ▼                      ▼       └─ 2: Account
    Payment ◄─────────────────┘
        │
        ▼
    Success ──────────┬─────────────────┐
        │             │                 │
        ├─ Receipt    ├─ Home           └─ [Maps/Account via Bottom Nav]
        └─ View Receipt

    ┌──────────────────────────────────────┐  LANDLORD FLOW
    │ Login (Landlord selected)            │
    └──────────────────┬───────────────────┘
                       │
                       ▼
            ┌──────────────────────┐
            │ Landlord Home        │
            │ (FAB: Add House)     │
            └──┬─────────┬─────────┘
               │         │
        ┌──────┘  ┌──────┴──────┐
        │         │   (Menu)    │
        │         │             │
        ▼         ▼             ▼
   Landlord   Landlord    Customer
   House Reg   Profile      Care
   Success     │
       │       ▼
       │   Landlord
       │   Payment
       │   Details
       │
    (popBack)

    ┌──────────────────────────────────────┐  LANDLORD DETAIL FLOW
    │ Landlord House Detail                │
    └──────────┬──────────┬────────────────┘
               │          │
               ▼          ▼
         Landlord    Landlord
         Rooms       Amenities
```

### 4.2 Navigation Route Summary

**Root Navigation Routes (from `MainActivity.kt`):**

```kotlin
NavHost(navController = navController, startDestination = "splash")

// Authentication
"splash"        → SplashScreen
"login"         → LoginScreen (role selector)
"signup"        → SignUpScreen
"verification"  → VerificationScreen (OTP)

// Student Flow
"home"          → HomeScreen
"house_detail"  → HouseDetailScreen
"room_list"     → RoomListScreen
"payment"       → PaymentScreen
"success"       → SuccessScreen
"receipt"       → ReceiptScreen
"account"       → AccountScreen
"profile"       → ProfileScreen
"my_accommodation" → MyAccommodationScreen
"customer_care" → CustomerCareScreen
"settings"      → SettingsScreen
"map"           → MapScreen
"university_search" → UniversitySearchScreen
"filters"       → FilterScreen

// Landlord Flow
"landlord_home"           → LandlordHomeScreen
"landlord_house_detail"   → LandlordHouseDetailScreen
"landlord_rooms"          → LandlordRoomsScreen
"landlord_amenities"      → LandlordAmenitiesScreen
"landlord_profile"        → LandlordProfileScreen
"landlord_payment_details" → LandlordPaymentDetailsScreen
"landlord_house_reg_success" → LandlordRegistrationSuccessScreen

// External Activities
"flutterwave_test"         → FlutterwaveTestScreen (compose)
"custom_flutterwave_launcher" → CustomFlutterwavePaymentActivity
```

### 4.3 Transition Details

**Splash → Login:**
- **Trigger:** LaunchedEffect timeout (2 seconds)
- **Navigation Type:** Push (replace)
- **Animation:** Default (cross-fade)
- **Back Stack:** `popUpTo("splash") { inclusive = true }` (prevent return)

**Login → Home/Landlord Home:**
- **Trigger:** LoginScreen callback `onLoginClick(role)`
- **Navigation Type:** Push (replace)
- **Logic:** `if (role == "Landlord") navigate("landlord_home") else navigate("home")`
- **Back Stack:** `popUpTo("login") { inclusive = true }`

**Login → Signup:**
- **Trigger:** LoginScreen callback `onCreateAccountClick()`
- **Navigation Type:** Push
- **Back Stack:** Default (can return)

**Signup → Verification:**
- **Trigger:** SignUpScreen callback `onSignUpClick(role)`
- **Navigation Type:** Push
- **Back Stack:** Default

**Verification → Home:**
- **Trigger:** VerificationScreen callback `onVerifyClick()`
- **Navigation Type:** Push
- **Back Stack:** Default

**Home → House Detail:**
- **Trigger:** HomeScreen callback `onHouseClick()`
- **Navigation Type:** Push
- **Back Stack:** Default

**Home → Room List:**
- **Trigger:** HouseDetailScreen callback `onViewRoomsClick()`
- **Navigation Type:** Push
- **Back Stack:** Default

**Home → Payment:**
- **Trigger:** RoomListScreen callback `onBookClick()`
- **Navigation Type:** Push
- **Back Stack:** Default

**Payment → Success:**
- **Trigger:** PaymentScreen callback `onPaymentSuccess()` (Flutterwave returns success)
- **Navigation Type:** Push
- **Back Stack:** Default

**Success → Receipt/Home/Map:**
- **Trigger:** Multiple callback options on SuccessScreen
- **Navigation Type:** Push
- **Back Stack:** Default

**Account → Submenu Screens:**
- **Trigger:** AccountScreen menu item callbacks
- **Possible Routes:** "profile", "my_accommodation", "customer_care", "settings"
- **Navigation Type:** Push
- **Back Stack:** Default (can return via back button)

**Bottom Navigation Transitions:**
- **From Any Screen with BottomNav:** Tab click on BottomNavigationBar
- **Routes:** Tab 0 → "home", Tab 1 → "map", Tab 2 → "account"
- **Navigation Type:** Replace (pops to root, then navigate)
- **Note:** On Home screen, tab 0 (home) is no-op

**Account → Logout:**
- **Trigger:** AccountScreen callback `onLogoutClick()`
- **Navigation Type:** Replace
- **Back Stack:** `popUpTo(0) { inclusive = true }` (clears entire stack)
- **Destination:** "login"

**Landlord Menu → Logout:**
- **Trigger:** LandlordHomeScreen menu callback `onLogoutClick()`
- **Navigation Type:** Replace
- **Back Stack:** `popUpTo(0) { inclusive = true }`
- **Destination:** "login"

---

### 4.4 Back Navigation Behavior

**Hardware/Gesture Back Button Handling:**

| Screen | Behavior | Method |
|--------|----------|--------|
| Splash | None (no back) | N/A |
| Login | None (no back button) | N/A |
| SignUp | Pop to Login | `navController.popBackStack()` |
| Verification | Pop to SignUp | `navController.popBackStack()` |
| Home | Pop (disabled by architecture) | Bottom nav blocks |
| House Detail | Pop to Home | Back icon → `onBack()` |
| Room List | Pop to House Detail | Back icon → `onBackClick()` |
| Payment | Pop to Room List | Back icon → `onBack()` |
| Success | Pop to Payment | Can go to Receipt/Home/Map |
| Receipt | Pop to Success | Back icon → `onBack()` |
| Account | Pop to Home | Back icon via bottom nav |
| Profile | Pop to Account | Back icon → `onBack()` |
| My Accommodation | Pop to Account | Back icon → `onBack()` |
| Customer Care | Pop to Account | Back icon → `onBack()` |
| Settings | Pop to Account | Back icon → `onBack()` |
| Map | Bottom nav to Home | Tab switch |
| University Search | Pop to Home | Back icon → `onBack()` |
| Filter | Pop to Home | Back icon → `onBack()` |
| Landlord Home | N/A | Menu logout clears stack |
| Landlord Rooms | Pop to House Detail | Back → `onBack()` |
| Landlord Amenities | Pop to House Detail | Back → `onBack()` |
| Landlord Profile | Pop to Home | Back → `onBack()` |
| Landlord Payment | Pop to Profile | Back → `onBack()` |

---

### 4.5 Data Passing Between Screens

**Explicit Data Passing via Callbacks:**

The app uses callback-based navigation rather than Parcelable objects:

```kotlin
// Example: Home Screen callbacks
onHouseClick: () -> Unit              // No data needed (hardcoded details)
onUniversityClick: () -> Unit         // Navigation only
onFilterClick: () -> Unit             // Navigation only
```

**Note:** No typed navigation arguments are used. All data is either:
1. Mock/hardcoded (e.g., room details always show same K1,200/m room)
2. Displayed via LazyColumn items (e.g., list of 5 rooms, each identical in demo)
3. Retrieved from backend APIs (not fully implemented in UI code shown)

---

### 4.6 Deep Linking Scheme

**Not Implemented:** The app does not show explicit deep linking configuration. Current implementation uses standard Compose Navigation with route strings.

**Potential Deep Link Structure (if to be implemented):**
```
myboardinghouse://home
myboardinghouse://house/{houseId}
myboardinghouse://room/{roomId}
myboardinghouse://payment/{bookingId}
myboardinghouse://map?latitude={lat}&longitude={lng}
myboardinghouse://profile
```

---

## 5. COMPONENT-LEVEL DETAILED LOGIC

### 5.1 LoginScreen Component

**File:** `ui/screens/student/LoginScreen.kt`

**Composable Function:**
```kotlin
@Composable
fun LoginScreen(
    onLoginClick: (String) -> Unit,
    onCreateAccountClick: () -> Unit
)
```

**State Management:**
```kotlin
var phone: String                  // User's phone number (0-10 digits)
var password: String               // User's password
var selectedRole: String = "Student" // Role selection
var expanded: Boolean = false       // Dropdown open state
var errorMessage: String = ""      // Validation error feedback
```

**Lifecycle & Initialization:**
- No LaunchedEffect or initialization hooks
- All state initialized to default values
- Heartbeat animation continuous (infinite)

**Event Handling:**

| Event | Handler | Logic |
|-------|---------|-------|
| Phone Input Change | `onValueChange` | Only accept digits, max 10 chars |
| Password Input Change | `onValueChange` | Accept any character |
| Role Dropdown Click | `expanded = true` | Show dropdown menu |
| Role Selection | `selectedRole = selected; expanded = false` | Update and close |
| Login Button Click | `validateAndLogin()` | Validate fields, then callback |

**Validation Logic:**
```kotlin
fun validateAndLogin() {
    if (phone.isEmpty() || password.isEmpty()) {
        errorMessage = "please enter the fields here"
    } else if (phone.length != 10) {
        errorMessage = "Phone number must be 10 digits"
    } else {
        onLoginClick(selectedRole)  // No actual auth call shown
    }
}
```

**API Integration:** None visible (no backend call shown)

**Edge Cases:**
- Empty fields → Show error message
- Phone < 10 digits → Show error, button disabled
- Password field masked during input (PasswordVisualTransformation)
- No rate limiting shown

**UI Customization:**
- Colors: Orange primary (#FF8C00), Black text
- Shapes: Rounded corners 25dp
- Spacing: 16dp standard padding
- Icons: Person icon 120dp

---

### 5.2 HomeScreen Component

**File:** `ui/screens/student/HomeScreen.kt`

**Composable Function:**
```kotlin
@Composable
fun HomeScreen(
    onHouseClick: () -> Unit,
    onUniversityClick: () -> Unit,
    onFilterClick: () -> Unit,
    onMapsClick: () -> Unit,
    onAccountClick: () -> Unit,
    onLaunchCustomFlutterwave: () -> Unit
)
```

**State Management:**
```kotlin
var scrollState: LazyListState        // Tracks scroll position and item visibility
var currentTab: Int = 0               // Selected bottom nav tab (0=home, 1=map, 2=account)
var previousIndex: Int = 0            // Previous scroll item index
var previousScrollOffset: Int = 0     // Previous scroll offset
var isBottomBarVisible: Boolean = true // Show/hide bottom nav based on scroll
var isHeaderCollapsed: Boolean        // Header height animation state
```

**Lifecycle & Initialization:**

```kotlin
// LaunchedEffect monitors scroll position
LaunchedEffect(scrollState.firstVisibleItemIndex, scrollState.firstVisibleItemScrollOffset) {
    val currentIndex = scrollState.firstVisibleItemIndex
    val currentOffset = scrollState.firstVisibleItemScrollOffset
    
    // Determine scroll direction
    if (currentIndex > previousIndex || 
        (currentIndex == previousIndex && currentOffset > previousScrollOffset)) {
        if (currentIndex > 0) isBottomBarVisible = false  // Scrolling down
    } else {
        isBottomBarVisible = true  // Scrolling up or at top
    }
    
    previousIndex = currentIndex
    previousScrollOffset = currentOffset
}

// Derive header collapse state from scroll position
val isHeaderCollapsed by remember { 
    derivedStateOf { scrollState.firstVisibleItemIndex > 0 }
}
```

**Event Handling:**

| Event | Handler | Logic |
|-------|---------|-------|
| House Item Click | `onHouseClick()` | Navigate to house_detail |
| University Button Click | `onUniversityClick()` | Navigate to university_search |
| Filter Button Click | `onFilterClick()` | Navigate to filters |
| Maps Button Click | `onMapsClick()` | Navigate to map |
| Account Button Click | `onAccountClick()` | Navigate to account |
| Flutterwave Test Button Click | `onLaunchCustomFlutterwave()` | Navigate to custom_flutterwave_launcher |
| Bottom Nav Tab 0 Click | `onHouseClick()`? | No-op (already on home) |
| Bottom Nav Tab 1 Click | `onMapsClick()` | Navigate to map |
| Bottom Nav Tab 2 Click | `onAccountClick()` | Navigate to account |

**Animation Details:**

1. **Header Animation (`TopOrangeHeader`):**
   - Full height: 180dp (when `isCollapsed = false`)
   - Collapsed height: 80dp (when `isCollapsed = true`)
   - Animation duration: 500ms tween
   - Corner radius: 40dp (bottom) → 0dp (collapsed)

2. **Bottom Nav Animation:**
   - Enter: `slideInVertically(initialOffsetY = { it }) + fadeIn()`
   - Exit: `slideOutVertically(targetOffsetY = { it }) + fadeOut()`
   - Triggered by `isBottomBarVisible` state change

3. **Sliding Advertisement:**
   - Auto-scrolling horizontal pager (not detailed in code snippet)

**Content Structure (LazyColumn items):**

1. **Sliding Advertisement Section** - HorizontalPager
2. **Filter Buttons Row** - University + Filter buttons
3. **Active Filters Grid** - Display selected filters
4. **Flutterwave Test Button** - Development feature
5. **House Grid Section** - Lazy-loaded list of house cards

**Navigation Strategy:**
- Uses callback pattern (lambda functions)
- Parent Activity (MainActivity) handles routing
- All navigation targets are "push" style (can back)

---

### 5.3 PaymentScreen Component

**File:** `ui/screens/student/PaymentScreen.kt`

**Composable Function:**
```kotlin
@Composable
fun PaymentScreen(onBack: () -> Unit, onPaymentSuccess: () -> Unit)
```

**State Management:**
```kotlin
var toastMessage: String? = null       // Toast message text (null = hidden)
val context: Context                   // Android Context for Toast
val flutterwaveLauncher                // Activity result launcher for Flutterwave
```

**Lifecycle & Initialization:**

```kotlin
// Toast display lifecycle
LaunchedEffect(toastMessage) {
    toastMessage?.let {
        Toast.makeText(context, it, Toast.LENGTH_LONG).show()
        toastMessage = null  // Clear for next message
    }
}

// Activity launcher registration
val flutterwaveLauncher = rememberLauncherForActivityResult(
    contract = ActivityResultContracts.StartActivityForResult()
) { result ->
    val data = result.data
    val status = data?.getStringExtra(EXTRA_RESULT_STATUS)
    val txRef = data?.getStringExtra(EXTRA_RESULT_TX_REF)
    val transactionId = data?.getStringExtra(EXTRA_RESULT_TRANSACTION_ID)
    
    val message = when (status) {
        "success" -> { 
            onPaymentSuccess()  // Callback to navigate
            "Payment Successful! TxRef: $txRef, TransactionId: $transactionId"
        }
        "error" -> "Payment Error: $rawResponse"
        "cancelled" -> "Payment Cancelled: $rawResponse"
        else -> "Payment Unknown State"
    }
    toastMessage = message
}
```

**Event Handling:**

| Event | Handler | Logic |
|-------|---------|-------|
| Back Button Click | `onBack()` | popBackStack() |
| Pay Button Click | Create Intent to FlutterwaveCheckoutActivity | Launch activity with result contract |

**Payment Flow (Pay Button Logic):**

```kotlin
Button(onClick = {
    val intent = Intent(context, FlutterwaveCheckoutActivity::class.java).apply {
        putExtra(EXTRA_AMOUNT, 100.0)
        putExtra(EXTRA_CURRENCY, "ZMW")
        putExtra(EXTRA_EMAIL, "test.user@example.com")
        putExtra(EXTRA_PHONE, "0971234567")
        putExtra(EXTRA_FNAME, "Test")
        putExtra(EXTRA_LNAME, "User")
        putExtra(EXTRA_TX_REF, "test-tx-${System.currentTimeMillis()}")
    }
    flutterwaveLauncher.launch(intent)
}) {
    Text("Pay", ...)
}
```

**Flutterwave Integration:**

| Parameter | Value | Type |
|-----------|-------|------|
| Amount | 100.0 | Double (test amount) |
| Currency | "ZMW" (Zambian Kwacha) | String |
| Email | test.user@example.com | String |
| Phone | 0971234567 | String |
| First Name | "Test" | String |
| Last Name | "User" | String |
| Transaction Reference | test-tx-{timestamp} | String (unique) |

**Result Handling:**

```kotlin
when (status) {
    "success" -> {
        onPaymentSuccess()  // Navigate to success screen
        // Show success message
    }
    "error" -> {
        // Show error message with raw response
    }
    "cancelled" -> {
        // Show cancellation message
    }
    else -> {
        // Show unknown state message
    }
}
```

**Edge Cases:**
- No network → Flutterwave SDK handles
- Invalid amount → Test amount hardcoded (100.0)
- Missing user data → Test data hardcoded
- Activity back button → Result returned to launcher

---

### 5.4 FlutterwaveApi Object

**File:** `network/FlutterwaveApi.kt`

**Purpose:** Backend integration for Flutterwave payment initiation and verification

**State Management:**
```kotlin
private val client: OkHttpClient   // Reusable HTTP client (singleton)
private val JSON: MediaType        // Content-Type for requests
```

**Client Configuration:**
```kotlin
val client = OkHttpClient.Builder()
    .connectTimeout(15, TimeUnit.SECONDS)
    .readTimeout(20, TimeUnit.SECONDS)
    .build()

val JSON = "application/json; charset=utf-8".toMediaType()
```

**Function 1: initPayment()**

```kotlin
fun initPayment(amount: Double, currency: String): Pair<Boolean, String>
```

**Purpose:** Step 1 of payment flow - request backend to create transaction reference and reserve amount

**Request:**
- **URL:** `{BACKEND_BASE_URL}/payments/init` (http://10.0.2.2:4000/payments/init)
- **Method:** POST
- **Content-Type:** application/json
- **Body:**
  ```json
  {
    "amount": 100.0,
    "currency": "ZMW"
  }
  ```

**Response Handling:**
```kotlin
// Expected response:
{
  "ok": true,
  "tx_ref": "test-tx-1234567890"
}
```

**Returns:** `Pair<Boolean, String>`
- **First element:** Success status (true if ok && tx_ref present)
- **Second element:** Transaction reference or error message

**Logic:**
```kotlin
client.newCall(request).execute().use { response ->
    val text = response.body?.string() ?: ""
    if (!response.isSuccessful) {
        return false to text
    }

    val obj = JSONObject(text)
    val ok = obj.optBoolean("ok", false)
    val txRef = obj.optString("tx_ref", "")

    return if (ok && txRef.isNotBlank()) {
        true to txRef
    } else {
        false to text
    }
}
```

**Function 2: verifyPayment()**

```kotlin
fun verifyPayment(txRef: String, transactionId: String): Pair<Boolean, String>
```

**Purpose:** Step 2 of payment flow - backend verifies successful payment with Flutterwave

**Request:**
- **URL:** `{BACKEND_BASE_URL}/payments/verify`
- **Method:** POST
- **Body:**
  ```json
  {
    "tx_ref": "test-tx-1234567890",
    "transaction_id": "123456789"
  }
  ```

**Response Handling:**
```kotlin
{
  "ok": true,
  "message": "Payment verified"
}
```

**Returns:** `Pair<Boolean, String>`
- **First element:** Verification success
- **Second element:** Response text

**Error Handling:**
- Network timeout (15s connect, 20s read)
- HTTP error status (checks `!response.isSuccessful`)
- Missing JSON fields (uses `optBoolean`/`optString` with defaults)
- No retry logic shown

---

### 5.5 MapScreen Component

**File:** `ui/screens/student/MapScreen.kt`

**Composable Function:**
```kotlin
@Composable
fun MapScreen(
    onHomeClick: () -> Unit,
    onMapsClick: () -> Unit,
    onAccountClick: () -> Unit
)
```

**State Management:**
```kotlin
var searchQuery: String = ""                        // Current search text
var lusaka = LatLng(-15.4167, 28.2833)            // Lusaka coordinates
val cameraPositionState = rememberCameraPositionState {
    position = CameraPosition.fromLatLngZoom(lusaka, 12f)
}
val context: Context                               // For Toast and Geocoder
val scope: CoroutineScope = rememberCoroutineScope() // For async operations
val keyboardController: SoftwareKeyboardController?  // For hiding keyboard
```

**Lifecycle & Initialization:**

```kotlin
// Camera position initialized on first composition
val cameraPositionState = rememberCameraPositionState {
    position = CameraPosition.fromLatLngZoom(lusaka, 12f)
}
```

**Event Handling:**

| Event | Handler | Logic |
|-------|---------|-------|
| Search Field Change | `onValueChange` | Update searchQuery state |
| Search IME Action | `keyboardActions onSearch` | Geocode location, animate map |
| Bottom Nav Tab 0 (Home) | `onHomeClick()` | Navigate to home |
| Bottom Nav Tab 1 (Maps) | None (no-op) | Current screen |
| Bottom Nav Tab 2 (Account) | `onAccountClick()` | Navigate to account |

**Search & Location Logic:**

```kotlin
keyboardActions = KeyboardActions(onSearch = {
    keyboardController?.hide()
    scope.launch {
        try {
            val geocoder = Geocoder(context, Locale.getDefault())
            val addresses = geocoder.getFromLocationName(searchQuery, 1)
            
            if (!addresses.isNullOrEmpty()) {
                val address = addresses[0]
                val latLng = LatLng(address.latitude, address.longitude)
                
                // Animate camera to new location
                cameraPositionState.animate(
                    CameraUpdateFactory.newLatLngZoom(latLng, 14f)
                )
            } else {
                Toast.makeText(context, "Location not found", Toast.LENGTH_SHORT).show()
            }
        } catch (e: IOException) {
            Toast.makeText(context, "Error searching location: ${e.message}", Toast.LENGTH_LONG).show()
        }
    }
})
```

**Google Map Configuration:**

```kotlin
GoogleMap(
    modifier = Modifier.fillMaxSize(),
    cameraPositionState = cameraPositionState,
    uiSettings = MapUiSettings(zoomControlsEnabled = false)
) {
    Marker(
        state = MarkerState(position = lusaka),
        title = "Lusaka",
        snippet = "Capital of Zambia"
    )
}
```

**Map Features:**
- Initial position: Lusaka, Zambia
- Initial zoom: 12
- Marker: Single marker at Lusaka
- UI: Zoom controls disabled
- Animation: Camera animates to searched location at zoom 14

**Error Handling:**
- `IOException` from Geocoder → Show error toast
- Empty search results → Show "Location not found" toast
- Null addresses list → Show "Location not found" toast

**Deprecated API Warning:**
```
⚠️ getFromLocationName() is deprecated
   Recommendation: Use getFromLocationName(String query, int maxResults, double lowerLeftLatitude, ...)
```

---

### 5.6 BottomNavigationBar Component

**File:** `ui/components/BottomNavigationBar.kt`

**Composable Function:**
```kotlin
@Composable
fun BottomNavigationBar(selectedTabIndex: Int, onTabSelected: (Int) -> Unit)
```

**State Management:**
```kotlin
selectedTabIndex: Int              // 0=Home, 1=Maps, 2=Account (received as prop)
```

**Layout Details:**
```kotlin
Surface(
    modifier = Modifier
        .fillMaxWidth()
        .padding(start = 24.dp, end = 24.dp, bottom = 12.dp)
        .height(72.dp),
    shape = RoundedCornerShape(36.dp),
    shadowElevation = 12.dp,
    color = White
) {
    Row(
        modifier = Modifier.fillMaxSize(),
        horizontalArrangement = Arrangement.SpaceEvenly,
        verticalAlignment = Alignment.CenterVertically
    ) {
        BottomNavIcon(icon = R.drawable.ic_home, isSelected = selectedTabIndex == 0, ...)
        BottomNavIcon(icon = R.drawable.ic_location, isSelected = selectedTabIndex == 1, ...)
        BottomNavIcon(icon = R.drawable.ic_account, isSelected = selectedTabIndex == 2, ...)
    }
}
```

**BottomNavIcon Sub-Component:**

```kotlin
@Composable
fun BottomNavIcon(icon: Int, isSelected: Boolean, onClick: () -> Unit) {
    val backgroundColor = if (isSelected) OrangePrimary else Color.Transparent
    val iconColor = if (isSelected) White else Black
    
    Box(
        modifier = Modifier
            .size(48.dp)
            .clip(RoundedCornerShape(16.dp))
            .background(backgroundColor)
            .clickable { onClick() },
        contentAlignment = Alignment.Center
    ) {
        Icon(
            painter = painterResource(id = icon),
            contentDescription = null,
            tint = iconColor,
            modifier = Modifier.size(26.dp)
        )
    }
}
```

**Event Handling:**

| Event | Handler | Details |
|-------|---------|---------|
| Icon 0 Click | `onTabSelected(0)` | Home icon clicked |
| Icon 1 Click | `onTabSelected(1)` | Maps icon clicked |
| Icon 2 Click | `onTabSelected(2)` | Account icon clicked |

**Visual State Mapping:**

| Tab | Icon | Selected State | Inactive State |
|-----|------|---|---|
| 0 | Home | Orange background, white icon | Transparent, black icon |
| 1 | Location | Orange background, white icon | Transparent, black icon |
| 2 | Account | Orange background, white icon | Transparent, black icon |

**Parent Screen Integration:**

Each screen using BottomNavigationBar:

```kotlin
Scaffold(
    bottomBar = {
        BottomNavigationBar(
            selectedTabIndex = 0,  // or 1, or 2
            onTabSelected = { index: Int ->
                when(index) {
                    0 -> onHomeClick()
                    1 -> onMapsClick()
                    2 -> onAccountClick()
                }
            }
        )
    }
) {
    // Screen content
}
```

---

## 6. DATA ARCHITECTURE & BACKEND INTERACTION

### 6.1 Backend API Endpoints

**Base URL:** `http://10.0.2.2:4000` (Local development server)

**Endpoint: POST /payments/init**

**Purpose:** Initialize payment transaction

**Request Headers:**
```
Content-Type: application/json
```

**Request Body:**
```json
{
  "amount": 100.0,
  "currency": "ZMW"
}
```

**Response (Success 200):**
```json
{
  "ok": true,
  "tx_ref": "test-tx-1234567890"
}
```

**Response (Error):**
```json
{
  "ok": false,
  "message": "Error message"
}
```

**Implementation Location:** `FlutterwaveApi.initPayment()`

---

**Endpoint: POST /payments/verify**

**Purpose:** Verify Flutterwave payment transaction

**Request Headers:**
```
Content-Type: application/json
```

**Request Body:**
```json
{
  "tx_ref": "test-tx-1234567890",
  "transaction_id": "123456789"
}
```

**Response (Success 200):**
```json
{
  "ok": true,
  "message": "Payment verified successfully"
}
```

**Response (Error):**
```json
{
  "ok": false,
  "message": "Verification failed"
}
```

**Implementation Location:** `FlutterwaveApi.verifyPayment()`

---

### 6.2 Local Storage

**Not Implemented:** No local persistent storage shown (AsyncStorage/SharedPreferences)

**Future Considerations:**
- User authentication token storage
- User profile cache
- Bookmarked properties
- Search history
- Payment history cache

---

### 6.3 Database Schema (Proposed)

**Note:** Database layer not visible in UI code. Following is inferred from functionality:

```sql
-- Users Table
CREATE TABLE users (
  id VARCHAR(36) PRIMARY KEY,
  phone VARCHAR(10) UNIQUE NOT NULL,
  password_hash VARCHAR(255) NOT NULL,
  role ENUM('student', 'landlord') NOT NULL,
  full_name VARCHAR(255) NOT NULL,
  email VARCHAR(255) UNIQUE NOT NULL,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Properties/Houses Table
CREATE TABLE properties (
  id VARCHAR(36) PRIMARY KEY,
  landlord_id VARCHAR(36) NOT NULL,
  name VARCHAR(255) NOT NULL,
  location VARCHAR(255) NOT NULL,
  latitude DOUBLE,
  longitude DOUBLE,
  description TEXT,
  total_rooms INT,
  available_rooms INT,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (landlord_id) REFERENCES users(id)
);

-- Rooms Table
CREATE TABLE rooms (
  id VARCHAR(36) PRIMARY KEY,
  property_id VARCHAR(36) NOT NULL,
  room_type VARCHAR(50),     -- e.g., "Single Room, Selfcontained"
  monthly_rent DECIMAL(10, 2),
  security_deposit DECIMAL(10, 2),
  availability_status ENUM('available', 'booked', 'reserved'),
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (property_id) REFERENCES properties(id)
);

-- Bookings Table
CREATE TABLE bookings (
  id VARCHAR(36) PRIMARY KEY,
  student_id VARCHAR(36) NOT NULL,
  room_id VARCHAR(36) NOT NULL,
  move_in_date DATE NOT NULL,
  move_out_date DATE NOT NULL,
  total_amount DECIMAL(10, 2),
  status ENUM('pending', 'confirmed', 'cancelled') DEFAULT 'pending',
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (student_id) REFERENCES users(id),
  FOREIGN KEY (room_id) REFERENCES rooms(id)
);

-- Payments Table
CREATE TABLE payments (
  id VARCHAR(36) PRIMARY KEY,
  booking_id VARCHAR(36) NOT NULL,
  tx_ref VARCHAR(255) UNIQUE NOT NULL,
  flutterwave_transaction_id VARCHAR(255),
  amount DECIMAL(10, 2) NOT NULL,
  currency VARCHAR(3),
  payment_status ENUM('pending', 'success', 'failed', 'cancelled') DEFAULT 'pending',
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  verified_at TIMESTAMP,
  FOREIGN KEY (booking_id) REFERENCES bookings(id)
);

-- Amenities Table
CREATE TABLE amenities (
  id VARCHAR(36) PRIMARY KEY,
  property_id VARCHAR(36) NOT NULL,
  name VARCHAR(100),  -- e.g., "Parking", "WiFi", "Kitchen"
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (property_id) REFERENCES properties(id)
);

-- Universities Table
CREATE TABLE universities (
  id VARCHAR(36) PRIMARY KEY,
  name VARCHAR(255) NOT NULL,
  latitude DOUBLE,
  longitude DOUBLE,
  city VARCHAR(100)
);

-- Verification Table
CREATE TABLE email_verifications (
  id VARCHAR(36) PRIMARY KEY,
  user_id VARCHAR(36) NOT NULL,
  verification_code VARCHAR(6) NOT NULL,
  verified BOOLEAN DEFAULT FALSE,
  expires_at TIMESTAMP,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (user_id) REFERENCES users(id)
);
```

---

### 6.4 Flutterwave SDK Integration

**SDK Version:** `com.github.flutterwave.rave-android:rave_android:2.2.1`

**Configuration:**
```gradle.kts
// From build.gradle.kts
buildConfigField("String", "FLW_PUBLIC_KEY", "\"FLWPUBK_TEST-69e49446084a7497223f75c4d653d7ea-X\"")
buildConfigField("String", "FLW_ENCRYPTION_KEY", "\"FLWSECK_TEST0b0f38e17942\"")
```

**Public Key:** `FLWPUBK_TEST-69e49446084a7497223f75c4d653d7ea-X` (Test key)

**Encryption Key:** `FLWSECK_TEST0b0f38e17942` (Test key)

**Custom Activity:** `FlutterwaveCheckoutActivity` (custom implementation)

**Payment Parameters Passed:**
- `EXTRA_AMOUNT`: 100.0
- `EXTRA_CURRENCY`: ZMW
- `EXTRA_EMAIL`: User email
- `EXTRA_PHONE`: User phone
- `EXTRA_FNAME`: First name
- `EXTRA_LNAME`: Last name
- `EXTRA_TX_REF`: Unique transaction reference

**Result Extras Returned:**
- `EXTRA_RESULT_STATUS`: "success" | "error" | "cancelled"
- `EXTRA_RESULT_RAW`: Raw response JSON
- `EXTRA_RESULT_TX_REF`: Transaction reference
- `EXTRA_RESULT_TRANSACTION_ID`: Flutterwave transaction ID

---

## 7. BUSINESS LOGIC & ALGORITHMS

### 7.1 Authentication Flow

**Sign Up Process:**

```
Input: fullName, phone (10 digits), email, password, role
  ↓
Validation:
  - All fields required
  - Phone: exactly 10 numeric digits
  - Email: required, format not validated in UI
  - Password: no length requirement shown
  ↓
Navigate to Verification Screen
  ↓
OTP Verification (50-second countdown):
  - Display 5 input boxes
  - Timer counts down
  - "Resend" available when timer = 0
  ↓
On Verify Success:
  - Navigate to Home Screen
  - User logged in as selected role
```

**Login Process:**

```
Input: phone (10 digits), password, role
  ↓
Validation:
  - Phone: exactly 10 digits
  - Password: required
  ↓
Backend Verification (not shown in UI code):
  - POST {API}/login with credentials
  - Receive auth token
  ↓
Role-Based Navigation:
  - Role = "Student" → navigate("home")
  - Role = "Landlord" → navigate("landlord_home")
```

---

### 7.2 Payment Processing Flow

**Booking → Payment → Verification:**

```
Step 1: User selects room and clicks "Book"
  │
  └─→ Navigate to Payment Screen
         • Display room details
         • Display cost breakdown
         • Show move-in/out dates
  
Step 2: User reviews details and clicks "Pay"
  │
  └─→ Call FlutterwaveApi.initPayment(amount, currency)
         • Backend creates tx_ref
         • Backend reserves amount
         • Receive: { ok: true, tx_ref: "..." }
  
Step 3: Launch Flutterwave Checkout Activity
  │
  └─→ User completes payment in Flutterwave SDK
         • Enter card/mobile money details
         • Biometric/OTP confirmation
         • Flutterwave processes transaction
  
Step 4: Activity returns with result
  │
  └─→ Check status (success/error/cancelled)
         • If success:
           - Call FlutterwaveApi.verifyPayment(tx_ref, transactionId)
           - Backend verifies with Flutterwave
           - If verified: Update booking status to "confirmed"
           - Navigate to Success Screen
         • If error/cancelled:
           - Show error message
           - Stay on Payment Screen
           - Allow retry
```

**Cost Calculation:**

```
Security Deposit:  K250 (fixed)
Monthly Rent:      K1,200 (from room selection)
─────────────────
Total:             K1,450
```

---

### 7.3 Distance Calculation

**House Detail → Distance Display:**

```
Input: House latitude/longitude, University latitude/longitude
  ↓
Backend Calculation (not shown):
  - Calculate walking distance (estimated: 10 min)
  - Calculate driving distance (estimated: <2 miles)
  ↓
Display in Orange Card:
  - Walking icon + "10min"
  - Car icon + "<2mi"
```

**Map Search:**

```
Input: Location name (text query)
  ↓
Use Android Geocoder:
  - geocoder.getFromLocationName(query, maxResults=1)
  - Convert: "Kalingalinga" → LatLng(-15.45, 28.25) (example)
  ↓
Animate Google Map:
  - Camera.animate(newLatLngZoom(latLng, zoom=14))
  ↓
Display: Map centered on searched location
```

---

### 7.4 Validation Rules

**Phone Number:**
- Exactly 10 digits
- Numeric only (0-9)
- No formatting required
- Example: "0971234567"

**Email:**
- Required field
- Format validation not shown in UI
- Example: "student@unza.zm"

**Password:**
- Required field
- No length/complexity requirements shown
- Displayed as masked input
- Confirmation password must match exactly

**OTP Code:**
- 5-digit code
- Entry via 5 separate input boxes
- Countdown timer: 50 seconds

**Transaction Reference (tx_ref):**
- Format: "test-tx-{timestamp}"
- Must be unique per transaction
- Example: "test-tx-1716632000000"

---

### 7.5 Role-Based Access Control (RBAC)

**Student Role:**
- Access: Home, House browsing, Room listing, Payment, Profile, Map, Account
- Restricted: Landlord management screens

**Landlord Role:**
- Access: Landlord dashboard, Property management, Room management, Payment details
- Restricted: House browsing, Payment (as payer)

**Authentication Gate (Login Screen):**
```kotlin
if (role == "Landlord") {
    navController.navigate("landlord_home")
} else {
    navController.navigate("home")  // Default: Student
}
```

---

## 8. CONFIGURATION, DEPENDENCIES & ENVIRONMENT

### 8.1 Gradle Configuration

**Build Configuration (build.gradle.kts):**

```gradle.kts
android {
    namespace = "com.example.myboardinghouse"
    compileSdk = 36                 // Android 15 (future)
    
    defaultConfig {
        applicationId = "com.example.myboardinghouse"
        minSdk = 24                 // Android 7.0 (API 24)
        targetSdk = 34              // Android 14 (API 34)
        versionCode = 1
        versionName = "1.0"
        
        buildConfigField("String", "BACKEND_BASE_URL", 
                        "\"http://10.0.2.2:4000\"")
        buildConfigField("String", "FLW_PUBLIC_KEY", 
                        "\"FLWPUBK_TEST-69e49446084a7497223f75c4d653d7ea-X\"")
        buildConfigField("String", "FLW_ENCRYPTION_KEY", 
                        "\"FLWSECK_TEST0b0f38e17942\"")
    }
    
    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11
    }
    
    kotlinOptions {
        jvmTarget = "11"
    }
    
    buildFeatures {
        buildConfig = true
        compose = true
    }
}
```

---

### 8.2 Dependencies (libs.versions.toml)

**Core Jetpack:**
```gradle
androidx.core:core-ktx - Core Kotlin extensions
androidx.lifecycle:lifecycle-runtime-ktx - Lifecycle management
androidx.activity:activity-compose - Activity + Compose integration
```

**Compose:**
```gradle
androidx.compose.bom - Compose Bill of Materials (version alignment)
androidx.compose.ui:ui - Core Compose UI
androidx.compose.ui:ui-graphics - Graphics utilities
androidx.compose.ui:ui-tooling-preview - Preview support
androidx.compose.material3 - Material 3 design system
```

**Material Icons:**
```gradle
androidx.compose.material:material-icons-core - Core Material icons
androidx.compose.material:material-icons-extended - Extended icon library
```

**Navigation:**
```gradle
androidx.navigation:navigation-compose - Jetpack Navigation for Compose
```

**Maps:**
```gradle
com.google.maps.android:maps-compose - Google Maps Compose wrapper
com.google.android.gms:play-services-maps - Google Play Services Maps
```

**Flutterwave:**
```gradle
com.github.flutterwave.rave-android:rave_android:2.2.1 - Payment SDK
androidx.appcompat:appcompat:1.6.1 - AppCompat (required by Flutterwave)
```

**Networking:**
```gradle
com.squareup.okhttp3:okhttp:4.12.0 - HTTP client
com.squareup.okhttp3:logging-interceptor:4.12.0 - Request/response logging
```

**Testing:**
```gradle
junit - Unit testing
androidx.test.ext:junit - Android JUnit extensions
androidx.test.espresso:espresso-core - UI testing
androidx.compose.ui:ui-test-junit4 - Compose UI tests
```

---

### 8.3 Runtime Configuration

**Environment Variables / Build Config Fields:**

| Field | Value | Usage |
|-------|-------|-------|
| BACKEND_BASE_URL | http://10.0.2.2:4000 | API calls (FlutterwaveApi) |
| FLW_PUBLIC_KEY | FLWPUBK_TEST-... | Flutterwave SDK initialization |
| FLW_ENCRYPTION_KEY | FLWSECK_TEST... | Payment encryption |

**Note:** All credentials are test/mock keys (FLWPUBK_TEST indicates test mode)

---

### 8.4 Android Manifest Configuration

**Permissions:**
```xml
<uses-permission android:name="android.permission.INTERNET" />
<uses-permission android:name="android.permission.ACCESS_FINE_LOCATION" />
<uses-permission android:name="android.permission.ACCESS_COARSE_LOCATION" />
```

**Activities:**
```xml
<activity android:name=".MainActivity" android:exported="true" />
<activity android:name="...FlutterwaveCheckoutActivity" />
<activity android:name="...CustomFlutterwavePaymentActivity" />
```

**Meta-Data:**
```xml
<meta-data 
    android:name="com.google.android.geo.API_KEY" 
    android:value="AIzaSyCfAeugoBL-cSZtCPxG3aeD2lH0UjVUGmE" />
```

**Google Maps API Key:** `AIzaSyCfAeugoBL-cSZtCPxG3aeD2lH0UjVUGmE` (Demo key)

---

### 8.5 Feature Flags (Future)

**Potential flags not currently shown:**

```kotlin
// In BuildConfig or SharedPreferences
ENABLE_DARK_MODE = false          // Currently light only
ENABLE_USER_FILTERING = false     // Filters not implemented
ENABLE_LANDLORD_FEATURES = true   // Landlord screens available
ENABLE_MOCK_API = true            // Use mock data vs real API
ENABLE_ANALYTICS = false          // Analytics not integrated
```

---

## 9. ERROR HANDLING & LOGGING

### 9.1 Error Boundaries & User-Facing Messages

**Global Level:**
- No custom error boundary UI shown
- Android default crash handling

**Screen-Level Errors:**

| Screen | Error Handling | User Message |
|--------|---|---|
| Login | Field validation | "please enter the fields here" |
| Login | Phone length | "Phone number must be 10 digits" |
| SignUp | Same as Login | Same messages |
| Map Search | Geocoder IOException | "Error searching location: {message}" |
| Map Search | Location not found | "Location not found" |
| Payment | Flutterwave error | "Payment Error: {response}" |
| Payment | Flutterwave cancelled | "Payment Cancelled: {response}" |

**Toast Messages:**
- Duration: `Toast.LENGTH_LONG` (3.5 seconds)
- Context: Local context from Composable
- Async: Displayed via LaunchedEffect

**Example Error Flow (Map Search):**

```kotlin
try {
    val addresses = geocoder.getFromLocationName(searchQuery, 1)
    if (!addresses.isNullOrEmpty()) {
        // Success: animate map
    } else {
        Toast.makeText(context, "Location not found", Toast.LENGTH_SHORT).show()
    }
} catch (e: IOException) {
    Toast.makeText(context, "Error searching location: ${e.message}", Toast.LENGTH_LONG).show()
}
```

---

### 9.2 Logging

**Not Implemented:** No explicit logging framework shown (Timber, Logcat, Firebase, etc.)

**Potential Future Implementation:**
```kotlin
Log.d("PaymentScreen", "Payment success: txRef=$txRef")
Log.e("MapScreen", "Geocoding failed", exception)
Log.i("HomeScreen", "User selected house: $houseId")
```

---

### 9.3 Crash Reporting

**Not Integrated:** No Firebase Crashlytics, Sentry, or similar shown

**Recommendation for Production:**
```gradle.kts
// Add to build.gradle.kts
implementation("com.google.firebase:firebase-crashlytics-ktx")
```

---

### 9.4 Analytics Events (Future)

**Not Implemented:** No analytics SDK shown

**Potential Events:**

| Event | Trigger | Parameters |
|-------|---------|-----------|
| user_signup | SignUp completion | role, timestamp |
| user_login | Login success | role, timestamp |
| house_view | House detail opened | houseId, location |
| room_book | Room booking started | roomId, amount |
| payment_init | Payment initiated | amount, currency |
| payment_success | Payment verified | amount, txRef |
| search_location | Map location searched | query, result |

---

## 10. TEST & QUALITY NOTES

### 10.1 Observable Test Patterns

**Unit Test Setup (gradle):**
```gradle.kts
testImplementation(libs.junit)
```

**UI Test Setup (gradle):**
```gradle.kts
androidTestImplementation(libs.androidx.compose.ui.test.junit4)
debugImplementation(libs.androidx.compose.ui.tooling)
debugImplementation(libs.androidx.compose.ui.test.manifest)
```

**Preview Tests:**

```kotlin
@Preview(showBackground = true)
@Composable
fun RoomListScreenPreview() {
    RoomListScreen(onBackClick = {}, onBookClick = {})
}

@Preview(showBackground = true)
@Composable
fun MapScreenPreview() {
    MapScreen(onHomeClick = {}, onMapsClick = {}, onAccountClick = {})
}
```

---

### 10.2 Mock Data / Fixtures

**Hardcoded Test Data:**

```kotlin
// Payment Screen
val amount = 100.0
val currency = "ZMW"
val email = "test.user@example.com"
val phone = "0971234567"
val firstName = "Test"
val lastName = "User"

// Room Cards (LazyColumn)
repeat(5) {  // 5 identical rooms
    RoomItem(
        roomType = "Single Room, Selfcontained",
        price = "K1,200/m",
        ...
    )
}

// House Cards (Landlord)
repeat(4) {  // 4 identical houses
    LandlordHouseCard(
        name = "Mr Chanda BH",
        location = "Kalingalinga",
        spacesAvailable = 50,
        ...
    )
}

// Map Initial Location
val lusaka = LatLng(-15.4167, 28.2833)
```

---

### 10.3 Known Limitations & TODO Items

**Incomplete Features:**

1. **Profile Screens:** Placeholder implementation only
   ```kotlin
   // ui/screens/student/ProfileScreen.kt
   Text("Profile Screen Placeholder")
   ```

2. **Filter Screen:** No actual filtering logic
   ```kotlin
   Text("Filter options coming soon...")
   ```

3. **University Search:** Not detailed in provided code

4. **My Accommodation:** Not detailed in provided code

5. **Customer Care:** Not detailed in provided code

6. **Settings:** Not detailed in provided code

---

**Data Hardcoding Issues:**

1. All room prices hardcoded to "K1,200/m"
2. All security deposits hardcoded to "K250"
3. All houses show same image placeholder
4. No backend data fetching implemented for lists
5. No database persistence shown

---

**API Integration Gaps:**

1. Login endpoint not called (hardcoded validation only)
2. SignUp endpoint not called
3. House/Room listing endpoint not called
4. Only Flutterwave payment endpoints implemented

---

**Security Concerns:**

1. API keys in source code (test keys, but bad practice)
2. No token/session management visible
3. No encryption for stored data
4. Test credentials hardcoded in payment flow

---

## APPENDIX: QUICK REFERENCE

### File Structure
```
app/src/main/
├── java/com/example/myboardinghouse/
│   ├── MainActivity.kt                (Entry point, navigation setup)
│   ├── network/
│   │   └── FlutterwaveApi.kt         (Payment API integration)
│   └── ui/
│       ├── screens/
│       │   ├── SplashScreen.kt
│       │   ├── LoginScreen.kt
│       │   ├── SignUpScreen.kt
│       │   ├── VerificationScreen.kt
│       │   ├── HomeScreen.kt
│       │   ├── HouseDetailScreen.kt
│       │   ├── PaymentScreen.kt
│       │   ├── SuccessScreen.kt
│       │   ├── ReceiptScreen.kt
│       │   ├── AccountScreen.kt
│       │   ├── ProfileScreen.kt
│       │   ├── MyAccommodationScreen.kt
│       │   ├── CustomerCareScreen.kt
│       │   ├── SettingsScreen.kt
│       │   ├── MapScreen.kt
│       │   ├── UniversitySearchScreen.kt
│       │   ├── FilterScreen.kt
│       │   ├── student/ (student-specific versions)
│       │   └── landlord/ (landlord screens)
│       ├── components/
│       │   └── BottomNavigationBar.kt
│       └── theme/
│           ├── Color.kt  (color palette)
│           ├── Theme.kt  (Material3 theme)
│           └── Type.kt   (typography)
├── res/
│   ├── drawable/ (icons)
│   ├── mipmap/ (app icons)
│   ├── values/ (strings, colors, themes)
│   └── xml/ (data extraction, backup rules)
└── AndroidManifest.xml (permissions, activities)
```

### Key Numbers
- **Min SDK:** 24 (Android 7.0)
- **Target SDK:** 34 (Android 14)
- **Compile SDK:** 36 (Android 15)
- **Primary Color:** #FF8C00 (Orange)
- **Secondary Color:** #2EBD8A (Mint Green)
- **Splash Duration:** 2 seconds
- **OTP Timer:** 50 seconds
- **Payment Amount:** 100.0 ZMW (test)
- **Default Zoom (Map):** 12

### Contact/API Endpoints
- **Backend:** http://10.0.2.2:4000 (local dev)
- **Payments Init:** POST /payments/init
- **Payments Verify:** POST /payments/verify
- **Maps API Key:** AIzaSyCfAeugoBL-cSZtCPxG3aeD2lH0UjVUGmE
- **Flutterwave Public:** FLWPUBK_TEST-69e49446084a7497223f75c4d653d7ea-X

---

**Document Complete**  
*All screens, components, flows, and configurations documented for rebuild from specification.*
