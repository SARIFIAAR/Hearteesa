# Hartessa — Competitor Teardown, Master Feature List & Agile Build Plan

**Date:** 2026-10-29  
**Author:** MetaTec R&D  
**Decision context:** Hartessa is MetaTec's next app — a premium, frictionless, cross-platform blood pressure logger. It is the highest-scoring candidate from the 6-session market scan (Core-4: 16.5/20; grand total 33.5/40). This document feeds directly into the Hearteesa repo build.

**Related:** `next-app-market-scan-2026-10.md` · `next-app-selection-brief.md` (Nucleus memory)

---

## Part 1 — Competitor Teardowns

### App 1: SmartBP — Blood Pressure Tracker

| Field | Detail |
|---|---|
| Platform | iOS + Android |
| Developer | Evolve Medical Systems, LLC |
| Bundle ID | com.smartbloodpressure (iOS: 519076558) |
| Downloads | 30k/month |
| Ratings | 4.5 ★ · 60.8k reviews (iOS) |
| Revenue est. | ~$70k/month (Adapty data, 2026) |
| Category rank | ~#109–145 Top Free Medical (US) |
| Last updated | Oct 2026 (v11.6.2) |

#### Screens & Flows

**Onboarding (24 steps):**
1. Splash / app launch
2. Welcome screen
3. Notification permission request
4. Paywall screen (early — appears before first reading)
5. Profile creation
6. First BP reading entry
7. Tutorial overlays on key UI elements

**Navigation structure:**
- Home (3 screens): dashboard, last reading summary, quick-add button
- Insights (5 screens): trend charts, statistics, AM/PM breakdown, correlation chart, period selector
- Data Sync (2 screens): Apple Health / Bluetooth monitor setup
- My Health (2 screens): weight log, medications list
- More (5 screens): profiles, reports/export, clinic sharing, settings
- Preferences (2 screens): units, display options

#### Features (exhaustive)

**Data entry:**
- Systolic + diastolic + pulse (manual entry)
- Weight (manual entry)
- BMI auto-calculated
- Pulse Pressure (PP) auto-calculated
- Mean Arterial Pressure (MAP) auto-calculated
- Date/time (manual or auto-timestamp)
- Custom notes field
- Tags (pre-set + custom: stress, salty diet, caffeine, medication name, major events)
- Symptom logging
- Irregular heartbeat flag (via Bluetooth cuff data)
- ECG/EKG report integration (via Apple Health)

**Data visualization:**
- Line chart over time
- Scatter plot: systolic vs. diastolic
- AM/PM split bar chart
- Correlation chart (custom tag vs. reading level)
- Period selector: 7, 14, 30, 60, 90 days, custom
- Color-coded readings: Normal / Elevated / High Stage 1 / High Stage 2 / Crisis
- Statistical summary: average, min, max, standard deviation

**Standards supported:**
- 2017 ACC/AHA
- 2018 ESC/ESH
- Custom thresholds

**Export & sharing:**
- PDF report (PREMIUM)
- CSV export (PREMIUM)
- Email/share to doctor
- SmartBP Care — free clinic portal; doctor sees 7-day averages + trends + medication log

**Integrations:**
- Apple Health (read + write)
- Google Fit
- Bluetooth BP monitors: A&D, Omron, Beurer, Transtek, iHealth, Microlife
- Dropbox import/export (PREMIUM)
- Google Drive import/export (PREMIUM)
- SmartBP Cloud cross-device sync (PREMIUM)

**Smart device:**
- Apple Watch companion app (PREMIUM) — log from wrist, see last reading complication

**Other:**
- Siri voice logging ("Hey Siri, log my BP")
- Multiple profiles: up to 10 users (one-time purchase $5.99)
- Touch ID / Face ID / PIN lock
- HIPAA + GDPR compliant (Vanta-monitored)
- Medication reminders + adherence tracking + dose color-coding

#### Monetization

| Tier | Price | What's included |
|---|---|---|
| Free | $0 | Basic logging, Health integration, ads |
| Premium Weekly | $5.99/week | All features, no ads |
| Premium Monthly | $14.99–$19.99/month | All features, no ads |
| Premium Annual | $19.99–$39.99/year | All features, no ads, cloud sync |
| Lifetime (promo) | $59.99 | All features forever |
| Premium + Cloud | $99.99 | Ad-free + cloud services |
| Multi-profile | $5.99 one-time | Up to 10 user profiles |

**Paywall placement:** Appears during onboarding (step 4 of 24) — aggressive early gate. Also surfaces when user first taps "PDF Report," "Apple Watch," or "Sync."

**Paywall-locked features specifically:**
- Apple Watch companion
- PDF report printing/sharing
- Cloud sync
- Dropbox/Drive import/export
- Advanced analysis features

#### Review Analysis

**Top praise themes:**
1. Detailed statistics and reporting depth (tags, correlations, period filtering)
2. Bluetooth monitor sync (works reliably with Omron, A&D)
3. Multi-profile family support
4. SmartBP Care clinic-sharing portal (unique in category)
5. Flexibility of tag system

**Top complaint themes:**
1. **Apple Watch behind paywall** — most-mentioned iOS complaint; users expect wrist access as standard
2. **PDF reports behind paywall** — doctors want reports; paying $40/year just for a PDF enrages users
3. **Confusing pricing** — 6+ pricing options ($5.99 to $99.99) create decision paralysis and distrust
4. **Misleading onboarding** — users don't realize the app is just a logger; they expect it to measure BP
5. **Subscription cancellation friction** — users report being charged a full year and unable to cancel mid-term

**UX quality: 4/5 | Design quality: 3/5** (functional, data-dense, but visually dated)  
**Biggest weakness:** The moment users realize Apple Watch + PDF cost $40/year on what should be a $0 utility tool, trust collapses. "No regrets upgrading" in their own marketing copy signals they know conversion is hard.

---

### App 2: My Heart / Blood Pressure

| Field | Detail |
|---|---|
| Platform | Android only (no iOS) |
| Developer | Klimaszewski Szymon |
| Package | com.szyk.myheart |
| Downloads | 14M+ (10M+ Play Store badge) |
| Ratings | 4.3 ★ · 53.7k reviews |
| Last updated | October 6, 2026 |

#### Screens & Flows

**Onboarding:**
- Minimal — no account required, no email collection
- Jumps directly to the reading log after first launch
- Permission: Health Connect access

**Navigation:**
- Dashboard: last reading + category badge + trend arrow
- Log: all readings, sortable
- Charts: 7 / 28 / 90 day views with comparison cards
- Reports: PDF export (limited free, premium for 30-day range)
- Profiles: family member switching
- Settings: units, standards, backup, reminders

#### Features (exhaustive)

**Data entry:**
- Systolic + diastolic + pulse
- Weight
- Blood oxygen (SpO2)
- Timestamp
- Custom notes
- Tags: "morning," "after medication," "after exercise," and custom tags

**Data visualization:**
- Line chart (7, 28, 90-day)
- Comparison cards (pattern identification)
- Scatter plot: systolic vs. diastolic (PREMIUM)
- Time-of-day (AM/PM) analysis (PREMIUM)
- Variability tracking (PREMIUM)
- Category badges per reading
- Statistical summary: avg, min, max

**Standards supported:**
- 2025 AHA/ACC
- ESC/ESH
- Multiple standards selectable (unique: supports 4 standards)

**Export & sharing:**
- PDF report — 7-day free, 30-day PREMIUM
- CSV export
- Google Drive backup (optional, not automatic)
- Spreadsheet import

**Integrations:**
- Google Health Connect
- No Apple Health (Android only)
- No Bluetooth cuff direct sync (Health Connect indirect)
- Voice input

**Smart device:**
- No Wear OS companion (notable gap for Android #1 app)
- No widget

**Other:**
- Offline-first: all data stays on device, no account required
- Multiple profiles (family members)
- Reminders (scheduled)
- Guided breathing exercises (separate section)
- Weather correlation display
- No cloud sync (only manual Google Drive backup)

#### Monetization

| Tier | Price | What's included |
|---|---|---|
| Free | $0 | Basic logging, 7-day PDF, ads |
| Premium | ~$2.99/month or $25 lifetime | Advanced analytics, 30-day export, ad removal |

**Paywall placement:** Does NOT appear during onboarding. Surfaces only when premium features are accessed (scatter plot, variability, 30-day export). Less aggressive than SmartBP.

**Recent controversy:** Users in 2025–2026 reviews report that previously free features were moved behind the paywall without warning — "the latest upgrade ruined the app." This is a significant trust damage event.

#### Review Analysis

**Top praise themes:**
1. No account required — data stays local, privacy-first (hugely valued in health apps)
2. Multiple medical standards (4 standards — unique differentiator)
3. Offline capability with optional Google Drive backup
4. Clean, uncluttered UI vs. Health Tracker
5. Multiple profiles without extra charge

**Top complaint themes:**
1. **Sudden paywalling of previously free features** — "was free for years, now pay $2.99/month" — trust destroyed
2. **No iOS version** — millions of iOS users find this recommended but can't use it
3. **No Wear OS companion** — #1 Android BP app has no smartwatch support in 2026
4. **UI friction on data entry** — tapping a field highlights it but doesn't open keyboard; requires second tap
5. **Privacy inconsistency** — internal health database not encrypted; Google Play data-safety label conflicts with privacy policy

**UX quality: 3/5 | Design quality: 3/5** (clean but dated, functional)  
**Biggest weakness:** Privacy trust is its brand. Any perception of monetization abuse or data inconsistency destroys the core value proposition. No iOS = half the market unreachable.

---

### App 3: Health Tracker: BP Monitor

| Field | Detail |
|---|---|
| Platform | Android only |
| Developer | HealthTracker Apps |
| Package | com.bloodpressure.health.healthtracker |
| Downloads | 10M+ |
| Ratings | 4.4 ★ · 52k reviews |
| Last updated | September 29, 2026 (v1.5.8) |

#### Screens & Flows

This is a "super health app" — BP logging is one module among many. The home screen is a dashboard with multiple health metric cards.

**Navigation (module-based):**
- Blood Pressure log + trends
- Blood Glucose log
- Heart Rate monitor (camera PPG)
- BMI calculator
- Step counter
- Water intake tracker
- Sleep sounds player
- Health articles + wellness tips
- Healthy recipes
- AI doctor chat (generic health Q&A)
- Weather forecast
- Settings + Premium

#### Features (exhaustive)

**Data entry:**
- Systolic + diastolic (manual entry)
- Heart rate via camera PPG (unreliable, not medically validated)
- Blood glucose
- BMI (height + weight)
- Step count (auto)
- Water intake

**Data visualization:**
- Line charts for each health metric
- "Detailed reports" — not clearly described in store listing
- Visual trend cards

**Other health features:**
- HRV + stress assessment via camera PPG
- Sleep sounds (nature sounds, white noise)
- Healthy recipes
- Diet suggestions
- Health articles
- "AI doctor" — generic chatbot, not BP-specific
- Weather: 48hr + 15-day forecast, air quality, UV index

**Integrations:**
- Google Health Connect (stated, not prominently featured)
- No Apple Health (Android only)
- No Bluetooth cuff sync

**Smart device:**
- No Wear OS companion
- No widget

#### Monetization

| Tier | Price | What's included |
|---|---|---|
| Free | $0 | All features with VERY aggressive ads |
| "Turbo" Premium | ~$2.99/month (est.) | Ad removal + unspecified extras |

**Paywall placement:** Ad-based model, not feature-gating. No upfront paywall. But ads are described as "every minute," unskippable, and "misleading game ads."  
**IAP module** reportedly broken — users cannot complete purchase even if they want to upgrade.

#### Review Analysis

**Top praise themes:**
1. Free with no feature gating — everything accessible without paying
2. Breadth of health metrics in one app (BP + glucose + HR + BMI + steps)
3. Large user base (reassuring for new users)
4. Regular updates

**Top complaint themes:**
1. **Extremely aggressive ads** — "an ad pops up almost every minute," "unskippable," "misleading game ads" — #1 complaint by volume
2. **Camera BP measurements mislead users** — PPG heart rate is not validated; app implies BP measurement capability
3. **Bloated / unfocused** — recipes, weather, and health articles distract from the core BP use case
4. **IAP broken** — users who want to pay cannot
5. **Not medically validated** — no clinical guidelines references, no standards selection

**UX quality: 2/5 | Design quality: 2/5** (cluttered, ad-interrupted, generic)  
**Biggest weakness:** Built for ad revenue, not user value. Every real health-app user eventually uninstalls it. Its ratings exist because of volume, not loyalty.

---

## Part 2 — Master Feature List

Tags: **[ALL]** present in all 3 · **[SOME]** present in 1–2 · **[NONE]** absent in all 3 = Hartessa differentiator candidate

### 2.1 Data Entry

| Feature | SmartBP | My Heart | Health Tracker | Tag | Hartessa plan |
|---|---|---|---|---|---|
| Systolic + diastolic + pulse | ✓ | ✓ | ✓ | **[ALL]** | Include |
| Timestamp (auto + manual) | ✓ | ✓ | ✓ | **[ALL]** | Include |
| Custom notes | ✓ | ✓ | — | **[SOME]** | Include |
| Weight tracking | ✓ | ✓ | ✓ | **[ALL]** | Include |
| Blood oxygen (SpO2) | — | ✓ | — | **[SOME]** | Include (v1.1) |
| Irregular heartbeat flag | ✓ (via cuff) | — | — | **[SOME]** | Include as manual checkbox |
| **Arm side (left/right)** | — | — | — | **[NONE] ⭐** | **v1.0 differentiator** |
| **Body position (sitting/standing/lying)** | — | — | — | **[NONE] ⭐** | **v1.0 differentiator** |
| Tags (pre-set) | ✓ | ✓ | — | **[SOME]** | Include |
| Tags (custom) | ✓ | ✓ | — | **[SOME]** | Include |
| BMI auto-calculated | ✓ | ✓ | ✓ | **[ALL]** | Include |
| MAP auto-calculated | ✓ | ✓ | — | **[SOME]** | Include |
| Pulse pressure auto-calculated | ✓ | ✓ | — | **[SOME]** | Include |

### 2.2 Analytics & Charts

| Feature | SmartBP | My Heart | Health Tracker | Tag | Hartessa plan |
|---|---|---|---|---|---|
| Line chart over time | ✓ | ✓ | ✓ | **[ALL]** | Include |
| 7 / 30 / 90-day periods | ✓ | ✓ | ✓ | **[ALL]** | Include |
| Custom date range | ✓ | ✓ | — | **[SOME]** | Include |
| Average / min / max stats | ✓ | ✓ | ✓ | **[ALL]** | Include |
| AM/PM time-of-day split | ✓ | premium | — | **[SOME]** | **Free in Hartessa** |
| Scatter plot (sys vs dia) | ✓ | premium | — | **[SOME]** | Include (free) |
| Variability tracking | ✓ | premium | — | **[SOME]** | Include (free) |
| **Morning surge detection** | — | — | — | **[NONE] ⭐** | **v1.0 differentiator** |
| **Week-over-week auto delta** | — | — | — | **[NONE] ⭐** | **v1.0 differentiator** |
| Tag correlation chart | ✓ | — | — | **[SOME]** | Include (v1.1) |

### 2.3 Color Categories & Standards

| Feature | SmartBP | My Heart | Health Tracker | Tag | Hartessa plan |
|---|---|---|---|---|---|
| ACC/AHA 2017 color coding | ✓ | ✓ | — | **[SOME]** | Include |
| ESC/ESH 2018 standard | ✓ | ✓ | — | **[SOME]** | Include |
| Custom thresholds | ✓ | ✓ | — | **[SOME]** | Include (v1.1) |
| Multiple standards selectable | ✓ | ✓ (4 standards) | — | **[SOME]** | Include |

### 2.4 Export & Sharing

| Feature | SmartBP | My Heart | Health Tracker | Tag | Hartessa plan |
|---|---|---|---|---|---|
| **PDF report — FREE tier** | **PREMIUM** | 7-day only | — | **[NONE] ⭐** | **Key differentiator — always free** |
| PDF report (unlimited) | premium | premium | — | **[SOME]** | Free in Hartessa |
| CSV export | premium | ✓ | — | **[SOME]** | Include (free) |
| Email / share to doctor | ✓ | ✓ | — | **[SOME]** | Include |
| **Clinic / doctor portal** | ✓ (SmartBP Care) | — | — | **[SOME]** | v1.2 roadmap |

### 2.5 Integrations

| Feature | SmartBP | My Heart | Health Tracker | Tag | Hartessa plan |
|---|---|---|---|---|---|
| Apple Health (HealthKit) | ✓ | — (Android) | — | **[SOME]** | Include (iOS) |
| Google Health Connect | ✓ | ✓ | ✓ | **[ALL Android]** | Include (Android) |
| Bluetooth cuff sync | ✓ (Omron, A&D, etc.) | — | — | **[SOME]** | v1.1 |
| Dropbox/Drive export | premium | optional | — | **[SOME]** | Include (free) |
| **Siri voice logging** | ✓ | — | — | **[SOME]** | Include (iOS) |

### 2.6 Smart Device & Widgets

| Feature | SmartBP | My Heart | Health Tracker | Tag | Hartessa plan |
|---|---|---|---|---|---|
| **Apple Watch companion — FREE** | **PREMIUM only** | — | — | **[NONE] ⭐** | **Key differentiator — premium but priced fairly** |
| Apple Watch companion | premium | — | — | **[SOME]** | Premium |
| **Wear OS companion** | — | — | — | **[NONE] ⭐** | Android v1.1 |
| **iOS Home Screen widget** | — | — | — | **[NONE] ⭐** | v1.1 differentiator |
| **Android Home Screen widget** | — | — | — | **[NONE] ⭐** | Android v1.1 |
| Lock Screen complication | — | — | — | **[NONE] ⭐** | v1.1 |

### 2.7 Multi-User & Sync

| Feature | SmartBP | My Heart | Health Tracker | Tag | Hartessa plan |
|---|---|---|---|---|---|
| Multiple profiles (family) | ✓ (up to 10, $5.99) | ✓ | unclear | **[SOME]** | Free (2 profiles) + premium unlimited |
| iCloud / cross-device sync | premium | — | — | **[SOME]** | Premium |
| **Local-first / no-account option** | — (account needed for sync) | ✓ | — | **[SOME]** | **Include — local default** |

### 2.8 Reminders & Medication

| Feature | SmartBP | My Heart | Health Tracker | Tag | Hartessa plan |
|---|---|---|---|---|---|
| Measurement reminders | ✓ | ✓ | ✓ | **[ALL]** | Include (free) |
| Medication reminders | ✓ | — | — | **[SOME]** | Include (free, up to 3) |
| Medication tracking (name/dose/schedule) | ✓ | — | — | **[SOME]** | Premium |
| Medication adherence log | ✓ | — | — | **[SOME]** | Premium |

### 2.9 Privacy & Security

| Feature | SmartBP | My Heart | Health Tracker | Tag | Hartessa plan |
|---|---|---|---|---|---|
| HIPAA compliance | ✓ | — | — | **[SOME]** | Include |
| GDPR compliance | ✓ | — | — | **[SOME]** | Include |
| Face ID / Touch ID lock | ✓ | — | — | **[SOME]** | Include |
| **Encrypted local storage** | — | ❌ (unencrypted) | — | **[NONE] ⭐** | **Include — SwiftData encrypted** |
| No-account-required mode | — | ✓ | — | **[SOME]** | Include |

### 2.10 Monetization Model

| Dimension | SmartBP | My Heart | Health Tracker | Hartessa positioning |
|---|---|---|---|---|
| Free core logging | ✓ | ✓ | ✓ | ✓ free forever |
| Ads in free tier | ✓ (moderate) | ✓ (moderate) | ✓✓✓ (extreme) | **Zero ads** |
| PDF export free | ❌ ($40/yr) | 7-day only | — | **✓ always free** |
| Apple Watch free | ❌ ($40/yr) | N/A | N/A | Premium but ~$2/mo |
| Paywall during onboarding | ✓ (step 4 of 24) | — | — | **Never in onboarding** |
| Pricing clarity | Low (6 tiers) | Medium | Low | **Two tiers only** |

---

### 2.11 Summary — [NONE] Gap List (Hartessa Differentiator Candidates)

| Gap feature | Priority | Notes |
|---|---|---|
| **Arm side + body position entry fields** | v1.0 | Simple UI addition; clinically meaningful; zero competitors have it |
| **PDF export always free** | v1.0 | Direct attack on SmartBP's most-hated paywall gate |
| **Zero ads** | v1.0 | Positioned against Health Tracker; clean experience from day 1 |
| **No paywall during onboarding** | v1.0 | Show value first, ask for money after first week |
| **Morning surge detection** | v1.0 | Automatic flag if morning reading > evening by threshold; clinically meaningful |
| **Week-over-week auto delta** | v1.0 | "Your average is 4 mmHg lower than last week" — motivating |
| **Encrypted local storage** | v1.0 | SwiftData encryption; attack My Heart's known unencrypted DB |
| **Apple Watch in a fair-priced premium** | v1.0 | Not free, but $1.99/month not $40/year |
| **iOS widget (last reading + category badge)** | v1.1 | None of the 3 competitors have this |
| **Wear OS companion** | Android v1 | #1 Android BP app has no Wear OS support in 2026 |
| **Body position + arm side in reading history filter** | v1.1 | "Show me only seated, left-arm readings" |
| **Android widget** | Android v1 | None of the 3 competitors have this |

---

## Part 3 — Agile Build Plan: Hartessa v1.0 MVP

**Platform:** iOS first (SwiftUI, iOS 17+). Android after iOS ships.  
**Stack:** SwiftUI · SwiftData · Firebase Firestore (optional sync) · RevenueCat · HealthKit  
**Team context:** MetaTec single-developer model with agent-assisted code gen.  
**Total estimated duration:** 28 days  
**Positioning anchor:** "The blood pressure logger that respects you — free PDF, no onboarding paywall, no ads."

---

### Sprint 0: Foundations (Days 1–5)

**Goal:** Xcode project, data model, Firebase, RevenueCat skeleton — zero UI, all infrastructure.

#### User Stories

| Story | Given | When | Then |
|---|---|---|---|
| S0-1: Project scaffold | A new empty iOS project | I open Xcode | I see a SwiftUI app targeting iOS 17+ with SwiftData enabled |
| S0-2: Data model | I define a BPReading | I save it | It persists locally via SwiftData with encrypted storage |
| S0-3: Firebase project | Firebase is configured | The app launches | It connects to Firestore project `hartessa` without crashing |
| S0-4: RevenueCat skeleton | RevenueCat SDK is installed | The app launches | It initializes with the Hartessa project API key; entitlement `premium` exists but no paywall is shown |
| S0-5: User profile | I create a user profile | I add a name | It persists locally and is retrievable across app launches |

#### Acceptance Criteria

- [ ] Xcode project `Hearteesa` created; bundle ID `com.metatec.hearteesa`; iOS 17.0 minimum
- [ ] SwiftData model `BPReading`: systolic (Int), diastolic (Int), pulse (Int), timestamp (Date), arm (Arm enum: left/right), position (Position enum: sitting/standing/lying), notes (String?), tags ([String]), weight (Double?), isMorning (Bool computed)
- [ ] SwiftData model `UserProfile`: id, name, color, isDefault
- [ ] Firebase project `hartessa` created; GoogleService-Info.plist in project
- [ ] RevenueCat SDK initialized in App init; entitlement `premium` defined
- [ ] No crashes on cold launch (simulator + device)
- [ ] `git push origin main` with all foundation code

**Estimated days: 5**

---

### Sprint 1: Core Loop (Days 6–14)

**Goal:** User can log a reading, see their history, and view a basic chart. This is the entire free-tier value.

#### User Stories

| Story | Given | When | Then |
|---|---|---|---|
| S1-1: Add reading | I'm on the home screen | I tap the + button | I see a full-screen entry form with sys/dia/pulse/arm/position/notes/tags fields |
| S1-2: Save reading | I've filled in sys/dia/pulse | I tap Save | The reading is saved, the form dismisses, and the home screen shows my new reading at the top |
| S1-3: Category color | I save a reading of 145/95 | The reading appears in history | It shows a red "High Stage 2" badge per ACC/AHA 2017 |
| S1-4: History list | I have 10+ readings | I open the history tab | I see a paginated list sorted by date, each row showing date, sys/dia/pulse, category badge, arm, position |
| S1-5: Line chart | I have 7+ readings | I open the chart tab | I see a line chart with 7/30/90-day period toggles and the systolic/diastolic lines color-coded |
| S1-6: Statistics bar | I view the chart tab | The chart loads | I see a stats bar showing average sys/dia, min, max, and a trend arrow (up/down/stable) |
| S1-7: Apple Health write | I save a reading | — | It is written to HealthKit as a blood pressure correlation sample |
| S1-8: Apple Health read | I've logged readings in another app | I open Hartessa history | HealthKit readings appear in the list with an "imported" badge |
| S1-9: Reminder | I set a daily reminder at 8am | 8am the next day | A notification fires: "Time to log your blood pressure" |
| S1-10: Morning surge | I have a morning and evening reading on the same day | Morning > evening by ≥15 mmHg systolic | A "Morning surge detected" inline card appears on the home screen |

#### Acceptance Criteria

- [ ] Entry form: all fields present; arm and position are segmented controls (not text); one-tap to save
- [ ] Form validates: systolic 60–250, diastolic 40–160, pulse 30–220; shows inline error, never crashes
- [ ] History list: groups by date with section headers; swipe-to-delete with undo
- [ ] Color categories: Normal (green, <120/<80), Elevated (yellow, 120–129/<80), High Stage 1 (orange, 130–139/80–89), High Stage 2 (red, ≥140/≥90), Crisis (deep red, ≥180/≥120) per ACC/AHA 2017
- [ ] Chart renders with SwiftCharts; 7/30/90-day toggles animate; no crashes with 0 or 1 reading
- [ ] Statistics bar updates when period changes
- [ ] Morning surge detection fires correctly (unit-tested)
- [ ] HealthKit permission requested on first reading save; read + write to `HKQuantityTypeIdentifierBloodPressureSystolic` / `Diastolic`
- [ ] Reminders: up to 3 in free tier; UNUserNotificationCenter; persist across app launches

**Estimated days: 9**

---

### Sprint 2: Polish + Paywall (Days 15–22)

**Goal:** Onboarding, ACC/AHA + ESC dual standards, free PDF, RevenueCat paywall (Apple Watch gate), app is App Review-ready.

#### User Stories

| Story | Given | When | Then |
|---|---|---|---|
| S2-1: Onboarding | I open the app for the first time | — | I see 3 onboarding screens: (1) "Blood pressure, tracked beautifully" (2) "Log in 5 seconds" demo (3) "Enable notifications?" then go straight to home — NO paywall screen |
| S2-2: Free PDF | I have 10+ readings | I tap "Export PDF" | A formatted PDF is generated with readings table + chart + stats + average; no paywall — always free |
| S2-3: ESC standard | I go to Settings > BP Standard | I select "ESC/ESH 2018" | All category colors and labels update to the ESC classification throughout the app |
| S2-4: Week delta | I have readings from both this week and last week | Home screen loads | A card shows "This week's average: 4 mmHg lower than last week ↓ Great progress" |
| S2-5: Premium paywall | I tap "Set up Apple Watch" or "Enable iCloud Sync" | — | A clean 2-option paywall appears: Monthly $1.99 / Annual $12.99 / no weekly option; no upsell anywhere else in the app |
| S2-6: Apple Watch companion | I'm a premium subscriber | I open my Apple Watch | The Hartessa watch app shows last reading + category badge; I can log a reading from the watch |
| S2-7: iCloud sync | I'm a premium subscriber with 2 devices | I add a reading on iPhone | It syncs to my iPad within 30 seconds via Firestore |
| S2-8: Face ID lock | I enable Face ID in Settings | I background the app and reopen | Face ID prompt appears; app content hidden until authenticated |
| S2-9: CSV export | I tap "Export CSV" | — | A .csv file is shared to Files/email; free, no paywall |
| S2-10: No ads | I use the free tier for 30 days | — | Zero ad banners, zero interstitials, zero upsell popups appear anywhere except the natural paywall screen |

#### Acceptance Criteria

- [ ] Onboarding: 3 screens max, no paywall screen, notification permission on screen 3
- [ ] PDF: generated with PDFKit; includes: app logo, user name, date range, readings table (date/time/sys/dia/pulse/arm/position/category), line chart image, stats summary; all free
- [ ] CSV: all fields exported; timestamp in ISO 8601; free
- [ ] Paywall: triggered ONLY by Apple Watch setup or iCloud sync setting; two options only (monthly $1.99 + annual $12.99); no weekly option; RevenueCat handles purchase + restore
- [ ] Apple Watch: WatchKit extension; complication (rectangular) showing last sys/dia + category color; log-reading button on watch face opens a number pad for sys, dia, pulse
- [ ] Firestore sync: premium only; reads and writes on `users/{uid}/readings/{readingId}` path; offline-capable (Firestore local cache)
- [ ] ESC/ESH 2018 categories: Normal (≤120/≤80), High Normal (130–139/85–89), Grade 1 (140–159/90–99), Grade 2 (160–179/100–109), Grade 3 (≥180/≥110)
- [ ] Zero ads in entire app — confirmed by UI testing

**Estimated days: 8**

---

### Sprint 3: Release Prep (Days 23–28)

**Goal:** App Store submission. TestFlight, screenshots, metadata, App Review hardening.

#### User Stories

| Story | Given | When | Then |
|---|---|---|---|
| S3-1: Store metadata | The app is ready | I view the App Store listing | Title: "Hearteesa — Blood Pressure Log"; subtitle: "Track, Chart & Share Your BP"; keyword string targets "blood pressure app" (3/5 Apple Ads score, 273k mass) |
| S3-2: Screenshots | — | — | 6 screenshots for 6.9" iPhone: (1) home dashboard, (2) log entry with arm/position, (3) trend chart, (4) PDF report preview, (5) morning surge detection card, (6) Apple Watch companion |
| S3-3: Medical declaration | App Review reads the listing | They check medical device declaration | "Regulated Medical Device: No" — app is a logger only; no diagnostic claims anywhere in UI or metadata |
| S3-4: Privacy policy | App Review checks privacy | — | Privacy policy URL live at hartessa.app/privacy; accurately describes HealthKit use, Firestore sync (premium only), no data sold |
| S3-5: TestFlight | Build is archived | I upload to ASC | Build appears in TestFlight; internal testers (CEO) can install and test |
| S3-6: Onboarding edge case | I delete the app and reinstall | — | Onboarding shows again; no stale data; HealthKit permission re-requested cleanly |
| S3-7: Dark mode | I use the app in dark mode | — | All screens render correctly; no white-on-white or black-on-black elements |
| S3-8: iPad layout | I run the app on iPad | — | UI is not stretched-phone; uses at least 2-column layout on iPad (sidebar navigation) |

#### Acceptance Criteria

- [ ] App archive succeeds via Xcode (Automatic signing, Infinion team)
- [ ] TestFlight build uploaded and live for internal testing
- [ ] App Store listing draft complete: title, subtitle, description, keywords, category (Medical), age rating (4+), medical device = No
- [ ] 6.9" (1320×2868 or 1290×2796) screenshots finalized and uploaded
- [ ] Privacy policy live at real URL
- [ ] App Review notes drafted (describe what the app does, emphasize logger-only, no diagnostic claims)
- [ ] Claims register check: no prohibited language ("diagnose," "treat," "detect hypertension," "measure blood pressure") anywhere in UI strings or App Store copy
- [ ] Dark mode: manual pass all screens
- [ ] iPad: adaptive layout, no layout breaks
- [ ] Crash-free on fresh install → first reading → PDF → paywall trigger → purchase → Apple Watch setup

**Estimated days: 6**

---

## Appendix: Hartessa Free vs. Premium

| Feature | Free | Premium ($1.99/mo · $12.99/yr) |
|---|---|---|
| Unlimited BP readings | ✓ | ✓ |
| Arm side + body position fields | ✓ | ✓ |
| History list (unlimited) | ✓ | ✓ |
| Color categories (ACC/AHA + ESC) | ✓ | ✓ |
| Line chart (7/30/90-day) | ✓ | ✓ |
| Statistics (avg/min/max/trend) | ✓ | ✓ |
| Morning surge detection | ✓ | ✓ |
| Week-over-week delta | ✓ | ✓ |
| PDF export (unlimited) | ✓ | ✓ |
| CSV export | ✓ | ✓ |
| Apple Health sync | ✓ | ✓ |
| Reminders (up to 3) | ✓ | ✓ |
| 1 user profile | ✓ | ✓ |
| Zero ads | ✓ | ✓ |
| No paywall in onboarding | ✓ | ✓ |
| Apple Watch companion | — | ✓ |
| iCloud / Firestore sync | — | ✓ |
| Unlimited profiles | — | ✓ |
| Unlimited reminders | — | ✓ |
| Medication tracking | — | ✓ |
| Advanced analytics (scatter, variability) | — | ✓ |

---

*Document complete. Sources: App Store, Google Play, adapty.io, smartbp.app, klimaszewski.mobi, cravingwise.com, caringvillage.com, breathnow.app, bphealth.app. Data current as of 2026-10-29.*
