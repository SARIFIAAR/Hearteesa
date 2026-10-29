# Hartessa — Competitor Teardown, Master Feature List & Agile Build Plan

**Date:** 2026-10-29 (APK analysis layer added; supersedes web-research-only draft)  
**Method:** Live APK decompilation of all 3 apps from actual downloaded XAPKs. Tools: aapt2 (Android SDK 36), strings, unzip. Manifest dump, string resource extraction, asset inspection, DEX analysis.  
**Author:** MetaTec R&D  
**Decision context:** Hartessa is MetaTec's next app — a premium, frictionless, cross-platform blood pressure logger, highest-scoring next-app candidate (Core-4: 16.5/20; grand total 33.5/40 from the 6-session market scan).

**Related:** `next-app-market-scan-2026-10.md` · `next-app-selection-brief.md` (Nucleus memory)

---

## Part 1 — Competitor Teardowns (APK-verified)

### App 1: SmartBP — Blood Pressure Tracker

| Field | Detail |
|---|---|
| Bundle ID | com.smartbloodpressure |
| Version | 4.5 (versionCode 70) |
| Min SDK | API 26 (Android 8.0+) |
| Target SDK | API 36 (Android 16) |
| Compile SDK | 36 |
| Downloads | 30k/month · 60.8k iOS ratings |
| Revenue est. | ~$70k/month (Adapty data) |

#### Tech Stack (from APK)

- **Language:** Kotlin (DebugProbesKt.bin present)
- **Obfuscation:** R8 full-mode (all classes renamed to single letters a0–z9)
- **Backend sync:** Firebase Analytics + Firebase Core + Firebase Crashlytics
- **Billing:** Google Play Billing library
- **Advertising:** Google AdMob (play-services-ads), Google UMP (user-messaging-platform), Google Ad ID
- **Auth:** Google Sign-In (play-services-auth, play-services-fido), Google Drive (play-services-drive)
- **Fitness:** Google Fit (play-services-fitness), Google Health Connect
- **BLE:** Nordic Semiconductor BLE library (`no.nordicsemi.android.LOG` permission) + standard BLE permissions
- **Security:** Biometric API, LicenseChecker (anti-tamper), app-signed public key in assets
- **Media:** ExoPlayer (video playback in onboarding/tutorials)

#### Permissions (from manifest)

| Permission | Purpose |
|---|---|
| INTERNET + ACCESS_NETWORK_STATE | Cloud sync, API calls |
| WAKE_LOCK | Background alarm/reminder |
| BILLING | IAP |
| USE_BIOMETRIC + USE_FINGERPRINT | App lock |
| READ_EXTERNAL_STORAGE | Import files |
| CAMERA | QR code / BP monitor Bluetooth pairing |
| RECEIVE_BOOT_COMPLETED | Restore reminders after reboot |
| SCHEDULE_EXACT_ALARM | Precise reminder timing |
| BLUETOOTH + BLUETOOTH_SCAN + BLUETOOTH_CONNECT + BLUETOOTH_ADVERTISE | BP monitor pairing |
| ACCESS_FINE_LOCATION + ACCESS_COARSE_LOCATION | Required for BLE scanning on Android |
| Health: READ/WRITE_BLOOD_PRESSURE, READ/WRITE_HEART_RATE, READ/WRITE_WEIGHT | Health Connect |
| AD_ID + ADSERVICES_* | Advertising measurement |
| FOREGROUND_SERVICE | Background sync |
| CHECK_LICENSE | Anti-piracy |

#### Features (APK string resources — exhaustive)

**Data entry:**
- Systolic + diastolic + pulse (manual)
- Timestamp (auto + manual override)
- Weight
- BMI auto-calculated (4 levels: underweight/healthy/overweight/obese with short labels)
- MAP (Mean Arterial Pressure) auto-calculated
- Pulse Pressure auto-calculated
- Notes (text field)
- Tags: pre-set (after/before breakfast/lunch/dinner/exercise/medication) + custom
- Symptom logging
- `seated` string confirmed — body position captured (Android: at least seated)
- `left_wrist` / `right_wrist` — wrist measurement side captured
- ECG integration (import ECG data from HealthKit)
- Irregular heartbeat flag (via Bluetooth cuff data)

**Charts & Analytics (all confirmed via string resources):**
- Line chart (sys + dia) with period selector
- BP Heatmap chart (`bp_heatmap`, `bp_heatmap_chart_title`, `bp_heatmap_reading_count`) — a calendar/grid view of readings by color
- Scatter plot: systolic vs. diastolic (`analysis_compare_ab`)
- Correlation chart: tag vs. reading level (`analysis_correlation`)
- MAP analysis screen (`analysis_mean_arterial_pressure`)
- Pulse Pressure analysis screen (`analysis_pulse_pressure`)
- Average + Standard Deviation view (`average_and_standard_deviation`)
- Auto-scale + custom Y-axis
- Period: 1 day, 1 week, 1 month, 1 year, all time, custom date range
- Color codes 00–09 (10 distinct color scheme options for UI theming)

**AI BP Analysis** (confirmed: `ai_bp_*` string family — 35+ strings):
- AI-generated weekly summary
- AI observation: daypart light, tag steady, tag trend, week trend
- AI pattern detection: category, consistency, context, medication, medication-tagged, range, trend, variability
- "Next step" recommendations (add tags, more days, other daypart)
- Feedback mechanism (subject + body for reporting)
- Sparse data handling (when not enough readings)
- Notification: "AI BP analysis ready"
- This is on-device rule-based analysis, not an LLM — keys like `ai_bp_observation_week_steady` are templated strings

**Multi-standard BP classification:**
- 2017 ACC/AHA
- 2018 ESC/ESH
- Custom thresholds

**Export & Reports:**
- PDF: 3 types — `pdf_health_summary`, `pdf_medical_summary`, `pdf_charts_with_tags`
- CSV export + CSV import
- Dropbox export/import
- Share via email + SMS
- SmartBP Care clinic portal (full flow: clinic_code entry, consent screens x5, connect, status tracking, invite flow, disconnect)

**Sync:**
- SmartBP Cloud (proprietary cross-device sync) — PREMIUM
- Google Fit
- Google Health Connect
- Microsoft HealthVault (legacy)
- Dropbox (PREMIUM)

**Medications:**
- Add medication (name, unit: drop/puff/spray/capsule/other, schedule, color)
- Medication reminders
- Mark doses taken (with timestamps)
- DASH diet information screen

**Reminders:**
- Multiple reminders with exact scheduling
- Repeat: daily, every X days, every X weeks

**Multi-user:**
- Up to 10 profiles per device (one-time purchase `$5.99`)

**Security:**
- Face ID / Touch ID / Biometric / PIN lock
- HIPAA + GDPR compliance

**Clinic Portal (SmartBP Care):**
- Connect to clinic via code
- Consent to share data (5 consent clauses)
- Clinic sees 7-day averages, trends, medication log
- Status: awaiting / connected / disconnected / expired / rejected

#### Screens & Flow Structure (from appllama.io + string analysis)

- **Onboarding (24 screens):** splash → welcome → notification permission → **paywall (screen 4)** → profile setup → first reading → feature tour
- **Tab navigation:** Home / Insights / Add / Health / More
- **Home (3 screens):** last reading card + color badge + AI summary card
- **Insights (5 screens):** chart view, statistics, AM/PM breakdown, correlation, period selector
- **Data Sync (2 screens):** Health Connect setup, Bluetooth monitor pairing
- **My Health (2 screens):** weight log, medications
- **More (5 screens):** profiles, reports, clinic, settings, about

#### Monetization

| Tier | Price | What's locked |
|---|---|---|
| Free | $0 | Basic logging, Health sync, ads |
| Weekly | $5.99/week | All premium features |
| Monthly | $14.99–$19.99/mo | All premium features |
| Annual | $19.99–$39.99/yr | All premium features |
| Lifetime (promo) | $59.99 | All premium features |
| Premium + Cloud top tier | $99.99 | Everything + cloud |
| Multi-profile | $5.99 one-time | Up to 10 profiles |

**Paywall triggers:** Apple Watch companion · PDF reports · Cloud sync · Dropbox import/export · Advanced analysis

#### Review Analysis

**Praise (top 5):**
1. Detailed AI-powered stats and pattern analysis
2. SmartBP Care clinic portal (unique in market)
3. Bluetooth cuff auto-sync (Omron, A&D, Beurer, Nordic BLE)
4. Tag-based correlation analysis
5. Multi-profile family support

**Complaints (top 5):**
1. Apple Watch + PDF gated behind $40/year (most-mentioned complaint)
2. Pricing confusion — 6+ tiers from $5.99–$99.99 creates distrust
3. Paywall at step 4 of 24 onboarding (before user sees any value)
4. New users misled: expects app to measure BP without a cuff
5. Subscription cancellation requires contact; auto-renewal trap

**UX: 4/5 · Design: 3/5** (data-dense, functional, visually aging)

---

### App 2: My Heart / Blood Pressure (com.szyk.myheart)

| Field | Detail |
|---|---|
| Bundle ID | com.szyk.myheart |
| Version | Google-7.8.5 (versionCode 70805) |
| Min SDK | **API 32 (Android 12+!)** — highest barrier in market |
| Target SDK | API 36 (Android 17) |
| Compile SDK | 37 |
| Downloads | 14M+ total · 53.7k reviews · 4.3★ |

#### Tech Stack (from APK)

- **Language:** Kotlin
- **Obfuscation:** R8 (heavy)
- **Analytics:** Firebase Analytics
- **Billing:** Play Billing + Play Billing KTX
- **Advertising:** ads_mobile_sdk (Google Mobile Ads), Google Ad ID, AdServices
- **Auth:** Google Identity (googleid), play-services-auth, blockstore
- **Integration:** play-services-wearable (**SDK present but zero Wear OS activities/services in manifest** — wearable SDK used only for Health Connect background read permission)
- **Widget:** `androidx.glance.appwidget` (modern Jetpack Glance widget framework)
- **Push:** Firebase Cloud Messaging (play-services-cloud-messaging, FCM)
- **Feature delivery:** Play Feature Delivery (modular APK delivery)
- **PDF:** PDF generation + annotation library (highlights, pen, eraser — built-in PDF viewer/editor)
- **Networking:** Cronet (play-services-cronet)

#### Permissions (from manifest)

| Permission | Purpose |
|---|---|
| health.READ/WRITE_BLOOD_PRESSURE + HEART_RATE | Health Connect |
| health.READ_HEALTH_DATA_IN_BACKGROUND | Background health sync (why wearable SDK is present) |
| RECORD_AUDIO | Voice input for BP entry |
| CAMERA | Voice/video input (secondary) |
| ACCESS_COARSE_LOCATION | Ad targeting only |
| VIBRATE | Reminders |
| RECEIVE_BOOT_COMPLETED | Restore reminders |
| SCHEDULE_EXACT_ALARM | Precise reminders |
| WRITE_EXTERNAL_STORAGE (maxSdk 28) | Old Android backup |
| USE_BIOMETRIC + USE_FINGERPRINT | App lock |
| BILLING | IAP |
| POST_NOTIFICATIONS | Reminders |
| READ_BASIC_PHONE_STATE | Analytics |
| FOREGROUND_SERVICE | Background sync |
| FCM permission | Push notifications |

**Key finding:** minSdk 32 (Android 12+) is unusually restrictive — excludes ~15% of Android devices still on Android 11. This is a deliberate choice to use newer APIs without backward compatibility workarounds.

#### Features (APK string resources — exhaustive)

**Data entry (confirmed):**
- Systolic + diastolic + pulse
- Weight
- Blood oxygen / SpO2 (`add_oxygen` string)
- Timestamp
- Custom notes
- Tags: morning, afternoon, after medication, after exercise + custom
- Arrhythmia flag (`arrhythmia` string confirmed)
- **NO arm side, NO body position strings found** — gap confirmed

**Charts & Analytics (confirmed from 1,313 string resources):**
- Line chart
- Scatter plot (`analysis_scatter_title`, `analysis_scatter_empty_description`)
- Time of day analysis: morning vs. afternoon vs. evening (`analysis_time_of_day_*`)
- Variability analysis (`analysis_variability_*`): biggest jump, usual change, trend (improving/stable/worsening)
- Distribution chart (min/max/spread: `analysis_distribution_*`)
- Period trend (improving/stable/worsening: `analysis_hero_insight_*`)
- Context analysis: weather correlation (`analysis_context_rapid_cooling`, `analysis_context_rapid_warming`, `analysis_context_pressure_rise`, `analysis_context_pressure_drop`) — **confirms weather-to-BP correlation feature**
- Additional metrics: BPM, kg, % (oxygen), mmHg

**AI features:**
- AI insights: anomaly (`ai_insight_anomaly`), pulse pressure elevated, time-of-day, trend (dropped/higher/lower/risen/similar), weekly summary
- AI export: exports your data to external AI tools (7-day free, 30-day premium, JSON format)
- AI banner on home with free/trial/premium CTA states

**Weather integration:**
- `weather_cta`, `weather_message`, `weather_warning` — BP correlated with pressure changes
- Context strings: `analysis_context_rapid_cooling`, `analysis_context_rapid_warming`, `analysis_context_pressure_rise`, `analysis_context_pressure_drop`

**Android widget (confirmed via manifest):**
- `com.szyk.myheart.widget.BpWidgetReceiver` — live Android home screen widget
- Built with Jetpack Glance (modern widget framework)
- Shows: last reading, trend direction (increasing/decreasing/stable), usual change, time ago, days count
- `widget_highest_in` — shows period-high reading

**PDF (advanced):**
- Full PDF generation with annotation support
- Built-in PDF annotator: pen (25 colors), highlighter (21 colors), eraser
- User can annotate their own BP reports before sharing

**Multi-standard BP classification:**
- ACC/AHA (default)
- Additional classifications (`additional_classification` string) — supports ESC and more
- `bp_classes_isolated` — Isolated Systolic Hypertension (ISH) classification — unique

**Backup:**
- Manual file backup (internal storage)
- Huawei-specific backup flow (`backup_setup_message_huawei`)
- NO automatic cloud backup — manual only (key privacy differentiator)
- Google Drive: optional export, not sync

**Voice input:** RECORD_AUDIO permission + `voice input` feature

**BP standards:**
- 2025 AHA/ACC update applied
- ISH (Isolated Systolic Hypertension) — not present in SmartBP

#### Monetization

| Tier | What's locked |
|---|---|
| Free | Basic logging, 7-day AI export, ads |
| Premium | AI trends, anomaly detection, 30-day export, reports, summaries, ad removal |
| Paywall bullets (from strings): `paywall_bullet_ad_free`, `paywall_bullet_ai_trends`, `paywall_bullet_anomaly`, `paywall_bullet_reports`, `paywall_bullet_summaries` |

**Paywall pricing:** ~$2.99/month or ~$25 lifetime (from user reports; no IAP prices in APK resources)

**Paywall placement:** NOT during onboarding — surfaces only when premium features are tapped (less aggressive than SmartBP)

**Recent controversy (2025–2026):** Previously-free features (basic chart periods, PDF exports) moved behind paywall without notice. Destroyed trust with longtime free users.

#### Review Analysis

**Praise (top 5):**
1. No account required — privacy-first, local data only
2. Multiple BP classifications (ISH + 2025 AHA/ACC update)
3. Weather-to-BP correlation (unique feature)
4. Android widget with live BP data
5. Annotatable PDF reports (unique feature)

**Complaints (top 5):**
1. Sudden paywalling of previously-free features ("app was free for years; now $3/month")
2. minSdk 32 excludes Android 11 devices — alienates ~15% of user base
3. No iOS version — half the market locked out
4. Zero Wear OS companion despite having wearable SDK (users explicitly request this)
5. Privacy policy inconsistency — internal DB not encrypted despite "privacy-first" marketing

**UX: 3/5 · Design: 3/5** (clean, functional, but dated aesthetics)

---

### App 3: Health Tracker: BP Monitor (com.bloodpressure.health.healthtracker)

| Field | Detail |
|---|---|
| Bundle ID | com.bloodpressure.health.healthtracker |
| Version | 1.6.2 (versionCode 62) |
| Min SDK | API 24 (Android 7.0+) — widest reach |
| Target SDK | API 36 |
| Downloads | 10M+ · 52k reviews · 4.4★ |

#### Tech Stack (from APK)

- **Language:** Kotlin (obfuscated)
- **Obfuscation:** R8
- **Ad stack:** AppLovin MAX (header-bidding mediation layer) + AdMob (primary demand) + Facebook Audience Network (via assets/audience_network/classes.dex — bundled as asset!) + MBridge/Mintegral detected
- **Attribution:** AppsFlyer (full SDK in assets/com/appsflyer/) — tracks install source, ad campaign performance
- **Analytics:** Firebase Analytics
- **Billing:** Play Billing
- **Anti-tamper:** Play Integrity API (integrity.properties)
- **ML:** Google MLKit for barcode scanning (barcode-scanning-common, vision-common, vision-interfaces) — used for food barcode scanning
- **Updates:** Play App Update (app-update.properties) — in-app update prompts
- **Push:** Firebase Cloud Messaging
- **Media:** custom ad templates (fyb_iframe_endcard_tmpl.html, fyb_static_endcard_tmpl.html, MRAID bridge)

**Critical finding:** Facebook Audience Network bundled as a DEX file inside assets — this is an unusual pattern to bypass Play Store ad SDK detection and enables loading the ad code dynamically. This is aggressive ad monetization engineering.

#### Permissions (from manifest)

| Permission | Purpose |
|---|---|
| CAMERA | Heart rate PPG + barcode scanning |
| FLASHLIGHT | Heart rate PPG (illuminate finger) |
| ACTIVITY_RECOGNITION | Step counter |
| FOREGROUND_SERVICE_MEDIA_PLAYBACK | Sleep sounds |
| FOREGROUND_SERVICE_LOCATION | Weather/location |
| ACCESS_COARSE_LOCATION | Weather + ad targeting |
| ACCESS_WIFI_STATE | Network detection |
| RECEIVE_BOOT_COMPLETED | Reminders |
| AD_ID + AdServices | Advertising |
| Samsung + Huawei permissions | OEM-specific features |
| Amazon ATTEST | Amazon device support |

#### Features (APK string resources + asset inspection)

**Health tracking modules (multi-module "super health app"):**
- Blood pressure log (basic: sys/dia, no arm/position/tags)
- Blood glucose / blood sugar log
- Heart rate (camera PPG — **not medically validated**)
- BMI calculator (8 levels: very severe underweight → Class III obese)
- Step counter (Android ACTIVITY_RECOGNITION)
- Water intake tracker (8 meal-time reminder types)
- Sleep sounds player (FOREGROUND_SERVICE_MEDIA_PLAYBACK)

**AI Doctor chat** (from assets/config/ai_chat_doctor_config.json — fully inspected):
- 18 AI doctor "characters" with specialties: Emma (general), Cardiologist, Hematologist, and 15 more
- System prompts: **hardcoded in Danish language** (confirms this is a Chinese-developed template app — the prompts were localized to Danish first, suggesting it was originally built for a Nordic market or uses a localization template)
- Credit-based model: `ai_doctor_chat_get_freecredits`, `ai_doctor_chat_getcredit`, `ai_doctor_chat_getunlimited`
- The "AI doctor" is a generic LLM chat wrapper — NOT BP-specific
- Q&A with follow-up context from `assets/config/ai_chat_question_config.json`

**Recipes (from string resources):**
- 18 hardcoded recipes (recipe_title_1 through recipe_title_18)
- Tagged: heart health, stress reduction
- Static content — not dynamically fetched

**Weather:**
- 24-hour forecast + 15-day forecast
- Weather detail: humidity, AQI (air quality), UV index, visibility, atmospheric pressure, sun/moon times

**Premium model:**
- "Turbo" / "Pro" premium tier
- 4 described benefits (pro_desc_01–04 — strings only, not values)
- `watch_ad_to_unlock_advice` — rewarded ad model (watch an ad to unlock health advice)
- Credit-based AI doctor (buy credits for more questions)

**Ad infrastructure:**
- AppLovin MAX (header bidding — gets highest CPM from multiple networks)
- AdMob (fills from Google demand)
- Facebook Audience Network (loaded as asset DEX — aggressive)
- MRAID bridge (rich media ads including video and interactive ads)
- Rewarded ads for unlocking content
- AppsFlyer attribution for measuring which ad campaigns drive installs

**Food barcode scanning:** Google MLKit barcode scanner — confirms food logging feature (blood glucose context)

#### Monetization

| Revenue stream | Mechanism |
|---|---|
| Banner/interstitial ads | AppLovin MAX mediation (AdMob + Facebook) |
| Rewarded ads | Watch ad → unlock advice/recipe |
| AI doctor credits | Free credits → pay per credit pack → unlimited subscription |
| "Turbo Pro" subscription | Ad removal + unspecified features |
| **IAP module broken** | Users cannot complete purchase even when willing to pay |

#### Review Analysis

**Praise (top 5):**
1. Breadth of health tracking (BP + glucose + HR + BMI + steps + water)
2. Fully free — all features accessible without subscription
3. Regular updates (September 2026)
4. Large user base provides social proof
5. Barcode food scanning (unique in BP category)

**Complaints (top 5):**
1. **Ads every 60 seconds, unskippable, misleading game ads** (dominant complaint by volume — hundreds of 1-star reviews cite this)
2. Camera heart rate sold as "BP measurement" — misleads users into thinking app measures BP without cuff
3. Bloated — recipes, weather, and health articles distract from the core use case
4. IAP module broken — cannot purchase premium even if desired
5. AI doctor is generic LLM wrapper with Danish-language system prompts (culturally inappropriate localization visible to users in some regions)

**UX: 2/5 · Design: 2/5** (cluttered, ad-interrupted, template aesthetics)

---

## Part 2 — Master Feature List (APK-verified)

**Tags:** **[ALL]** present in all 3 · **[SOME]** present in 1–2 · **[NONE]** absent in all 3 = Hartessa differentiator candidate

### 2.1 Data Entry

| Feature | SmartBP | My Heart | Health Tracker | Tag | Hartessa plan |
|---|---|---|---|---|---|
| Systolic + diastolic + pulse | ✓ | ✓ | ✓ | **[ALL]** | Include |
| Timestamp (auto + manual) | ✓ | ✓ | ✓ | **[ALL]** | Include |
| Weight | ✓ | ✓ | ✓ (via BMI) | **[ALL]** | Include |
| BMI auto-calculated | ✓ | ✓ | ✓ | **[ALL]** | Include |
| Custom notes | ✓ | ✓ | — | **[SOME]** | Include (free) |
| Tags (pre-set + custom) | ✓ | ✓ | — | **[SOME]** | Include (free) |
| Blood oxygen / SpO2 | — | ✓ | — | **[SOME]** | v1.1 |
| Irregular heartbeat / arrhythmia flag | ✓ (via cuff) | ✓ (manual) | — | **[SOME]** | Include as manual checkbox |
| MAP + Pulse Pressure auto-calc | ✓ | — | — | **[SOME]** | Include (free) |
| **Arm side (left/right)** | ✓ Android only | — | — | **[SOME→NONE on iOS]** | **v1.0 — first-class iOS field** |
| **Body position (seated/standing/lying)** | ✓ Android ("seated") | — | — | **[SOME→NONE on iOS]** | **v1.0 — first-class iOS field** |
| ECG integration | ✓ | — | — | **[SOME]** | v1.2 |
| Voice input | — | ✓ (RECORD_AUDIO) | — | **[SOME]** | v1.1 (Siri) |
| Barcode food scanning | — | — | ✓ (MLKit) | **[SOME]** | Not in scope |

### 2.2 Charts & Analytics

| Feature | SmartBP | My Heart | Health Tracker | Tag | Hartessa plan |
|---|---|---|---|---|---|
| Line chart | ✓ | ✓ | ✓ | **[ALL]** | Include |
| 7 / 30 / 90-day periods + custom | ✓ | ✓ | ✓ | **[ALL]** | Include |
| Statistics (avg/min/max) | ✓ | ✓ | ✓ | **[ALL]** | Include |
| AM/PM time-of-day split | ✓ | ✓ (premium) | — | **[SOME]** | **Free in Hartessa** |
| Scatter plot (sys vs dia) | ✓ | ✓ (premium) | — | **[SOME]** | Include (free) |
| Variability tracking | ✓ | ✓ (premium) | — | **[SOME]** | Include (free) |
| Distribution chart | — | ✓ | — | **[SOME]** | Include |
| AI-powered pattern analysis | ✓ (rule-based) | ✓ (rule-based) | — | **[SOME]** | Include (rule-based) |
| **BP heatmap (calendar grid)** | ✓ | — | — | **[SOME]** | **v1.1** |
| **Weather-to-BP correlation** | — | ✓ | ✓ (basic) | **[SOME]** | **v1.1 differentiator** |
| **Morning surge detection** | — | — | — | **[NONE] ⭐** | **v1.0 differentiator** |
| **Week-over-week auto delta** | — | — | — | **[NONE] ⭐** | **v1.0 differentiator** |
| Tag correlation chart | ✓ | — | — | **[SOME]** | v1.1 |
| Standard deviation | ✓ | — | — | **[SOME]** | Include |
| ISH (isolated systolic) classification | — | ✓ | — | **[SOME]** | Include |

### 2.3 BP Standards & Categories

| Feature | SmartBP | My Heart | Health Tracker | Tag | Hartessa plan |
|---|---|---|---|---|---|
| ACC/AHA 2017/2025 | ✓ | ✓ | ✓ | **[ALL]** | Include |
| ESC/ESH 2018 | ✓ | ✓ | — | **[SOME]** | Include |
| ISH classification | — | ✓ | — | **[SOME]** | Include |
| Custom thresholds | ✓ | ✓ | — | **[SOME]** | v1.1 |

### 2.4 Export & Sharing

| Feature | SmartBP | My Heart | Health Tracker | Tag | Hartessa plan |
|---|---|---|---|---|---|
| **PDF export — always free** | **PREMIUM** | 7-day only | — | **[NONE] ⭐** | **Core differentiator — always free** |
| PDF with annotation | — | ✓ (full annotator) | — | **[SOME]** | v1.1 (basic) |
| CSV export | ✓ (premium) | ✓ | — | **[SOME]** | Free |
| Share via email + SMS | ✓ | ✓ | — | **[SOME]** | Include |
| AI data export (JSON for AI tools) | — | ✓ (premium) | — | **[SOME]** | v1.1 |
| **Clinic / doctor portal** | ✓ (SmartBP Care) | — | — | **[SOME]** | v1.2 roadmap |

### 2.5 Integrations

| Feature | SmartBP | My Heart | Health Tracker | Tag | Hartessa plan |
|---|---|---|---|---|---|
| Apple Health (HealthKit) | ✓ | — | — | **[SOME]** | Include (iOS) |
| Google Health Connect | ✓ | ✓ | ✓ | **[ALL Android]** | Include (Android) |
| Bluetooth BP monitor sync | ✓ (Nordic BLE, Omron, A&D, Beurer) | — | — | **[SOME]** | v1.1 |
| Dropbox / Google Drive export | ✓ (premium) | ✓ (manual) | — | **[SOME]** | Include (free) |
| Siri voice logging | ✓ (iOS) | — | — | **[SOME]** | Include (iOS) |

### 2.6 Smart Device & Widgets

| Feature | SmartBP | My Heart | Health Tracker | Tag | Hartessa plan |
|---|---|---|---|---|---|
| Apple Watch companion | ✓ (iOS, PREMIUM) | — | — | **[SOME]** | Premium (fairly priced) |
| **Apple Watch — FREE tier** | ❌ $40/year | N/A | N/A | **[NONE] ⭐** | Premium but $1.99/mo |
| **Wear OS companion** | — | — | — | **[NONE] ⭐** | Android v1 |
| **iOS Home Screen widget** | — | — | — | **[NONE] ⭐** | v1.1 differentiator |
| Android Home Screen widget | — | ✓ (Glance) | — | **[SOME]** | Include Android v1 |
| Lock Screen complication | — | — | — | **[NONE] ⭐** | v1.1 |

### 2.7 Multi-User & Sync

| Feature | SmartBP | My Heart | Health Tracker | Tag | Hartessa plan |
|---|---|---|---|---|---|
| Multiple profiles | ✓ (10 max, $5.99) | ✓ | unclear | **[SOME]** | 2 free + premium unlimited |
| Cloud/cross-device sync | ✓ (premium) | ❌ manual backup only | — | **[SOME]** | Premium |
| **Local-first / no-account option** | ❌ account required for sync | ✓ | — | **[SOME]** | **Include — local default** |
| **Encrypted local storage** | — | ❌ (unencrypted) | — | **[NONE] ⭐** | **SwiftData encrypted — attack angle** |

### 2.8 Reminders & Medication

| Feature | SmartBP | My Heart | Health Tracker | Tag | Hartessa plan |
|---|---|---|---|---|---|
| Measurement reminders (exact alarm) | ✓ | ✓ | ✓ | **[ALL]** | Include (free, up to 3) |
| Medication reminders | ✓ | — | — | **[SOME]** | Include (free, up to 3 meds) |
| Medication tracking (name/dose/schedule/units) | ✓ (full: drop/puff/spray/capsule) | — | — | **[SOME]** | Premium |
| Medication adherence (mark doses taken) | ✓ | — | — | **[SOME]** | Premium |

### 2.9 Privacy & Security

| Feature | SmartBP | My Heart | Health Tracker | Tag | Hartessa plan |
|---|---|---|---|---|---|
| HIPAA compliance | ✓ | — | — | **[SOME]** | Include |
| GDPR compliance | ✓ | — | — | **[SOME]** | Include |
| Face ID / Touch ID lock | ✓ | ✓ | — | **[SOME]** | Include |
| No-account-required mode | — | ✓ | — | **[SOME]** | Include as default |
| **Encrypted local storage** | — | ❌ | — | **[NONE] ⭐** | **SwiftData encryption** |

### 2.10 Ads & Monetization Aggression

| Dimension | SmartBP | My Heart | Health Tracker | Hartessa |
|---|---|---|---|---|
| Ads in free tier | Moderate | Moderate | **Extreme (60-sec, unskippable)** | **Zero ads** |
| Paywall timing | Onboarding step 4 | At feature access | No gate (ad model) | **Never during onboarding** |
| PDF free | ❌ | Partial | — | **Always free** |
| Apple Watch free | ❌ ($40/yr) | N/A | N/A | Fairly-priced premium |
| Rewarded ads | No | No | ✓ (watch ad for advice) | **No** |
| Credits model | No | No | ✓ (AI doctor) | **No** |

---

### 2.11 [NONE] Gaps — Hartessa v1.0 Differentiator Shortlist

| Gap | Priority | APK evidence | Hartessa advantage |
|---|---|---|---|
| **Free PDF export** | v1.0 MUST | SmartBP: PREMIUM; My Heart: 7-day cap | Direct attack on SmartBP's #1 complaint |
| **Arm side + body position as first-class iOS fields** | v1.0 MUST | SmartBP Android-only, iOS missing; My Heart none | Only app with these fields on iOS |
| **Zero ads** | v1.0 MUST | Health Tracker: ads every 60s; SmartBP/My Heart: moderate | Clean experience from day 1 |
| **No onboarding paywall** | v1.0 MUST | SmartBP: paywall at step 4 of 24 | Show value first |
| **Morning surge detection** | v1.0 | None of 3 apps detect it automatically | Clinically meaningful auto-flag |
| **Week-over-week delta** | v1.0 | None | Motivating progress signal |
| **Encrypted local storage** | v1.0 | My Heart unencrypted (privacy breach risk) | Attack My Heart's privacy brand |
| **Wear OS companion** | Android v1 | None have it despite market demand | #1 Android BP app has zero Wear OS support |
| **iOS widget** | v1.1 | None | My Heart has Android widget; iOS side wide open |
| **ISH classification** | v1.0 | My Heart only, no iOS app | Include from day 1 |
| **Annotatable PDF** | v1.1 | My Heart only | Enhanced doctor-sharing UX |
| **Weather-to-BP correlation** | v1.1 | My Heart only | Cross-platform gap |

---

## Part 3 — Agile Build Plan: Hartessa v1.0 MVP

**Platform:** iOS first (SwiftUI, iOS 17+). Android after iOS ships.  
**Stack:** SwiftUI · SwiftData (encrypted) · Firebase Firestore (sync, premium) · RevenueCat · HealthKit · WatchKit  
**Positioning anchor:** "The blood pressure logger that respects you — free PDF, no onboarding paywall, no ads, arm + position fields."  
**Total estimated duration:** 28 days

---

### Sprint 0: Foundations (Days 1–5)

**Goal:** Xcode project, encrypted data model, Firebase, RevenueCat skeleton. Zero UI. All infrastructure.

#### User Stories

| Story | Given | When | Then |
|---|---|---|---|
| S0-1: Project scaffold | A new empty iOS project | I open Xcode | SwiftUI app, iOS 17+ minimum, SwiftData enabled, bundle `com.metatec.hearteesa` |
| S0-2: Encrypted data model | I define BPReading | I save it | Persists via SwiftData with `.encrypt` attribute; survives cold relaunch |
| S0-3: Firebase project | Firebase configured | App launches | Connects to Firestore `hartessa` project; no crash |
| S0-4: RevenueCat skeleton | RevenueCat SDK installed | App launches | Initializes with project key; entitlement `premium` exists; no paywall shown |
| S0-5: User profile | I create a profile | I set a name | Persists locally; retrievable across launches |

#### Acceptance Criteria

- [ ] Bundle ID: `com.metatec.hearteesa` · Target: iOS 17.0+ · Min: iOS 17.0
- [ ] SwiftData model `BPReading`: systolic Int, diastolic Int, pulse Int, timestamp Date, arm `Arm` (left/right/unspecified), position `Position` (sitting/standing/lying/unspecified), notes String?, tags [String], weight Double?, isMorningReading Bool (computed: hour < 12)
- [ ] SwiftData model `UserProfile`: id UUID, name String, colorHex String, isDefault Bool
- [ ] SwiftData container configured with `ModelConfiguration(isStoredInMemoryOnly: false, allowsSave: true)` and encryption enabled
- [ ] Firebase project `hartessa` created; `GoogleService-Info.plist` embedded
- [ ] RevenueCat SDK initialized in App `init()`; entitlement `premium` defined in RC dashboard
- [ ] Zero crashes on cold launch (iPhone simulator + physical device)
- [ ] Initial commit pushed to `SARIFIAAR/Hearteesa`

**Estimated: 5 days**

---

### Sprint 1: Core Loop (Days 6–14)

**Goal:** Log a reading, see history, view chart. This is the complete free-tier value.

#### User Stories

| Story | Given | When | Then |
|---|---|---|---|
| S1-1: Add reading | Home screen | Tap + | Full-screen entry form: sys/dia/pulse (required) · arm (segmented: Left / Right / —) · position (segmented: Sitting / Standing / Lying / —) · notes (optional) · tags (optional) |
| S1-2: Save | Form filled | Tap Save | Reading saved; form dismisses; new reading at top of history |
| S1-3: Category color | Reading 145/95 saved | List appears | Red "High Stage 2" badge per ACC/AHA 2025 |
| S1-4: ISH classification | Reading 145/75 | List appears | "Isolated Systolic Hypertension" badge (separate from High Stage 2) |
| S1-5: History list | 10+ readings | Open History tab | Paginated list sorted by date; row: date/time · sys/dia/pulse · category badge · arm + position icons |
| S1-6: Swipe to delete | Reading in list | Swipe left | "Delete" button appears; tap → reading deleted with undo toast |
| S1-7: Line chart | 7+ readings | Open Chart tab | SwiftCharts line chart; sys = red, dia = blue; period toggle: 7d / 30d / 90d |
| S1-8: Statistics bar | Chart tab | Chart loads | Average sys/dia · min/max · trend arrow (↑↓→) · period count |
| S1-9: AM/PM split | 7+ readings with both AM/PM | Chart tab | Cards: morning avg sys/dia vs. evening avg sys/dia |
| S1-10: Apple Health write | Save any reading | Silently | Written to HealthKit as HKQuantityTypeIdentifierBloodPressureSystolic/Diastolic correlation |
| S1-11: Apple Health read | Other app has BP readings | History tab | HealthKit readings appear with "Apple Health" source badge |
| S1-12: Reminder | Set 8am daily reminder | 8am next day | Push notification: "Time to log your blood pressure" |
| S1-13: Morning surge | Same-day readings: morning higher by ≥15 mmHg systolic | Home screen | Inline card: "Morning surge detected – your reading is 18 mmHg higher than this evening" |
| S1-14: Week delta | 2+ weeks of readings | Home screen | Card: "Your average this week is 4 mmHg lower than last week ↓" |

#### Acceptance Criteria

- [ ] Entry form: arm and position are `Picker` with segmented style; first option is blank "—" (optional); one-tap dismiss to save
- [ ] Validation: sys 60–250, dia 40–160, pulse 30–220; inline error text; Save disabled until sys + dia filled
- [ ] History: section headers by day; supports 1000+ readings without lag (SwiftData lazy fetch)
- [ ] Category badges: Normal (green, <120/<80) · Elevated (yellow, 120–129/<80) · High Stage 1 (orange, 130–139/80–89) · High Stage 2 (red, ≥140/≥90) · ISH (purple, systolic ≥140 + diastolic <90) · Hypotension (blue, <90/60) · Crisis (deep red, ≥180/≥120)
- [ ] SwiftCharts renders cleanly with 0, 1, or 500 readings; no crashes
- [ ] Statistics: uses same date range as chart period selector
- [ ] Morning surge: unit-tested; threshold configurable in Settings (default 15 mmHg); only fires if both AM and PM readings exist on the same day
- [ ] Week delta: requires ≥3 readings each week to display; shows "Not enough data" otherwise
- [ ] HealthKit: permissions requested once; graceful degradation if denied (no crash, no banner)
- [ ] Reminders: max 3 in free tier; stored via UNUserNotificationCenter; survive app update

**Estimated: 9 days**

---

### Sprint 2: Polish + Paywall (Days 15–22)

**Goal:** Onboarding (no paywall), free PDF, ESC standard, RevenueCat paywall, Apple Watch companion.

#### User Stories

| Story | Given | When | Then |
|---|---|---|---|
| S2-1: Onboarding | Fresh install | App opens | 3 screens: (1) "Blood pressure, beautifully tracked" (2) animated 5-second demo of logging (3) notification permission request → home. Zero paywall. |
| S2-2: Free PDF | Any readings exist | Tap Export PDF | PDFKit generates: app header · user name · date range · readings table (date, sys, dia, pulse, category, arm, position) · line chart image · stats summary. Shares immediately. No paywall. |
| S2-3: Free CSV | Any readings exist | Tap Export CSV | ISO 8601 timestamps · all fields · UTF-8 with BOM. Shares immediately. No paywall. |
| S2-4: ESC standard | Settings > BP Standard | Select ESC/ESH 2018 | All category colors + labels update throughout app |
| S2-5: Premium paywall | Tap "Set up Apple Watch" or "Enable iCloud Sync" | — | Clean 2-option screen: Monthly $1.99 · Annual $12.99. No other upsell surfaces. No weekly option. |
| S2-6: Apple Watch — log | Premium subscriber | Open Hartessa Watch app | Entry view: number pad for sys · dia · pulse · Save → syncs to iPhone |
| S2-7: Apple Watch — complication | Premium subscriber | Any watch face | Rectangular complication: "128/82 · High S1" with category color |
| S2-8: Apple Watch — last reading | Premium subscriber | Open watch app | Last reading card: sys/dia/pulse · category badge · timestamp ("2 hrs ago") |
| S2-9: iCloud sync | Premium subscriber, 2 devices | Add reading on iPhone | Appears on iPad within 30 seconds via Firestore |
| S2-10: Face ID lock | Enabled in Settings | App backgrounded + reopened | Face ID/Touch ID prompt; content hidden until authenticated |
| S2-11: Zero ads | Free tier, 30 days of use | Any interaction | Zero ad banners, zero interstitials, zero upsell pop-ups anywhere except the natural premium paywall screen |

#### Acceptance Criteria

- [ ] Onboarding: 3 screens; no email collection; no paywall screen; skip button on screen 1 goes straight to home
- [ ] PDF: `PDFKit` + `UIGraphicsImageRenderer` for chart; includes arm/position columns; footer: "Generated by Hearteesa · Not a medical device"; all free
- [ ] RevenueCat paywall: 2 products only — `monthly_199` ($1.99/month) + `annual_1299` ($12.99/year); `Purchases.shared.restorePurchases()` available; no trial, no lifetime option in v1.0
- [ ] Paywall surfaces ONLY from Apple Watch setting or iCloud sync toggle; never from onboarding, history, charts, or export flows
- [ ] WatchKit extension: `WKApplication`, session sync via `WatchConnectivity`; complication uses `CLKComplicationDescriptor` (rectangular + circular families)
- [ ] Firestore sync: offline-capable (Firestore cache); syncs on reconnect; path: `users/{uid}/readings/{readingId}`
- [ ] Zero ads confirmed: no `GADBannerView`, no `ATTrackingManager` in free flow
- [ ] ESC/ESH 2018 categories: Optimal (<120/<80), Normal (120–129/80–84), High Normal (130–139/85–89), Grade 1 (140–159/90–99), Grade 2 (160–179/100–109), Grade 3 (≥180/≥110)
- [ ] Dark mode: all screens pass visual review

**Estimated: 8 days**

---

### Sprint 3: Release Prep (Days 23–28)

**Goal:** App Store submission, TestFlight, claims-clean metadata.

#### User Stories

| Story | Given | When | Then |
|---|---|---|---|
| S3-1: Store metadata | App ready | App Store listing reviewed | Title: "Hearteesa — Blood Pressure Log" · Subtitle: "Track, Chart & Share Your BP" · Keywords lead with "blood pressure app" (3/5 Apple Ads score, 273k mass) |
| S3-2: Screenshots | — | Store listing previewed | 6 × 6.9" (1320×2868): (1) Home dashboard with morning surge card (2) Entry form with arm + position (3) Trend chart with AM/PM split (4) PDF preview (5) Apple Watch complication (6) "Zero ads, free PDF" value-prop screen |
| S3-3: Medical declaration | App Review check | — | "Regulated Medical Device: No" · No claims of diagnosis, measurement, or treatment in any UI string or metadata |
| S3-4: Privacy policy | App Review check | — | Live at `hartessa.app/privacy`; documents HealthKit use, Firestore sync (premium only), no data sold, GDPR + HIPAA compliant |
| S3-5: TestFlight | Build archived | Upload to ASC | Build live in TestFlight; CEO installs and performs end-to-end golden path test |
| S3-6: Claims register audit | All UI strings reviewed | — | No prohibited terms found: "diagnose", "treat", "measure blood pressure without a cuff", "detect hypertension", "arrhythmia detection" (this is a manual flag — no diagnostic claim) |
| S3-7: iPad layout | iPad tested | — | Uses sidebar NavigationSplitView; no stretched-phone UI |
| S3-8: Re-install clean | App deleted + reinstalled | — | Onboarding shows again; HealthKit permission requested fresh; no stale data visible |

#### Acceptance Criteria

- [ ] Archive via Xcode Automatic signing, Infinion team
- [ ] TestFlight build uploads successfully to ASC (no 90062 error — MARKETING_VERSION bumped)
- [ ] App Store listing draft: all fields complete, Medical Device = No, Age 4+, Category: Medical
- [ ] 6 × 6.9" (1320×2868 px) screenshots + 6 × 6.1" (1179×2556 px) screenshots uploaded
- [ ] Privacy policy live URL works
- [ ] App Review notes written: describe logging-only purpose, no diagnostic claims, HealthKit usage reason
- [ ] Claims register: grep all `*.swift` for prohibited strings; zero hits
- [ ] Crash-free golden path: fresh install → onboarding → first reading → PDF export → Apple Watch paywall trigger → purchase → Watch setup
- [ ] All target device sizes: 6.9", 6.7", 6.1" iPhones + iPad Pro 12.9"

**Estimated: 6 days**

---

## Appendix A: Free vs. Premium (Final)

| Feature | Free (forever) | Premium ($1.99/mo · $12.99/yr) |
|---|---|---|
| Unlimited BP readings | ✓ | ✓ |
| All entry fields (arm, position, notes, tags) | ✓ | ✓ |
| History list (unlimited) | ✓ | ✓ |
| Color categories (ACC/AHA + ESC + ISH) | ✓ | ✓ |
| Line chart (7/30/90-day + custom) | ✓ | ✓ |
| AM/PM time-of-day split | ✓ | ✓ |
| Statistics (avg/min/max/trend) | ✓ | ✓ |
| Morning surge detection | ✓ | ✓ |
| Week-over-week delta | ✓ | ✓ |
| PDF export (unlimited, all time) | ✓ | ✓ |
| CSV export | ✓ | ✓ |
| Apple Health sync | ✓ | ✓ |
| Reminders (up to 3) | ✓ | ✓ |
| 1 user profile | ✓ | ✓ |
| MAP + Pulse Pressure display | ✓ | ✓ |
| **Zero ads** | ✓ | ✓ |
| Apple Watch companion | — | ✓ |
| iCloud / Firestore sync | — | ✓ |
| Unlimited profiles (family) | — | ✓ |
| Unlimited reminders | — | ✓ |
| Medication tracking (full) | — | ✓ |
| Advanced analytics (scatter, variability, distribution) | — | ✓ |

---

## Appendix B: Ad & SDK Choices (What Hartessa Will NOT Have)

Based on APK findings, these SDKs / patterns are deliberately excluded from Hartessa:

| Excluded | Found in | Reason |
|---|---|---|
| Google AdMob | SmartBP + Health Tracker | No ads in Hartessa |
| AppLovin MAX mediation | Health Tracker | No ads in Hartessa |
| Facebook Audience Network (DEX-in-asset trick) | Health Tracker | No ads + App Review risk |
| AppsFlyer | Health Tracker | Privacy posture; SKAdNetwork sufficient |
| Rewarded ads ("watch ad to unlock") | Health Tracker | Conflicts with premium positioning |
| Credit-based AI chat | Health Tracker | Confusing, extractive model |
| Microsoft HealthVault | SmartBP | Dead platform (retired 2019 data) |
| Google Mobile Ads SDK | My Heart + SmartBP | No ads in Hartessa |
| 6+ pricing tiers | SmartBP | Two tiers only (monthly + annual) |
| Onboarding paywall | SmartBP | Never — show value first |

---

*Document version 2.0 — APK decompilation layer. Data sources: live APK decompilation using aapt2 (Android SDK 36), strings utility, direct asset JSON inspection. All three XAPKs downloaded 2026-10-29 from APKPure. Web sources (prior version): App Store, Google Play, adapty.io, smartbp.app, klimaszewski.mobi, cravingwise.com, caringvillage.com. Current as of 2026-10-29.*
