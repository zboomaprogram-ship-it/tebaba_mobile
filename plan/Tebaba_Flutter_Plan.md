# 📱 Tebaba Flutter App — Complete AI Agent Development Plan

> **Target:** Rebuild the Tebaba (طِبابة) medical business intelligence platform as a native Flutter mobile app with identical features, backend (Supabase), and UI language.

---

## 🗂️ Table of Contents

1. [Project Overview](#1-project-overview)
2. [Tech Stack](#2-tech-stack)
3. [App Architecture](#3-app-architecture)
4. [Supabase Backend Setup](#4-supabase-backend-setup)
5. [Folder Structure](#5-folder-structure)
6. [Screens & Features Map](#6-screens--features-map)
7. [Phase-by-Phase Build Plan](#7-phase-by-phase-build-plan)
8. [AI Agent Prompts (per phase)](#8-ai-agent-prompts-per-phase)
9. [Design System](#9-design-system)
10. [Key Widgets to Build](#10-key-widgets-to-build)
11. [Scoring Logic (Business Health Check)](#11-scoring-logic-business-health-check)
12. [PDF Export Strategy](#12-pdf-export-strategy)
13. [Estimated Timeline](#13-estimated-timeline)

---

## 1. Project Overview

**Tebaba (طِبابة)** is an Arabic-language AI-powered SaaS platform for medical business owners (clinics, hospitals, chains) in Egypt/MENA. The app:

- Authenticates users via Supabase (username + password stored in `profiles` table)
- Runs a **6-axis Business Health Check** with animated AI overlay and scoring
- Provides a **Hero Analysis Report** that accepts clinic data and outputs a detailed financial/operational report
- Shows **8 calculator tools** for medical business decisions (ROI, CAC, pricing, etc.)
- Has a **Journey flow**, **3 integrated systems** overview, **metrics**, and **pricing** sections
- Includes a **floating chat widget**, **exit-intent popup logic** (adapted as an in-app timer popup for mobile), and an **animated AI processing overlay**
- Generates **PDF reports** via the `pdf` Flutter package
- Is fully **RTL Arabic** UI

---

## 2. Tech Stack

| Layer            | Choice               | Reason                                                           |
| ---------------- | -------------------- | ---------------------------------------------------------------- |
| Framework        | Flutter 3.x          | Cross-platform, matches web component model                      |
| Language         | Dart                 | Required by Flutter                                              |
| Backend          | Supabase             | Same as web (existing `profiles` table + anon key)               |
| State Management | Riverpod 2.x         | Clean, testable, reactive                                        |
| Navigation       | GoRouter             | Declarative, deep-link ready                                     |
| Charts           | fl_chart             | Best Flutter charting library                                    |
| PDF Export       | pdf + printing       | Matches html2pdf.js behavior on web                              |
| HTTP/API         | Dio                  | For any external API calls (AI analysis endpoint if added later) |
| Local Storage    | SharedPreferences    | Persist auth session locally                                     |
| RTL Support      | Flutter native       | Flutter has full RTL support                                     |
| Animations       | flutter_animate      | Replaces CSS animations from the web                             |
| Fonts            | Google Fonts (Cairo) | Matches Arabic web font used                                     |

### `pubspec.yaml` dependencies

```yaml
dependencies:
  flutter:
    sdk: flutter
  supabase_flutter: ^2.x.x
  flutter_riverpod: ^2.x.x
  go_router: ^14.x.x
  fl_chart: ^0.69.x
  pdf: ^3.x.x
  printing: ^5.x.x
  flutter_animate: ^4.x.x
  google_fonts: ^6.x.x
  shared_preferences: ^2.x.x
  dio: ^5.x.x
  intl: ^0.19.x
  lottie: ^3.x.x
  url_launcher: ^6.x.x
```

---

## 3. App Architecture

```
lib/
├── main.dart                    # App entry, Supabase init, Riverpod scope
├── app.dart                     # GoRouter setup, MaterialApp.router, RTL Directionality
├── core/
│   ├── theme/
│   │   ├── app_colors.dart      # Teal (#00D1FF), dark backgrounds, gold accents
│   │   ├── app_text_styles.dart # Cairo font, weights, sizes
│   │   └── app_theme.dart       # ThemeData with RTL
│   ├── constants/
│   │   └── supabase_constants.dart  # URL + anon key
│   └── utils/
│       ├── score_calculator.dart    # Business Health Check logic (ported from JS)
│       └── currency_formatter.dart
├── features/
│   ├── auth/                    # Login + Signup screens + AuthNotifier
│   ├── home/                    # Main scrollable landing page
│   ├── health_check/            # 3-step form + scoring + results
│   ├── hero_analysis/           # Hero clinic analysis form + AnalysisReport
│   ├── tools/                   # 8 calculator tool screens
│   ├── report/                  # PDF generation + share
│   └── pricing/                 # Pricing page
├── shared/
│   ├── widgets/
│   │   ├── ai_overlay.dart          # Animated AI processing overlay
│   │   ├── score_ring.dart          # SVG-like animated score ring
│   │   ├── section_header.dart      # Reusable section title + eyebrow
│   │   ├── metric_card.dart         # Stats cards (+40%, 3.2x, etc.)
│   │   ├── chat_fab.dart            # Floating chat button with tooltip popup
│   │   └── custom_dropdown.dart     # Styled Arabic dropdown (matches web)
│   └── providers/
│       ├── auth_provider.dart
│       └── app_state_provider.dart
└── services/
    ├── supabase_service.dart
    └── pdf_service.dart
```

---

## 4. Supabase Backend Setup

### Existing table (already in use by web app)

```sql
-- profiles table (already exists)
create table profiles (
  id uuid primary key default uuid_generate_v4(),
  email text unique not null,
  full_name text,
  created_at timestamp default now()
);
```

### New tables to add for mobile features

```sql
-- Save health check results per user
create table health_check_results (
  id uuid primary key default uuid_generate_v4(),
  user_id uuid references profiles(id),
  scores jsonb not null,
  overall_score integer,
  form_data jsonb,
  created_at timestamp default now()
);

-- Save hero analysis reports
create table analysis_reports (
  id uuid primary key default uuid_generate_v4(),
  user_id uuid references profiles(id),
  report_data jsonb not null,
  created_at timestamp default now()
);
```

### Supabase initialization in Flutter

```dart
// main.dart
await Supabase.initialize(
  url: 'https://vaycshsakmvvlnitxzzh.supabase.co',
  anonKey: 'sb_publishable_7i5czlkdkrGM2IRmcVMycw_s96TFbMB',
);
```

---

## 5. Folder Structure (Detailed)

```
tebaba_app/
├── android/
├── ios/
├── lib/
│   ├── main.dart
│   ├── app.dart
│   ├── core/
│   │   ├── theme/
│   │   │   ├── app_colors.dart
│   │   │   ├── app_text_styles.dart
│   │   │   └── app_theme.dart
│   │   ├── constants/
│   │   │   └── supabase_constants.dart
│   │   └── utils/
│   │       ├── score_calculator.dart
│   │       └── validators.dart
│   ├── features/
│   │   ├── auth/
│   │   │   ├── screens/
│   │   │   │   ├── login_screen.dart
│   │   │   │   └── signup_screen.dart
│   │   │   ├── widgets/
│   │   │   │   └── auth_text_field.dart
│   │   │   └── providers/
│   │   │       └── auth_notifier.dart
│   │   ├── home/
│   │   │   ├── screens/
│   │   │   │   └── home_screen.dart
│   │   │   └── widgets/
│   │   │       ├── header_widget.dart
│   │   │       ├── why_section.dart
│   │   │       ├── ai_explain_section.dart
│   │   │       ├── journey_section.dart
│   │   │       ├── systems_section.dart
│   │   │       ├── metrics_section.dart
│   │   │       └── footer_widget.dart
│   │   ├── health_check/
│   │   │   ├── screens/
│   │   │   │   ├── health_check_screen.dart
│   │   │   │   └── health_results_screen.dart
│   │   │   ├── widgets/
│   │   │   │   ├── step_one_widget.dart
│   │   │   │   ├── step_two_widget.dart
│   │   │   │   ├── step_three_widget.dart
│   │   │   │   └── score_ring_grid.dart
│   │   │   └── providers/
│   │   │       └── health_check_notifier.dart
│   │   ├── hero_analysis/
│   │   │   ├── screens/
│   │   │   │   ├── hero_form_screen.dart
│   │   │   │   └── analysis_report_screen.dart
│   │   │   └── providers/
│   │   │       └── analysis_notifier.dart
│   │   ├── tools/
│   │   │   ├── screens/
│   │   │   │   ├── tools_list_screen.dart
│   │   │   │   ├── roi_calculator_screen.dart
│   │   │   │   ├── cac_calculator_screen.dart
│   │   │   │   ├── operations_efficiency_screen.dart
│   │   │   │   ├── pricing_engine_screen.dart
│   │   │   │   ├── profitability_screen.dart
│   │   │   │   ├── expansion_study_screen.dart
│   │   │   │   ├── hr_support_screen.dart
│   │   │   │   └── inventory_screen.dart
│   │   │   └── widgets/
│   │   │       └── tool_card_widget.dart
│   │   ├── report/
│   │   │   ├── screens/
│   │   │   │   └── report_screen.dart
│   │   │   └── services/
│   │   │       └── pdf_generator.dart
│   │   └── pricing/
│   │       └── screens/
│   │           └── pricing_screen.dart
│   └── shared/
│       ├── widgets/
│       │   ├── ai_overlay.dart
│       │   ├── score_ring.dart
│       │   ├── section_header.dart
│       │   ├── metric_card.dart
│       │   ├── chat_fab.dart
│       │   ├── teal_button.dart
│       │   └── custom_dropdown.dart
│       └── providers/
│           └── app_state_provider.dart
├── assets/
│   ├── images/
│   │   └── hero.png
│   ├── fonts/
│   └── lottie/
│       └── ai_brain.json         # Lottie animation for AI overlay
├── pubspec.yaml
└── README.md
```

---

## 6. Screens & Features Map

| Screen             | Route              | Web Equivalent             | Key Features                                                                                                                |
| ------------------ | ------------------ | -------------------------- | --------------------------------------------------------------------------------------------------------------------------- |
| Splash             | `/`                | –                          | Logo animation, auth check                                                                                                  |
| Login              | `/login`           | Auth Modal (login mode)    | Email/username + password, Supabase query                                                                                   |
| Signup             | `/signup`          | Auth Modal (signup mode)   | Name + email + password, insert to profiles                                                                                 |
| Home               | `/home`            | Full landing page          | Scrollable sections: Header, Hero Form, HealthCheck, Tools, AIExplain, Why, Journey, Systems, Metrics, Pricing, CTA, Footer |
| Health Check       | `/health-check`    | HealthCheck component      | 3-step stepper form, AI overlay animation, 6-axis scoring                                                                   |
| Health Results     | `/health-results`  | Results inside HealthCheck | Score rings, recommendations, PDF export                                                                                    |
| Hero Analysis Form | `/analysis`        | Hero component             | Clinic data form, generates AnalysisReport                                                                                  |
| Analysis Report    | `/analysis/report` | AnalysisReport component   | Charts, scores, financial projections                                                                                       |
| Tools List         | `/tools`           | Tools section              | 8 tool cards grid                                                                                                           |
| Tool Detail        | `/tools/:id`       | (inline in web)            | Each of the 8 calculators                                                                                                   |
| Pricing            | `/pricing`         | Pricing section            | 3 tier cards with CTA                                                                                                       |
| Report PDF         | `/report/pdf`      | html2pdf export            | PDF preview + share                                                                                                         |
| Chat               | (bottom sheet)     | Chat widget                | WhatsApp link + in-app popup                                                                                                |

---

## 7. Phase-by-Phase Build Plan

### Phase 0 — Project Bootstrap (Day 1)

- [ ] `flutter create tebaba_app --org com.tebaba`
- [ ] Add all dependencies to `pubspec.yaml`
- [ ] Initialize Supabase in `main.dart`
- [ ] Set up Riverpod `ProviderScope` wrapper
- [ ] Configure RTL `Directionality` for Arabic
- [ ] Set up GoRouter with all routes
- [ ] Apply Cairo Google Font globally
- [ ] Add dark theme with teal (`#00D1FF`) accent color
- [ ] Set up constants file with Supabase credentials

---

### Phase 1 — Auth System (Day 1–2)

- [ ] Build `LoginScreen` with username + password fields
- [ ] Build `SignupScreen` with name + username + password fields
- [ ] Create `AuthNotifier` (Riverpod StateNotifier)
- [ ] Implement `supabase.from('profiles').select()` for login
- [ ] Implement `supabase.from('profiles').insert()` for signup
- [ ] Handle errors in Arabic (duplicate email, user not found)
- [ ] Persist login state with SharedPreferences
- [ ] Auto-navigate to Home if session exists
- [ ] Add animated teal button with loading state

---

### Phase 2 — Design System & Shared Widgets (Day 2–3)

- [ ] `AppColors` class: `teal`, `darkBg`, `cardBg`, `gold`, `error`, `line`
- [ ] `AppTextStyles` class: heading1, heading2, body, eyebrow, badge (all Cairo)
- [ ] `AppTheme`: dark theme, no splash color, RTL scaffold
- [ ] `SectionHeader` widget: eyebrow tag + title + subtitle
- [ ] `TealButton` widget: gradient, loading state, disabled state
- [ ] `CustomDropdown` widget: styled Arabic dropdown with animation (matches web)
- [ ] `MetricCard` widget: icon + value + label in dark card
- [ ] `AiOverlay` widget: fullscreen overlay with steps list + progress bar + brain emoji/lottie
- [ ] `ScoreRing` widget: animated circular progress with percentage counter
- [ ] `ChatFab` widget: floating button + tooltip bubble popup
- [ ] `StepProgressBar` widget: step pills (بيانات البزنس → الأداء التشغيلي → التسويق والنمو)

---

### Phase 3 — Home Screen (Landing Page) (Day 3–5)

Build as a single `CustomScrollView` with `SliverList` sections:

- [ ] **Header**: App bar with logo "طِبابة" + login button (if not logged in) + username (if logged in)
- [ ] **Hero Section**: Clinic analysis input form card (see Phase 5)
- [ ] **Health Check Card**: Teaser card → navigates to `/health-check`
- [ ] **Tools Grid**: 8 tool cards → navigates to `/tools/:id`
- [ ] **AIExplain Section**: Pipeline visualization (5 steps with connector lines)
- [ ] **Why Section**: Bridge visual with orbital animation + 4 why-points
- [ ] **Journey Section**: 7-step horizontal flow (Lead → WhatsApp → AI → Booking → Visit → Follow-up → Retention)
- [ ] **Systems Section**: 3 system cards (Patient Experience, Business Management, Operations Engine)
- [ ] **Metrics Section**: 6 metric cards with animated counter on scroll
- [ ] **Pricing Section**: 3 pricing cards (Starter 999, Pro 2499, Enterprise)
- [ ] **CTA Section**: Email + WhatsApp links
- [ ] **Footer**: Links + copyright
- [ ] **Chat FAB**: Persistent over all sections
- [ ] **Engagement Popup**: Show bottom sheet after 12 seconds ("هل تريد نمو بزنسك؟")

---

### Phase 4 — Business Health Check (Day 5–7)

This is the core feature — 3-step form with 6-axis AI scoring.

#### Step 1 — Business Data

- Currency selector (EGP / USD / SAR) — toggle buttons
- Clinic type dropdown (عيادة خاصة / مركز طبي / مستشفى صغير / سلسلة عيادات)
- Specialty dropdown (10 options: dental, derma, eyes, ortho, pedia, gyne, internal, cardio, neuro, other)
- Monthly revenue (numeric input)
- New patients per month (numeric input)
- Average service price (numeric input)
- Number of doctors dropdown

#### Step 2 — Operational Performance

- No-show rate (numeric input, %)
- CRM system type (none / excel / basic / advanced)
- Response time (instant / fast / medium / slow)
- Retention rate (numeric input, %)
- Booking method (phone / online / mixed)

#### Step 3 — Marketing & Growth

- Marketing budget (numeric input)
- Instagram activity (inactive / basic / active)
- Patient source (referral / ads / mixed)
- Growth goal dropdown (maintain / grow20 / grow50 / scale)

#### AI Processing Overlay (triggered on submit)

Steps shown during fake AI processing:

1. "تحليل بيانات المركز"
2. "تقييم الكفاءة التشغيلية"
3. "نمذجة الأداء المالي"
4. "بناء التوصيات"

Duration: 2600ms with animated progress bar 0→100%

#### Results Screen

- Overall score gauge (large)
- 6 `ScoreRing` widgets in grid: Marketing, Operations, Patient Experience, Financial, Team, Growth
- Recommendations list based on score thresholds
- "Export PDF" button
- "إعادة الفحص" (reset) button
- Save results to Supabase `health_check_results` table (if logged in)

---

### Phase 5 — Hero Analysis Form & Report (Day 7–9)

Mirrors the `Hero.jsx` + `AnalysisReport.jsx` components.

#### Hero Form Inputs

- Clinic type + specialty (same dropdowns as Health Check)
- Monthly revenue + patients + service price
- Number of doctors
- Marketing budget + Instagram status
- Primary goal

#### Analysis Report Output

Full scrollable report screen with:

- Executive summary card
- Revenue gap analysis (theoretical vs actual)
- Score rings for all 6 axes
- Bar charts (fl_chart) for performance breakdown
- Financial projections (3-month + 6-month targets)
- Top 3 recommendations with priority tags
- PDF export button

---

### Phase 6 — 8 Calculator Tools (Day 9–12)

Each tool is its own screen with input fields + calculation result. All ported from the web app's planned tools:

| #   | Tool                   | Key Inputs                                               | Output                      |
| --- | ---------------------- | -------------------------------------------------------- | --------------------------- |
| 1   | Medical Asset ROI      | Equipment cost, monthly revenue from it, maintenance     | ROI%, payback period        |
| 2   | CAC Calculator         | Marketing spend, new patients acquired                   | CAC, LTV ratio              |
| 3   | Operations Efficiency  | Rooms, doctors, daily appointments                       | Utilization%, capacity gap  |
| 4   | Optimal Pricing Engine | Cost per service, overhead, target margin                | Optimal price, price range  |
| 5   | Service Profitability  | Revenue per service, cost per service                    | Net margin, ranking         |
| 6   | Expansion Feasibility  | Setup cost, expected monthly revenue, break-even target  | Break-even months, ROI      |
| 7   | HR Decision Support    | Current revenue, expected new patients from hire, salary | Net gain/loss from hire     |
| 8   | Inventory Management   | Item name, monthly usage, unit cost, lead time           | Reorder point, holding cost |

All tools share the same card layout with a styled result panel that animates in.

---

### Phase 7 — PDF Export (Day 12–13)

Using the `pdf` + `printing` Flutter packages:

- Generate PDF report from Health Check results OR Analysis Report
- Include: Logo, date, scores, charts (rendered as images), recommendations
- Use Arabic text with a bundled Arabic font (Cairo or Tajawal)
- Share via `printing.sharePdf()` (native share sheet)
- Save to device storage option

```dart
// pdf_generator.dart sketch
Future<Uint8List> generateHealthCheckPDF(HealthCheckResults results) async {
  final pdf = pw.Document();
  final arabicFont = await PdfGoogleFonts.cairoRegular();

  pdf.addPage(pw.MultiPage(
    textDirection: pw.TextDirection.rtl,
    theme: pw.ThemeData.withFont(base: arabicFont),
    build: (context) => [
      _buildHeader(),
      _buildScoreSection(results.scores),
      _buildRecommendations(results),
    ],
  ));

  return pdf.save();
}
```

---

### Phase 8 — Polish & Animations (Day 13–15)

- [ ] Add `flutter_animate` entrance animations to all section cards (fade + slide)
- [ ] Animated counter widget for metrics (0 → final value on scroll-into-view)
- [ ] Smooth page transitions via GoRouter
- [ ] Loading skeletons for Supabase data fetches
- [ ] Empty state screens
- [ ] Error handling with styled Arabic error messages
- [ ] Pull-to-refresh on home screen
- [ ] Dark mode is the default (matches web)
- [ ] Haptic feedback on primary button taps
- [ ] Scroll-reveal effect using `VisibilityDetector` package

---

## 8. AI Agent Prompts (per phase)

Use these prompts with an AI coding agent (Claude Code, Cursor, Copilot, etc.):

---

### Prompt 1 — Bootstrap

```
Create a Flutter app called "tebaba_app".
- Add these packages: supabase_flutter, flutter_riverpod, go_router, fl_chart, pdf, printing, flutter_animate, google_fonts, shared_preferences, dio, intl, url_launcher
- In main.dart: initialize Supabase with URL "https://vaycshsakmvvlnitxzzh.supabase.co" and anon key "sb_publishable_7i5czlkdkrGM2IRmcVMycw_s96TFbMB"
- Wrap the app in ProviderScope and Directionality(textDirection: TextDirection.rtl)
- Apply Cairo Google Font globally
- Set dark theme with primary color #00D1FF (teal)
- Set up GoRouter with routes: /login, /signup, /home, /health-check, /health-results, /tools, /tools/:id, /analysis, /pricing
- Create app_colors.dart with: teal=#00D1FF, darkBg=#030C0C, cardBg=rgba(11,79,108,0.15), gold=#FFB800
```

---

### Prompt 2 — Auth

```
In the Flutter tebaba_app, build the authentication system:

LOGIN SCREEN (/login):
- Dark background (#030C0C), Cairo font, RTL
- Logo "طِبابة" at top
- Title "تسجيل الدخول"
- Username text field (Arabic label "اسم المستخدم")
- Password field (Arabic label "كلمة المرور")
- Teal submit button "دخول الآن" with left-pointing arrow animation
- Toggle link "ليس لديك حساب؟ سجل الآن" → /signup
- On submit: query Supabase profiles table WHERE email = username → store user in SharedPreferences → navigate to /home
- Show Arabic error messages for not-found and other errors

SIGNUP SCREEN (/signup):
- Same design + full name field "الاسم الكامل" above username
- On submit: INSERT into profiles (email, full_name) → navigate to /home
- Duplicate key error → show "هذا الاسم مسجل بالفعل"

Create AuthNotifier (Riverpod AsyncNotifier) with login(), signup(), logout(), checkSession() methods.
```

---

### Prompt 3 — Design System

```
In tebaba_app, create these shared widgets:

1. SectionHeader widget: takes eyebrowText (String), title (String), subtitle (String). Renders a small teal pill (eyebrow), large bold white title, and grey subtitle. All centered, Cairo font, RTL.

2. ScoreRing widget: takes score (int 0-100), label (String), color (Color). Renders an animated circular progress ring that counts from 0 to score over 1500ms. Color is red below 50, the passed color otherwise. Shows score% in center + label below.

3. AiOverlay widget: fullscreen dark overlay (opacity 0.95) with:
   - Brain emoji or Lottie animation centered
   - Title "ذكاؤنا الاصطناعي يحلل بياناتك"
   - List of step strings
   - Animated linear progress bar (teal fill)
   - Accepts: isVisible (bool), steps (List<String>), progress (double 0-1)

4. TealButton widget: takes label, onPressed, isLoading. Styled with teal background #00D1FF, black bold text, 20px border radius, full width. Shows CircularProgressIndicator when isLoading=true.

5. CustomDropdown widget: RTL-styled dropdown with teal border, dark background, Arabic options. Takes: label, icon, value, List<DropdownItem>, onChanged.

6. ChatFab widget: fixed bottom-right floating button (💬 icon, teal). Shows a tooltip bubble "هل تريد نمو بزنسك؟" after 4 seconds, auto-hides after 5 seconds. Tapping launches WhatsApp URL.
```

---

### Prompt 4 — Health Check Feature

```
In tebaba_app, build the Business Health Check feature at /health-check:

STATE: Create HealthCheckNotifier (Riverpod Notifier) holding:
- currentStep: int (1-3)
- formData: HealthCheckFormData model (all fields from below)
- results: HealthCheckResults?
- isCalculating: bool

STEP PROGRESS BAR: Three pill buttons at top: "بيانات البزنس" | "الأداء التشغيلي" | "التسويق والنمو"

STEP 1 (Business Data):
- Currency toggle: EGP(ج.م) / USD($) / SAR(ريال) - 3 buttons, selected=teal bg
- Clinic type dropdown: عيادة خاصة / مركز طبي متخصص / مستشفى صغير / سلسلة عيادات
- Specialty dropdown: أسنان / جلدية وتجميل / عيون / عظام / أطفال / نساء وتوليد / باطنة / قلب / مخ وأعصاب / أخرى
- Monthly revenue input (numeric, currency suffix)
- New patients/month input (numeric)
- Average service price input (numeric)
- Doctors count dropdown: طبيب واحد / 2-3 / 4-6 / أكثر من 7

STEP 2 (Operations):
- No-show rate % input
- CRM type: لا يوجد / إكسل / نظام أساسي / نظام متقدم
- Response time: فوري / سريع / متوسط / بطيء
- Retention rate % input
- Booking method: هاتف / أونلاين / مختلط

STEP 3 (Marketing & Growth):
- Marketing budget input
- Instagram status: غير نشط / أساسي / نشط
- Patient source: إحالات / إعلانات / مختلط
- Growth goal: المحافظة / نمو 20% / نمو 50% / توسع كامل

CALCULATION (port this JavaScript scoring logic to Dart):
[See Section 11 of this document for the full scoring algorithm]

On "احسب النتيجة" button: show AiOverlay for 2600ms with steps, then navigate to /health-results with results.

RESULTS SCREEN:
- Large overall score ScoreRing (size 140px)
- 6 smaller ScoreRings in 2×3 grid: تسويق / تشغيل / تجربة مريض / مالي / فريق / نمو
- Color coding: red<50, orange<70, green≥70
- Recommendations section based on score values
- "تصدير PDF" button → pdf_generator.dart
- "إعادة الفحص" button → reset and go back
```

---

### Prompt 5 — Tools List & Calculators

```
In tebaba_app, build the Tools section at /tools:

TOOLS LIST SCREEN:
- Grid of 8 ToolCard widgets (2-column grid)
- Each card has: category badge (Finance/Marketing/Operations etc), icon emoji, title (Arabic), description (Arabic), "استكشف الأداة ←" link
- Tapping card navigates to /tools/:id

The 8 tools and their IDs:
1. roi - "قياس العائد الاستثماري للأصول الطبية" (Finance)
2. cac - "احسب تكلفة جذب كل مريض بدقة" (Marketing)
3. ops - "تقييم كفاءة التشغيل والسعة الاستيعابية" (Operations)
4. pricing - "محرك ذكي لتحديد الأسعار الطبية المثلى" (Strategy)
5. profit - "تحليل ربحية الخدمات لدعم القرار" (Analytics)
6. expansion - "دراسة جدوى التوسع وفتح الفروع الجديدة" (Expansion)
7. hr - "نظام ذكي لدعم قرارات التوظيف" (HR)
8. inventory - "إدارة المخزون الطبي" (Inventory)

For each tool screen, build:
- Input fields specific to that tool (see Tool Details in the plan)
- "احسب" calculate button (teal)
- Animated result panel that slides up showing the computed metrics
- "إعادة الحساب" reset button

ROI Tool inputs: equipment cost, monthly revenue from equipment, monthly maintenance cost
ROI outputs: monthly profit, annual ROI%, payback period in months

CAC Tool inputs: monthly marketing spend, new patients acquired that month
CAC outputs: CAC value, benchmark comparison, LTV estimate (CAC × 8)

OPERATIONS EFFICIENCY inputs: number of rooms, doctors, daily appointments, working hours
Outputs: utilization %, capacity gap, recommended appointments/day

PRICING ENGINE inputs: direct cost, overhead per service, target profit margin %
Outputs: minimum price, recommended price, optimal price with full margin
```

---

### Prompt 6 — Home Screen Sections

```
In tebaba_app, build the Home Screen as a CustomScrollView with RTL direction.

Include these sections in order as SliverToBoxAdapter children:

1. HEADER: App bar row with logo "طِبابة" (large teal text), and if user logged in show "مرحباً {name}" else show "دخول" button

2. HERO SECTION: Dark card with headline "نمّ مركزك الطبي بذكاء اصطناعي" + subheadline + two buttons: "ابدأ الفحص المجاني" (→ /health-check) and "استكشف الأدوات" (→ /tools)

3. WHY SECTION (SectionHeader + 4 WhyPoint rows):
Points: "من Lead لمريض دائم" / "حوّل البيانات إلى قرارات" / "أتمتة ذكية بدون فوضى" / "ROI قابل للقياس"
Each point: icon (emoji in teal circle) + title (bold white) + description (grey)

4. AI EXPLAIN SECTION: 5-step pipeline visualization (vertical on mobile):
Steps: 📥 استقبال بيانات → 🔍 تحليل 6 محاور → 📊 نمذجة الأداء → 🎯 توليد توصيات → ✅ قرارات قابلة للتنفيذ
Connect steps with vertical teal dashed lines

5. JOURNEY SECTION: Horizontal scrollable 7-step flow:
1-Lead → 2-WhatsApp → 3-AI → 4-Booking → 5-Visit → 6-Follow-up → 7-Retention
Each step: number badge + emoji + Arabic label, connected by left-pointing arrows

6. SYSTEMS SECTION: 3 dark cards (scrollable horizontally on mobile):
"نظام تجربة المريض" / "نظام إدارة البزنس" / "محرك التشغيل والنمو"
Each card: icon + title + description + 5 bullet features

7. METRICS SECTION: 2×3 grid of MetricCard widgets:
+40% زيادة المرضى / 3.2x تحسين Conversion / -60% تخفيض CAC / 85% Retention Rate / 2.8x نمو الإيرادات / -40% تقليل No-Show
Animate counter from 0 to value when scrolled into view using VisibilityDetector

8. PRICING SECTION: 3 pricing cards (horizontally scrollable):
Starter 999ج.م: CRM 500 مريض, حجز ذكي, WhatsApp Automation
Pro 2499ج.م (featured - teal border): + AI Chat Engine, No-Show Predictor, تقارير CAC+LTV+ROI
Enterprise: تواصل معنا
Each card: plan name + price + features list + CTA button

9. FOOTER: Logo + nav links + copyright "© 2025 طِبابة"

Add a ChatFab widget fixed at bottom-right over all sections.
Show an engagement BottomSheet after 12 seconds: "هل تريد نمو بزنسك؟ تحدث مع مستشارنا الآن!" with WhatsApp button.
```

---

### Prompt 7 — PDF Generation

```
In tebaba_app, create lib/features/report/services/pdf_generator.dart

Requirements:
- Use the `pdf` and `printing` Flutter packages
- Load Cairo Arabic font from Google Fonts or bundled TTF
- Set text direction to RTL throughout
- Function: Future<Uint8List> generateHealthCheckPDF(HealthCheckResults results)

PDF Layout:
Page 1 - Cover:
  - Logo "طِبابة" (large, teal color)
  - Report title: "تقرير صحة البزنس الطبي"
  - Date (formatted in Arabic)
  - Overall score as a large number + label

Page 2 - Score Breakdown:
  - Section title "تفصيل الدرجات"
  - 6 rows, each: label (Arabic) | score bar | score value
  - Color coded (red/orange/green)

Page 3 - Recommendations:
  - Section title "التوصيات الاستراتيجية"
  - List of recommendations based on weak scores

Also create:
- Function: Future<void> sharePDF(Uint8List pdfBytes) using Printing.sharePdf()
- Function: Future<void> previewPDF(Uint8List pdfBytes, BuildContext context) using Printing.layoutPdf()
```

---

## 9. Design System

### Color Palette

```dart
// app_colors.dart
class AppColors {
  static const teal = Color(0xFF00D1FF);        // Primary accent
  static const tealDim = Color(0x1A00C2A8);      // Teal with low opacity
  static const gold = Color(0xFFFFB800);          // Secondary accent
  static const darkBg = Color(0xFF030C0C);        // Main background
  static const cardBg = Color(0xFF0B1A1A);        // Card background
  static const lineColor = Color(0xFF1A3A3A);     // Borders / dividers
  static const textPrimary = Colors.white;
  static const textSecondary = Color(0xFF7AAEC5); // Muted text
  static const error = Color(0xFFFF4757);
  static const success = Color(0xFF00CC66);
  static const warning = Color(0xFFFFA400);
}
```

### Typography

```dart
// app_text_styles.dart  (all Cairo font)
class AppTextStyles {
  static final heading1 = GoogleFonts.cairo(fontSize: 32, fontWeight: FontWeight.w900, color: Colors.white);
  static final heading2 = GoogleFonts.cairo(fontSize: 24, fontWeight: FontWeight.w800, color: Colors.white);
  static final heading3 = GoogleFonts.cairo(fontSize: 18, fontWeight: FontWeight.w700, color: Colors.white);
  static final body = GoogleFonts.cairo(fontSize: 14, color: AppColors.textSecondary);
  static final eyebrow = GoogleFonts.cairo(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.teal, letterSpacing: 1.5);
  static final button = GoogleFonts.cairo(fontSize: 16, fontWeight: FontWeight.w900, color: Colors.black);
}
```

### Spacing & Radius

```dart
class AppSpacing {
  static const xs = 4.0;
  static const sm = 8.0;
  static const md = 16.0;
  static const lg = 24.0;
  static const xl = 32.0;
  static const xxl = 48.0;
}

class AppRadius {
  static const sm = Radius.circular(12);
  static const md = Radius.circular(20);
  static const lg = Radius.circular(35);
  static const pill = Radius.circular(50);
}
```

---

## 10. Key Widgets to Build

### ScoreRing (animated circular progress)

```dart
// Matches the web ScoreRing SVG component
class ScoreRing extends StatefulWidget {
  final int score;       // 0-100
  final String label;
  final Color? color;
  final double size;

  // Animates count from 0 → score over 1500ms
  // Uses CustomPainter for the arc
  // Color logic: score < 50 → red, else color param or orange/green by threshold
}
```

### AiOverlay (processing animation)

```dart
// Full-screen overlay matching the web's ai-processing-overlay
class AiOverlay extends StatelessWidget {
  final bool isVisible;
  final List<String> steps;
  final double progress;  // 0.0 to 1.0

  // Dark background, brain emoji, step list, teal progress bar
  // Controlled by parent via showAIOverlay() function
}
```

### StepProgressBar

```dart
// 3 pill-shaped steps at top of Health Check
class StepProgressBar extends StatelessWidget {
  final int currentStep;  // 1, 2, or 3
  final List<String> labels;
  // Active step: teal background; completed: teal border+checkmark; upcoming: grey
}
```

---

## 11. Scoring Logic (Business Health Check)

Port this JavaScript directly to Dart in `score_calculator.dart`:

```dart
class ScoreCalculator {
  static HealthCheckResults calculate(HealthCheckFormData data) {
    final scores = <String, int>{};

    // Marketing Score
    int mkt = 40;
    if (data.instagram == 'active') mkt += 25;
    else if (data.instagram == 'basic') mkt += 12;
    if (data.source == 'mixed') mkt += 20;
    else if (data.source == 'ads') mkt += 15;
    if (double.tryParse(data.mktbudget) != null) {
      final budget = double.parse(data.mktbudget);
      if (budget > 5000) mkt += 10;
      else if (budget > 2000) mkt += 5;
    }
    scores['marketing'] = mkt.clamp(0, 95);

    // Operations Score
    int ops = 30;
    if (data.crm == 'advanced') ops += 35;
    else if (data.crm == 'basic') ops += 20;
    else if (data.crm == 'excel') ops += 8;
    if (data.response == 'instant') ops += 20;
    else if (data.response == 'fast') ops += 12;
    else if (data.response == 'medium') ops += 5;
    if (data.booking == 'mixed') ops += 10;
    else if (data.booking == 'online') ops += 8;
    scores['operations'] = ops.clamp(0, 93);

    // Patient Experience Score
    int px = 40;
    final retention = double.tryParse(data.retention) ?? 0;
    if (retention > 60) px += 35;
    else if (retention > 40) px += 20;
    else if (retention > 20) px += 10;
    final noshow = double.tryParse(data.noshow) ?? 100;
    if (noshow < 10) px += 20;
    else if (noshow < 20) px += 10;
    scores['patientexp'] = px.clamp(0, 92);

    // Financial Score
    final patients = double.tryParse(data.patients) ?? 0;
    final price = double.tryParse(data.price) ?? 0;
    final revenue = double.tryParse(data.revenue) ?? 0;
    final theoreticalRev = patients * price;
    int fin = 40;
    if (theoreticalRev > 0) {
      if (revenue >= theoreticalRev * 0.85) fin += 40;
      else if (revenue >= theoreticalRev * 0.70) fin += 25;
      else if (revenue >= theoreticalRev * 0.50) fin += 12;
    }
    scores['financial'] = fin.clamp(0, 90);

    // Team Score
    int team = 45;
    if (data.doctors == '4-6' || data.doctors == '7+') team += 20;
    else if (data.doctors == '2-3') team += 10;
    if (retention > 50) team += 25;
    else if (retention > 30) team += 12;
    scores['team'] = team.clamp(0, 90);

    // Growth Score
    int growth = 30;
    if (data.goal == 'scale') growth += 40;
    else if (data.goal == 'grow50') growth += 25;
    else if (data.goal == 'grow20') growth += 15;
    scores['growth'] = growth.clamp(0, 92);

    final overall = scores.values.reduce((a, b) => a + b) ~/ scores.length;
    return HealthCheckResults(scores: scores, overall: overall);
  }
}
```

---

## 12. PDF Export Strategy

The web uses `html2pdf.js`. Flutter equivalent:

```
pdf package (dart) → generates PDF in memory as Uint8List
printing package  → share via native share sheet OR preview in-app
```

For Arabic text in PDFs:

1. Bundle a Cairo TTF font in `assets/fonts/Cairo-Regular.ttf` and `Cairo-Bold.ttf`
2. Reference in `pubspec.yaml` under `flutter.fonts`
3. Load with `PdfFont` from raw bytes in the pdf package

Charts in PDF:

- Render `fl_chart` widgets off-screen → capture as image bytes using `RepaintBoundary` → embed in PDF

---

## 13. Estimated Timeline

| Phase     | Tasks                                     | Days         |
| --------- | ----------------------------------------- | ------------ |
| 0         | Bootstrap, routing, theme                 | 1            |
| 1         | Auth (login + signup + Supabase)          | 1–2          |
| 2         | Design system + shared widgets            | 2            |
| 3         | Home screen (all sections)                | 3            |
| 4         | Health Check (3-step + scoring + results) | 3            |
| 5         | Hero analysis form + report screen        | 2            |
| 6         | 8 calculator tools                        | 3            |
| 7         | PDF export + share                        | 2            |
| 8         | Animations, polish, testing               | 2            |
| **Total** |                                           | **~19 days** |

---

## ✅ Checklist for AI Agents

Before marking each phase complete, verify:

- [ ] All Arabic text is correct and displays RTL
- [ ] Cairo font renders on both Android and iOS
- [ ] Supabase calls have error handling with Arabic error messages
- [ ] All forms validate before proceeding to next step
- [ ] Score calculations match the JavaScript original exactly
- [ ] AI overlay shows and hides correctly before/after calculation
- [ ] PDF exports Arabic text correctly (no missing glyphs)
- [ ] App works offline for all calculator tools (no network needed except auth + save)
- [ ] Dark theme applies globally with no light-mode flashes
- [ ] RTL layout is correct for all screens (icons, text, arrows all flipped)

---

_Plan generated from full source code analysis of the Tebaba (طِبابة) web application — React + Vite + Supabase + Chart.js → Flutter equivalent._
