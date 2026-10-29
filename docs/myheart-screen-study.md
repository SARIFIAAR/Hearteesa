# My Heart — Deep Screen Study
*APK version Google-7.8.5 (versionCode 70805) · Analyzed from binary XML via aapt2 (Android SDK 36) · 2026-10-29*
*Developer: Szymon Klimaszewski (mobi.klimaszewski) · Bundle: com.szyk.myheart*

---

## Screen Inventory Summary

| Screen | Purpose | Layout Type | Complexity |
|---|---|---|---|
| onboarding_welcome | First launch welcome | ConstraintLayout | 1 |
| onboarding_details | Profile setup prompt | ConstraintLayout | 1 |
| onboarding_measurement_simple | First measurement intro | ConstraintLayout | 1 |
| onboarding_save | Tutorial: how to save | ConstraintLayout | 1 |
| onboarding_congrats | Completion celebration | ConstraintLayout | 1 |
| main | App shell / tab host | ConstraintLayout + Compose | 3 |
| history | Reading list | ConstraintLayout + ComposeView | 2 |
| history_settings | List view mode toggle | RadioGroup | 1 |
| data | Data entry tab host | ConstraintLayout + TabLayout + ViewPager | 3 |
| data_pressure | BP number entry (scrollers) | Custom NumberPickerCoordinator | 3 |
| data_weight | Weight entry (scrollers) | ConstraintLayout | 2 |
| data_oxygen | SpO2 entry | ConstraintLayout | 2 |
| data_tags | Tag selection | ConstraintLayout + Custom TagsPickerView | 2 |
| data_description | Notes/description entry | ConstraintLayout | 1 |
| data_vertical | Alternative full-page entry | ScrollView + ConstraintLayout + Flow | 3 |
| data_filter | Advanced history filter | LinearLayout + ScrollView | 3 |
| measurements | Readings overview tab | ConstraintLayout | 2 |
| intelligence | AI insights hub | ConstraintLayout + RecyclerView | 3 |
| intelligence_graph | Graph detail with scrubber | ConstraintLayout + Custom Graph | 4 |
| intelligence_diagram | Pie chart view | ConstraintLayout + MPAndroidChart | 3 |
| intelligence_graph_categories | Category breakdown | ConstraintLayout | 3 |
| intelligence_graph_hour_average | AM/PM averages graph | Custom Graph | 3 |
| item_intelligence_blood_pressure_card | BP insight card | RecyclerView item | 2 |
| item_intelligence_blood_pressure_graph | Graph card | RecyclerView item | 3 |
| item_intelligence_summary | Summary card | Custom PillsView | 3 |
| item_intelligence_summary_preview | Summary preview | ConstraintLayout | 2 |
| item_intelligence_progress_card | Progress card | ConstraintLayout | 2 |
| item_intelligence_pie | Pie chart card | ConstraintLayout | 2 |
| item_intelligence_switch_version | Live UI A/B switcher | RecyclerView item | 1 |
| statistics | Stats tab pager | Custom ViewPagerFixed | 2 |
| statistics_data | Data table (min/max/avg) | LinearLayout + TableLayout | 3 |
| statistics_graph_average | Average line graph | RelativeLayout + Custom Graph | 2 |
| statistics_graph_pulsepressure | Pulse pressure graph | RelativeLayout + Custom Graph | 2 |
| statistic_card_v1 | Stat summary card | ConstraintLayout | 2 |
| graph_layout | Reusable graph container | RelativeLayout + Custom Plotter | 2 |
| graph_settings | Graph config | ConstraintLayout | 2 |
| plot | Full-screen graph + filters | ConstraintLayout + ChipGroup | 4 |
| compose_graph | Compose-native graph | ComposeView | 3 |
| diagram_layout | Generic diagram | ConstraintLayout | 2 |
| pdf_main | PDF page 1 (user header) | ConstraintLayout | 3 |
| pdf_main2 | PDF page 2 (graphs) | ConstraintLayout | 4 |
| pdf_main3 | PDF page 3 (extra data) | ConstraintLayout | 3 |
| pdf_summary | PDF stat summary card | ConstraintLayout + Custom PillsView | 3 |
| pdf_viewer_fragment | In-app PDF viewer | ConstraintLayout + AndroidX PDF | 4 |
| annotation_toolbar | PDF annotation toolbar | HorizontalScrollView + Tools | 3 |
| annotation_tools | Tool palette (pen/hl/eraser) | LinearLayout + AnnotationToolViews | 3 |
| reminder | Reminder list | LinearLayout + ListView | 2 |
| reminder_picker | Create/edit reminder | LinearLayout + ScrollView | 3 |
| tags | Tag manager | LinearLayout + HorizontalScrollView | 2 |
| tags_bottom_sheet | Edit/delete tag sheet | LinearLayout | 1 |
| file_export | Export hub (PDF/CSV) | ConstraintLayout + ChipGroup | 2 |
| file_import | Import file browser | RelativeLayout + ListView | 2 |
| backup | Backup + Google Drive | ConstraintLayout | 3 |
| drive_backup_chooser | Drive file picker | RelativeLayout + RecyclerView | 2 |
| fragment_paywall | Premium upsell screen | FrameLayout + ConstraintLayout | 3 |
| fragment_paywall_plan | Plan option card | CardView + ConstraintLayout | 2 |
| fragment_paywall_plan_neutral | Neutral plan variant | CardView + ConstraintLayout | 2 |
| more_fragment | Settings menu | ConstraintLayout + RecyclerView | 2 |
| user_management | Profile editor | LinearLayout + ScrollView | 2 |
| users_bottom_sheet | Profile switcher | ConstraintLayout + RecyclerView | 2 |
| history_settings | History view toggle | RadioGroup | 1 |
| fragment_calm | Breathing/relaxation | ConstraintLayout + ComposeView | 2 |
| fragment_calm_warning | Calm session warning | ConstraintLayout + ComposeView | 2 |
| fragment_fit | Google Fit connect | ConstraintLayout | 2 |
| credits | Open source licenses | LinearLayout + RecyclerView | 1 |

---

## ONBOARDING

### Welcome Screen
**File:** `onboarding_welcome.xml`
**Purpose:** First screen seen on fresh install. Introduce the app concept.
**Layout:** ConstraintLayout (full-screen), `layout_height=MATCH_PARENT`
**Key elements:**
- `TextView` (title) — ref `onboarding_welcome_title` — large textAppearance attr, centered
- `TextView` (body) — ref `onboarding_welcome_message` — body textAppearance, bold, centered
- `Button` — ref `continue_text` — themed button style, bottom-constrained

**UX observations:**
- ✓ Radically minimal — 3 elements, nothing else. No carousel, no logo, no animation in XML (animation is programmatic)
- ✓ Both TextViews centered (gravity=0x11), good for reading-at-a-glance onboarding
- ✓ Vertical chain with `layout_constraintVertical_chainStyle=2` (packed) — elements float together in center, not pinned to top
- ✗ No illustration or visual. Title + body only — depends entirely on copy quality
- ✗ No skip option visible — forced linear progression
- → **Hartessa:** Keep 3-element minimal structure. Add one high-quality hero illustration or lottie animation. Add skip button (top-right) from screen 1.

---

### Details Screen
**File:** `onboarding_details.xml`
**Purpose:** Collect user profile details (name, age, etc.)
**Layout:** ConstraintLayout, `layout_height=WRAP_CONTENT`
**Key elements:**
- `TextView` (title) — `onboarding_details_title`
- `TextView` (message) — `onboarding_details_message`
- `TextView` (CTA) — `onboarding_details_cta` — bold, `textAllCaps=true`, accent color (theme attr `?0x7f040142`), 64dp bottom margin

**UX observations:**
- ✓ The CTA here is a TextView styled as a tap target, not a Button — gives more visual flexibility
- ✓ `textAllCaps=true` on CTA — creates visual hierarchy; this is the "tap to continue" pattern
- ✗ Actual input fields (name, age etc.) are not in this XML — they're inflated dynamically or in a ViewPager page below. The screen in XML is just the header. This suggests the details form is loaded below and this is just an intro frame.
- ✗ No visual feedback on what data is being collected before user starts entering
- → **Hartessa:** Show what you'll ask before asking. "Just your name — no email, no account." One sentence sets privacy expectations upfront.

---

### First Measurement Screen
**File:** `onboarding_measurement_simple.xml`
**Purpose:** Guide user to take their first BP measurement.
**Layout:** ConstraintLayout, WRAP_CONTENT height
**Key elements:**
- `TextView` (title) — `onboarding_measurement_title`
- `TextView` (message) — `onboarding_measurement_message`
- `TextView` (subtitle) — `onboarding_measurement_cta` — bold, `textAllCaps=true`, accent color — above the button
- `Button` — text `@0x7f1204f6` (= `skip`) — styled with `style=@0x7f130003` (a ghost/outline button style)

**UX observations:**
- ✓ Offers a skip button — respects the user's time; they can explore before logging
- ✓ Outline/ghost button style differentiates skip from primary CTA
- ✗ No animated demo of what the measurement entry looks like — cold jump to the picker
- ✗ No instruction on HOW to measure BP (which arm, sitting, etc.) — missed clinical teaching moment
- → **Hartessa:** Show a 3-second animation of the number picker filling in. Mention "sit for 5 minutes before measuring" as a one-line tip. This is a trust-building moment.

---

### Save Tutorial Screen
**File:** `onboarding_save.xml`
**Purpose:** Teach user how to save their first reading.
**Layout:** ConstraintLayout, WRAP_CONTENT height
**Key elements:**
- `TextView` (title) — `onboarding_save_title`
- `TextView` (body) — `onboarding_save_message`
- `TextView` (instruction) — **hardcoded string: `"Click the save button."`** — bold, textAllCaps, accent color
- `TextView` (hint) — `onboarding_save_cta_hint` — secondary color (theme `?0x7f040602`)

**Hardcoded string found:** `"Click the save button."` — this is raw English hardcoded in the layout, not in strings.xml. A localization bug — this string will remain in English for all locales.

**UX observations:**
- ✗ **Major bug:** "Click the save button." is hardcoded in the XML, not localized. Will show in English even in Arabic/Polish locales the app supports.
- ✗ Teaching "how to save" as a separate screen feels patronizing — if the save button is obvious, this screen wastes user time
- ✓ The use of a hint text (secondary color) below the CTA is a good pattern for adding context without hierarchy noise
- → **Hartessa:** Skip the tutorial for saving. If the save button is labeled clearly, users don't need a dedicated tutorial screen. Use the onboarding slot for something more valuable (e.g., setting up a reminder).

---

### Congrats Screen
**File:** `onboarding_congrats.xml`
**Purpose:** Celebrate first reading saved. Transition to main app.
**Layout:** ConstraintLayout, **MATCH_PARENT height** (only screen that fills full height)
**Key elements:**
- `TextView` (title) — `onboarding_end_title` — large, centered, secondary text color
- `TextView` (body) — `onboarding_end_message` — bold, centered, primary text color

**UX observations:**
- ✓ No button — the screen auto-progresses or the user taps anywhere. Feels like a celebration moment, not a form
- ✓ Full-height MATCH_PARENT differs from other onboarding screens — gives it a "stage" quality
- ✗ The primary/secondary color assignment is reversed compared to the other screens (body is primary, title is secondary) — inconsistency in the onboarding type ramp
- ✗ No visual celebration element (confetti, icon) — entirely text-based
- → **Hartessa:** Use a Lottie heartbeat or pulse animation. Show the reading just entered with its category color badge. Make the user feel the product works before they leave onboarding.

---

## CORE SCREENS

### Main Screen (App Shell)
**File:** `main.xml`
**Purpose:** Primary container for the app. Hosts all tabs.
**Layout:** ConstraintLayout root
**Key elements:**
- `FrameLayout` (id: `fragment_container_main`) — primary content area
- `ConstraintLayout` (id: `ad_banner_container`) containing:
  - `TextView` — text `ad_close_hint` (the close-ad affordance)
  - `ImageView` — close button for the ad
- `View` (divider above ad)
- `FrameLayout` x3 — additional fragment slots
- `ComposeView` — **Jetpack Compose island embedded in View system** — the newer parts of the app are being migrated to Compose

**UX observations:**
- ✗ The ad banner has a dedicated close hint TextView — confirms ads are intrusive enough to need an explicit dismiss affordance
- ✓ Compose island pattern shows technical evolution — they're gradually migrating to Compose without a full rewrite
- ✓ Multiple FrameLayout slots suggest modular content loading (different cards appear/disappear)
- → **Hartessa:** Pure SwiftUI from day 1, no hybrid. No ad container exists at any layer.

---

### History Screen
**File:** `history.xml`
**Purpose:** Chronological list of all BP readings.
**Layout:** ConstraintLayout
**Key elements:**
- `Toolbar` — action bar for filter/search controls
- `ComposeView` — the entire list is rendered in Jetpack Compose

**UX observations:**
- ✓ Moving the list to Compose enables animated insertions, gesture handling, and LazyColumn with no boilerplate
- ✓ Toolbar kept as View for the system integration (status bar theming, overflow menu)
- ✗ The split between View toolbar + Compose content creates a visual seam — top and content rendered by different systems, sometimes visible as a frame jitter
- → **Hartessa:** SwiftUI List with `.listStyle(.insetGrouped)` sections by day. Section headers sticky. Swipe-to-delete with undo using `.sensoryFeedback`.

---

### History Settings
**File:** `history_settings.xml`
**Purpose:** Toggle between simple/extended list row display.
**Layout:** RadioGroup
**Key elements:**
- `RadioButton` — text `simple` (compact rows)
- `RadioButton` — text `extended` (expanded rows with more data)

**UX observations:**
- ✓ Clean binary choice — simple vs extended. Good UX decision to expose this rather than hardcode one layout
- ✗ Exposed as a separate screen/sheet instead of a toolbar toggle — too much friction for a two-option setting
- → **Hartessa:** Inline toggle in the History navigation bar. No separate sheet needed.

---

### Data Entry Host
**File:** `data.xml`
**Purpose:** The entry point for logging a reading. Hosts tabbed sub-entries (BP, weight, SpO2, tags, notes).
**Layout:** ConstraintLayout
**Key elements:**
- `Toolbar`
- `TextInputLayout` (hint: `date`) + `AppCompatEditText` — date picker
- `TextInputLayout` (hint: `time`) + `AppCompatEditText` — time picker
- `Barrier` (layout constraint helper, no visual)
- `TabLayout` + `ViewPager` — 4+ tabs: BP, Weight, SpO2, (more)
- `View` (separator line before save button)
- `TextView` — text `message_saved` (confirmation toast)
- `Button` — text `add_data_button` — primary CTA

**UX observations:**
- ✓ Date and time live above the ViewPager tabs — shared across all data types, not repeated per tab. Smart layout.
- ✓ Message_saved confirmation inline (not a Toast or Snackbar) — stays readable longer
- ✗ TabLayout UI is dated — small text tabs for BP/Weight/SpO2 look like a settings panel, not a health entry form
- ✗ ViewPager swipe can accidentally switch between BP and Weight mid-entry — data loss risk
- ✗ Must save each tab independently? Unclear from XML — the single `add_data_button` at the bottom is ambiguous
- → **Hartessa:** Single-screen entry form for BP (the primary action). Weight/SpO2 as optional add-ons inline on the same form, not tabs. One save button, one save action.

---

### Blood Pressure Entry
**File:** `data_pressure.xml`
**Purpose:** Enter systolic / diastolic / pulse values.
**Layout:** `mobi.klimaszewski.view.picker.NumberPickerCoordinatorLayout` (custom root)
**Key elements:**
- `TextView` — text `systolic_label`
- `TextView` — text `diastolic_label`
- `TextView` — text `pulse_label`
- `NumberPickerView` × 3 — custom scrolling number pickers (the developer's own library: `mobi.klimaszewski.view.picker`)
- `FrameLayout` containing `ProgressBar` — loading state
- `View` + `TextView` — `loading` text — shown while saving

**Custom view:** `mobi.klimaszewski.view.picker.NumberPickerView` — a custom infinite-scroll number picker replacing the stock Android `NumberPicker`. The developer built their own component, which explains the smoother haptic-feedback feel compared to native.

**UX observations:**
- ✓ Custom number picker is genuinely better than Android's stock widget — momentum scrolling, larger hit targets, consistent theming
- ✓ The "coordinator" root layout means the picker columns can coordinate scroll conflicts (prevents horizontal swipes stealing from vertical pickers)
- ✗ No arm side (left/right) field — confirmed absent
- ✗ No body position (sitting/standing/lying) field — confirmed absent
- ✗ Three columns of identical visual weight — users report mis-reading dia as sys
- → **Hartessa:** iOS equivalent is `WheelPicker`-style ScrollView pickers. Add arm and position pickers below the numbers. Use visual hierarchy: systolic notably larger than diastolic (clinical convention).

---

### Weight Entry
**File:** `data_weight.xml`
**Purpose:** Log body weight alongside a BP reading.
**Layout:** ConstraintLayout
**Key elements:**
- `NumberPickerView` (integers)
- `TextView` — hardcoded `"."` decimal separator
- `NumberPickerView` (decimals)
- `Button` — text `weight_include` (save)
- `ImageView` (weight unit icon)
- `MaterialSwitch` — text `include_always` — toggle to auto-include weight every time
- `TextView` (unit label, dynamic)

**UX observations:**
- ✓ "Include always" toggle is smart UX — users who weigh daily don't want to tap through weight entry every time
- ✓ Split pickers for integer/decimal with hardcoded "." between — cleaner than a single decimal picker
- ✗ `include_always` hidden below the fold — users who'd benefit most from it may never find it
- → **Hartessa:** Same `include_always` toggle but make it visible by default. Place it above the picker, not below.

---

### SpO2 Entry
**File:** `data_oxygen.xml`
**Purpose:** Log blood oxygen saturation.
**Layout:** ConstraintLayout
**Key elements:**
- `NumberPickerView` (SpO2 %)
- `Button` — text `add_oxygen` (save)
- `ImageView` (SpO2 icon)

**UX observations:**
- ✓ Minimal — identical pattern to weight. One value, one save action.
- ✗ No context about when to measure SpO2 or what values mean clinically
- → **Hartessa:** Include SpO2 in v1.1. Add an inline reference: "Normal: 95–100%".

---

### Tags Entry
**File:** `data_tags.xml`
**Purpose:** Attach contextual tags to a reading (before meal, after exercise, etc.).
**Layout:** ConstraintLayout
**Key elements:**
- `Button` — text `create_tag` — add new custom tag
- `Button` (secondary) — manage/edit existing tags
- `ScrollView` → `mobi.klimaszewski.view.TagsPickerView` — custom chip-picker for selecting tags

**UX observations:**
- ✓ Custom `TagsPickerView` — not raw chip buttons. Suggests momentum scrolling and larger tap targets for tag chips
- ✓ `create_tag` inline — no need to leave the entry flow to add a new tag
- ✗ Horizontal scroll for tags hidden inside a ScrollView — discoverability issue. Users may not realize there are more tags off-screen
- → **Hartessa:** Flowing chips (`.flexLayout` style, wrapping). Most-used tags at the top. Custom tag creation inline.

---

### Notes/Description Entry
**File:** `data_description.xml`
**Purpose:** Free-text note attached to a reading.
**Layout:** ConstraintLayout
**Key elements:**
- `EditText` — hint `type_in_description_here_` — multiline free text

**UX observations:**
- ✓ Entire screen is just one EditText. No chrome. Optimal.
- ✗ Trailing underscore in the hint string name (`type_in_description_here_`) = typo in resource naming convention. Minor but shows code quality.
- → **Hartessa:** Same approach. Full-screen notes editor with character count and keyboard auto-focus.

---

### Alternative Entry (Vertical)
**File:** `data_vertical.xml`
**Purpose:** A vertically-scrolling alternative layout for data entry. Used on smaller screens or landscape mode.
**Layout:** ScrollView → ConstraintLayout
**Key elements:**
- `Toolbar`
- `TextInputLayout` (date) + `TextInputLayout` (time) — same as data.xml
- `Barrier`
- `Flow` (ConstraintLayout helper) — auto-flowing input fields
- `TextView` — `input_bp_title`

**UX observations:**
- ✓ `Flow` widget from ConstraintLayout = responsive, wraps fields to multiple rows on narrow screens
- ✓ ScrollView root means this works on all screen sizes without clipping
- → **Hartessa:** SwiftUI `Form` with sections achieves the same. No alternate layout needed — `Form` adapts natively.

---

## INTELLIGENCE / AI INSIGHTS

### Intelligence Hub
**File:** `intelligence.xml`
**Purpose:** Main "AI" screen — scrollable list of insight cards.
**Layout:** ConstraintLayout
**Key elements:**
- `Toolbar`
- `RecyclerView` — scrollable card list
- `ContentLoadingProgressBar` — shown while loading
- `LinearLayout` (empty state):
  - `TextView` — `onboarding_empty_stats` — shown when insufficient data
  - `ImageView` — empty state illustration

**UX observations:**
- ✓ Clean hub-and-spoke pattern — the hub is a RecyclerView, each card drills into detail
- ✓ `ContentLoadingProgressBar` only shows after a short delay — prevents loading flicker for fast loads
- ✓ Empty state with illustration — doesn't leave user staring at a blank screen
- ✗ The empty state uses `onboarding_empty_stats` string — mixes onboarding and in-app state copy
- → **Hartessa:** Same card list model. Use `.refreshable` pull-to-refresh. Animate card insertion when new insights calculate.

---

### Intelligence Graph
**File:** `intelligence_graph.xml`
**Purpose:** Full-screen interactive graph with timeline scrubber.
**Layout:** ConstraintLayout
**Key elements:**
- `ImageView` (header/thumbnail)
- `com.szyk.extras.ui.plot.graph.Graph` — custom graph view (the developer's own charting library)
- `ImageButton` (prev period) + `ImageButton` (next period) — navigation arrows
- `SeekBar` — timeline scrubber (drag to move through time)

**UX observations:**
- ✓ SeekBar as a timeline scrubber is a clever UX pattern — allows continuous time navigation without calendar pickers
- ✓ Custom graph library (`com.szyk.extras.ui.plot.graph`) — not MPAndroidChart here, his own. Explains smooth performance
- ✗ Two navigation arrows + a SeekBar is redundant — either arrow-based OR scrubber, not both
- → **Hartessa:** Use `SwiftCharts` with gesture-driven scrubbing (DragGesture on chart). Show a callout bubble with exact values at touch point.

---

### Intelligence Diagram (Pie Chart)
**File:** `intelligence_diagram.xml`
**Purpose:** Distribution of readings by BP category (pie chart).
**Layout:** ConstraintLayout
**Key elements:**
- `ImageView` (thumbnail/icon)
- `com.github.mikephil.charting.charts.PieChart` — MPAndroidChart pie chart

**Note:** This screen uses MPAndroidChart (third-party) while `intelligence_graph` uses the developer's own library. Two charting libraries in one app — technical inconsistency.

**UX observations:**
- ✗ Pie charts are generally poor for medical data — hard to compare arc sizes accurately. The distribution of readings is better shown as a stacked bar or heatmap.
- ✓ Category color pie is visually intuitive for "how much of my time am I in each zone"
- → **Hartessa:** Use `SwiftCharts` `BarMark` as a horizontal stacked bar. One row, colored segments = time in each category. Much more readable than pie.

---

### Intelligence Category Graph
**File:** `intelligence_graph_categories.xml`
**Purpose:** Trend line graph filtered per BP category.
**Layout:** ConstraintLayout
**Key elements:**
- Custom `Graph` view
- `ImageView` (legend)
- `SeekBar`

**UX observations:**
- ✓ Filtering the trend line by category (show only High Stage 2 readings over time) is a clinically useful view
- ✗ No label explaining which category is selected — relies on color alone (accessibility issue)
- → **Hartessa:** Same view but with text legend + color. Accessible for color-blind users.

---

### Intelligence Summary Card
**File:** `item_intelligence_summary.xml`
**Purpose:** A compact summary card showing period avg + trend.
**Layout:** ConstraintLayout + custom `PillsView`
**Key elements:**
- `TextView` (period: 28 days — `statistics_last_28_days`)
- `TextView` (mean — `stats_mean`)
- `TextView` (sys reading)
- `TextView` "/" separator hardcoded
- `TextView` (dia reading)
- `Barrier` (layout constraint separator)
- `TextView` (sys change)
- `TextView` (dia change)
- `com.szyk.myheart.intelligence.inner.view.PillsView` × 4 — category pill indicators

**Custom view:** `PillsView` — a row of colored pill/dot indicators showing BP category distribution. The developer built this as a custom view.

**UX observations:**
- ✓ `PillsView` is a genuinely clever compact visualization — 4 dots in their category colors, sized proportionally = instant visual of where you spent most time
- ✓ Displaying both the mean value AND the change from previous period in one card
- ✗ Four PillsView instances (4 separate IDs) suggests they're not dynamically created — potentially rigid category count
- → **Hartessa:** Equivalent in SwiftUI: a `HStack` of capsule shapes, colored and sized proportionally. Animate the resize when period changes.

---

### Intelligence Version Switcher
**File:** `item_intelligence_switch_version.xml`
**Purpose:** Allows users to toggle between new and old analytics UI live in production.
**UX observations:**
- ✓ Shipping a version toggle to production users = A/B testing without a backend. Brave and UX-informed.
- → **Hartessa:** Not needed — ship one version. But note the pattern for future premium UI experiments.

---

## STATISTICS

### Statistics Hub
**File:** `statistics.xml`
**Purpose:** Tab-paged stats view (data table + graphs).
**Layout:** Custom `com.szyk.extras.ui.ViewPagerFixed` + `PagerTabStrip`

**Note:** `ViewPagerFixed` is their own subclass of ViewPager — likely fixes the nested scroll conflict issue where a ViewPager inside a ScrollView fights for touch events.

**UX observations:**
- ✓ Custom ViewPager fix = better scroll UX in practice
- → **Hartessa:** SwiftUI `TabView` with `PageTabViewStyle` handles this natively.

---

### Statistics Data Table
**File:** `statistics_data.xml`
**Purpose:** Tabular summary: min/max/avg/count for each metric.
**Layout:** LinearLayout → TableLayout
**Key elements:**
- Title `TextView` — `total_count`
- `TableLayout` with header row and data rows
- Column headers: `systolic_short`, `diastolic_short`, `pulse_short`, `pulse_pressure_short`, `text_mean_arterial_pressure_short`, `weight` + one blank column
- Data rows: dynamic TextViews for values
- Also shows: `best` (best reading in period)

**UX observations:**
- ✓ Includes MAP and Pulse Pressure — clinically relevant derived metrics, not just raw sys/dia
- ✓ "Best" reading row is a positive framing — motivating to see your personal best
- ✗ TableLayout is a deprecated pattern — extremely rigid for varied screen sizes
- ✗ 7 columns on a phone screen = cramped. Each column is ~40dp wide = hard to read
- → **Hartessa:** Summary cards stacked vertically, not a table. One card per metric (sys/dia/pulse/MAP). Each card: current avg · min · max · trend arrow. Much more readable.

---

### Plot / Graph Filter Screen
**File:** `plot.xml`
**Purpose:** Full-screen graph with metric filter chips.
**Layout:** ConstraintLayout
**Key elements:**
- `Toolbar`
- `ChipGroup` (horizontal scroll) with 5 `Chip`s: `systolic`, `diastolic`, `pulse`, `weight`, `trends_label`
- Prev/Next `ImageButton` (period navigation)
- `SeekBar` (time scrubber)
- Custom `Graph` view
- `ProgressBar`

**UX observations:**
- ✓ Chip filter row is excellent — tap to toggle which metrics show on the graph. Standard, discoverable, fast.
- ✓ Having "trends_label" as a selectable line = shows the moving average trend over raw readings
- ✗ Two competing navigation systems again (arrows + scrubber)
- ✗ ChipGroup in horizontal scroll = chips beyond screen edge are hidden, no indicator of overflow
- → **Hartessa:** `SwiftCharts` with toggle buttons above chart. Use a segmented control for period. Trend line as default-on toggle.

---

## PDF SYSTEM

### PDF Page 1 (Header)
**File:** `pdf_main.xml`
**Purpose:** Cover page of the generated PDF report.
**Layout:** ConstraintLayout
**Key elements:**
- `TextView` — text `username` (dynamic, user's name)
- `TextView` — **hardcoded: `"Szymon Klimaszewski"`** (the developer's own name as the default author value — this is a placeholder that leaks the developer's personal name into generated reports if the user's name is never set)
- `TextView` — text `date` label
- `TextView` — **hardcoded: `"01.03.21-04.04.21"`** (sample date range — a placeholder)
- `TextView` — `measurements_count`
- `TextView` — **hardcoded: `"80"`** (sample reading — a placeholder)
- `View` (section divider)

**Critical finding:** The developer's personal name `"Szymon Klimaszewski"` is hardcoded in the PDF layout as a fallback default. If a user never enters their name, their generated PDF would show the developer's name as the report author. This is a data quality bug.

**UX observations:**
- ✗ **Bug:** Developer's personal name (`"Szymon Klimaszewski"`) hardcoded as PDF author default
- ✗ **Bug:** Sample date `"01.03.21-04.04.21"` and `"80"` hardcoded — should be `@string` placeholders
- → **Hartessa:** Use a proper default for nameless users ("My Health Report" or leave blank). Zero hardcoded personal data.

---

### PDF Page 2 (Graphs)
**File:** `pdf_main2.xml`
**Purpose:** Graph page of PDF — two charts + category legend.
**Layout:** ConstraintLayout
**Key elements:**
- `TextView` — `stats_card_lifetime`
- Custom `Graph` × 2 (stacked vertically)
- `FlexboxLayout` (tags display — wrapping chips)
- Labels: `cattegories_propagation_in_time`, `hour_average`, `statistics_title_new`
- `LinearLayout` (additional data section)

**Note:** `FlexboxLayout` (from Google) is used for tags — wraps to next row when needed. The developer uses their own charting library here, not MPAndroidChart.

**UX observations:**
- ✓ Two graphs side-by-side (or stacked) gives comprehensive visual summary
- ✓ FlexboxLayout for tags = tags always visible, never truncated
- ✗ String `cattegories_propagation_in_time` suggests a "categories over time" chart — the string name has a typo (`cattegories` not `categories`), another code quality signal
- → **Hartessa:** PDF page 2: one primary line chart (full width) + AM/PM bar comparison + category distribution bar. PDFKit renders SwiftCharts natively.

---

### PDF Viewer (In-App)
**File:** `pdf_viewer_fragment.xml`
**Purpose:** View and annotate the generated PDF without leaving the app.
**Layout:** ConstraintLayout
**Key elements:**
- `androidx.pdf.view.PdfContentLayout` — Google's new AndroidX PDF viewer (requires Android 15+)
- `ProgressBar` (loading)
- `TextView` — `error_cannot_open_pdf`
- `ToolBoxView` — annotation tools container
- `PdfSearchView` — in-PDF text search

**Note:** `androidx.pdf.view.PdfContentLayout` is part of the brand-new `androidx.pdf` library (stable since Oct 2024). This requires **Android 15+** — combined with the minSdk 32 (Android 12) restriction, My Heart's PDF viewer only works on Android 15+ devices. Users on Android 12-14 see the error state.

**UX observations:**
- ✓ In-app PDF viewer with annotation = no need to leave the app to share/mark up the report
- ✗ `androidx.pdf` requires Android 15+ but app minSdk is 32 (Android 12) — PDF viewer broken on ~60% of their target devices
- → **Hartessa:** Use `PDFKit` (built into iOS, works on all supported iOS versions). Always available, no version gate.

---

### Annotation Toolbar
**File:** `annotation_toolbar.xml`
**Purpose:** Floating toolbar for PDF annotation tools.
**Layout:** LinearLayout → HorizontalScrollView
**Key elements:**
- `HorizontalScrollView` → `LinearLayout` — tool buttons (scrollable when many tools)
- `AnnotationToolView` (select) — mode switcher
- `BrushSizeSelectorView` — pen/highlighter size slider
- `ColorPaletteView` — color picker

### Annotation Tools
**File:** `annotation_tools.xml`
**Purpose:** The actual tool icons (pen, highlighter, eraser variants).
**Key elements:**
- 7 × `AnnotationToolView` instances:
  - Selector tool
  - Pen (standard)
  - Pen (variant)
  - Highlighter (standard)
  - Highlighter (variant)
  - Eraser (standard)
  - Eraser (variant)

**Note:** Uses `androidx.pdf.view.annotation.*` — Google's new annotation API. Same Android 15+ requirement caveat applies.

**UX observations:**
- ✓ 7 annotation tools is comprehensive — covers clinical annotation needs (highlight readings, draw attention arrows, erase)
- ✓ Brush size + color palette both in the toolbar = no sub-menus needed for basic annotation
- ✗ 7 tools can't all fit on a phone screen width without scrolling — HorizontalScrollView dependency
- → **Hartessa:** Use `PDFKit` annotation APIs. 3 tools: highlighter, pen, eraser. Apple's `UIColorPickerViewController` for colors. Simple, proven, iOS-native.

---

## REMINDERS

### Reminder List
**File:** `reminder.xml`
**Purpose:** Show all configured reminders.
**Layout:** LinearLayout → ListView

**UX observations:**
- ✗ `ListView` is deprecated in favor of `RecyclerView` — shows legacy code age
- → **Hartessa:** SwiftUI `List` with `.onDelete`.

---

### Reminder Picker (Create/Edit)
**File:** `reminder_picker.xml`
**Purpose:** Configure a new reminder.
**Layout:** LinearLayout → ScrollView
**Key elements:**
- `Toolbar`
- `TextInputLayout` (hint: `time_label`) + `EditText`
- `TextInputLayout` (hint: `description_label`) + `EditText`
- Repeat section (label: `reminder_repeat`)
- Day buttons: `day_short_su` (Sunday) + others (Monday–Saturday dynamic)

**UX observations:**
- ✓ Custom day-of-week picker for repeating reminders — better than just "daily"
- ✗ Time is entered as text (`TextInputLayout` + `EditText`) — no time picker? This seems incomplete; likely the EditText opens a time-picker dialog on click
- → **Hartessa:** Native iOS `DatePicker` in `.compact` style for time. Day-of-week repeat toggle chips inline.

---

## TAGS

### Tag Manager
**File:** `tags.xml`
**Purpose:** Manage all custom and preset tags.
**Layout:** LinearLayout
**Key elements:**
- `Button` — text `create_tag` (= "create new tag")
- `HorizontalScrollView` → tag chips list

**UX observations:**
- ✗ Tags in a horizontal scroll = only ~3-4 visible at once, rest hidden off-screen
- → **Hartessa:** Wrapping FlowLayout for tags. All visible at once. Scroll only if > ~20 tags.

### Tags Bottom Sheet
**File:** `tags_bottom_sheet.xml`
**Purpose:** Edit or delete an existing tag.
**Key elements:**
- `TextView` — `modify_tag`
- `TextView` — `delete_tag`

**UX observations:**
- ✓ Minimal two-action sheet. Exactly right.

---

## EXPORT & BACKUP

### File Export Screen
**File:** `file_export.xml`
**Purpose:** Choose format and filename for export.
**Layout:** ConstraintLayout + ChipGroup
**Key elements:**
- `Toolbar`
- `TextInputLayout` (hint: `file_export_hint`) — custom filename
- Format chip group with 2 options:
  - Chip — `data_export_data_type_report` (= PDF report)
  - Chip — `data_export_title_data_type_raw_data` (= raw CSV data)
- `Button` — text `filters` (apply export filters)
- Info text

**UX observations:**
- ✓ Format selection as chips is correct — mutually exclusive, visible options
- ✓ Custom filename is useful for doctor sharing
- ✓ Filters button allows date-range filtering before export
- ✗ No preview of what the PDF will contain
- → **Hartessa:** Share sheet triggered directly from "Export PDF" button. No extra screen needed. PDF previews inline via `QuickLookPreviewItem`.

---

### Backup Screen
**File:** `backup.xml`
**Purpose:** Manual backup to Google Drive + restore.
**Layout:** ConstraintLayout
**Key elements:**
- `SwitchCompat` in `Toolbar` — text `data_backup` (enable/disable backup toggle **inside the toolbar**)
- `TextView` — `drive_message` (status text)
- `TextView` — **hardcoded: `"Sign In with Google"`** (another hardcoded string, not localized)
- `RecyclerView` (list of backup files)
- `Button` — `settings_title_create_backup` (manual backup trigger)
- `ProgressBar` / loading state

**Critical finding:** `"Sign In with Google"` is hardcoded in two places (`backup.xml` and `fragment_fit.xml`) — another localization bug. The Google sign-in button text should come from Google's brand guidelines anyway (their SDK provides it).

**UX observations:**
- ✗ Toggle switch embedded inside the Toolbar is unexpected — users don't look at toolbars for settings
- ✗ `"Sign In with Google"` hardcoded again — consistent localization failure
- → **Hartessa:** iCloud sync toggle in Settings (its natural home). No separate backup screen needed — iCloud handles it transparently.

---

## PAYWALL

### Paywall Screen
**File:** `fragment_paywall.xml`
**Purpose:** Premium upsell screen with benefits list.
**Layout:** FrameLayout → ConstraintLayout
**Key elements:**
- `LinearLayout` (header):
  - `TextView` — `paywall_subtitle`
  - `TextView` — `revenue_title`
- `ImageView` (premium illustration, full-width)
- `TextView` (dynamic benefit list via RecyclerView or dynamic inflation)
- Inner `ConstraintLayout` containing 2 plan containers (the plan cards)

**String references:** `paywall_subtitle` + `revenue_title` — the subtitle + title are generic, not feature-specific. The benefits are dynamically loaded.

**UX observations:**
- ✓ Full-width illustration before the plan cards — emotional hook before the ask
- ✓ FrameLayout root means plan cards can be swapped for A/B test variants without reflowing the page
- ✗ "revenue_title" string name reveals the commercial framing internally — this string was named by an engineer thinking about revenue, not user value
- → **Hartessa:** Paywall triggered only from Apple Watch or iCloud sync toggle. No aggressive upsell. Two options: Monthly ($1.99) + Annual ($12.99). Restore Purchases link.

---

### Plan Card (Standard)
**File:** `fragment_paywall_plan.xml`
**Purpose:** Individual pricing option card.
**Layout:** CardView
**Key elements:**
- `TextView` — **hardcoded: `"One time payment"`** — even in a subscription-first app, they offer a lifetime one-time purchase option. This is hardcoded, not in strings.xml.
- `TextView` (price — dynamic)
- `TextView` (CTA — dynamic)

**Critical finding:** `"One time payment"` is hardcoded in both `fragment_paywall_plan.xml` AND `fragment_paywall_plan_neutral.xml`. My Heart secretly offers a one-time lifetime purchase option, but it's not mentioned in their App Store listing or reviews. This is a hidden premium tier.

**UX observations:**
- ✓ CardView plan cards = clear visual separation between options
- ✓ One-time payment option (hidden in plain sight) — smart for users who distrust subscriptions
- ✗ Hardcoded English "One time payment" — won't localize
- → **Hartessa:** Two tiers only in v1.0. No lifetime option initially — reduces pricing complexity.

### Plan Card (Neutral)
**File:** `fragment_paywall_plan_neutral.xml`
**Purpose:** A/B test variant of the plan card with neutral visual styling.
**Key elements:** Identical structure to `fragment_paywall_plan` — `"One time payment"` hardcoded in both.

**UX observations:**
- ✓ A/B testing the tone of the paywall (standard vs neutral) = data-driven paywall optimization
- The structure is identical — only visual style differs (CardView elevation, colors, typography weight)
- → **Hartessa:** Start with one clean paywall. A/B test post-launch with RevenueCat paywalls.

---

## SETTINGS & MORE

### More/Settings Menu
**File:** `more_fragment.xml`
**Purpose:** Settings navigation hub.
**Layout:** ConstraintLayout → RecyclerView

**UX observations:**
- ✓ RecyclerView-based settings list = easily extensible. New settings items added without layout changes.
- → **Hartessa:** SwiftUI `Form` + `Section` grouping. Grouped: Account / Preferences / Health / Export / About.

---

### User Management (Profile Editor)
**File:** `user_management.xml`
**Purpose:** Create or edit a user profile.
**Layout:** LinearLayout → ScrollView
**Key elements:**
- `TextInputLayout` (hint: `type_in_username`) → name field
- `TextInputLayout` (hint: `date_of_birth_title`) → DOB field
- Medical condition section:
  - `TextView` — `diabetic_title` ("Diabetic?")
  - `CheckBox` — text `diabetes` — flag as diabetic

**Critical finding:** My Heart captures **diabetes status** in the user profile. This is a medically significant field not mentioned anywhere in their store listing. Diabetes strongly correlates with hypertension — users with diabetes need different BP targets (ADA: <130/80 vs standard <120/80). The app likely adjusts category thresholds based on this flag.

**UX observations:**
- ✓ Capturing diabetes status is clinically smart — enables personalized BP targets
- ✗ Collecting health condition data without explicit privacy notice in the screen itself
- → **Hartessa:** v1.1 — add a "Health conditions" section in profile: diabetes, kidney disease, pregnancy. Each adjusts the BP category thresholds shown. Include a privacy note: "Stored locally only."

---

### Users/Profile Switcher
**File:** `users_bottom_sheet.xml`
**Purpose:** Switch between family profiles.
**Layout:** ConstraintLayout
**Key elements:**
- `ImageView` (illustration)
- `TextView` — `choose_user`
- `RecyclerView` (profile list)

**UX observations:**
- ✓ Bottom sheet for profile switching = quick, no full-screen navigation needed
- → **Hartessa:** Same bottom sheet from a profile icon in the navigation bar.

---

## HIDDEN / UNDOCUMENTED SCREENS

### Calm / Breathing Module
**File:** `fragment_calm.xml`
**Purpose:** Guided breathing or relaxation session — undocumented in store listing.
**Layout:** ConstraintLayout
**Key elements:**
- `ComposeView` (animation — breathing circle animation, likely)
- `ImageView` (illustration)
- `TextView` (description — dynamic)
- `Button` — text `calm_begin`

### Calm Warning
**File:** `fragment_calm_warning.xml`
**Purpose:** Pre-session safety warning for the breathing exercise.
**Layout:** ConstraintLayout
**Key elements:**
- `ComposeView` (warning animation)
- `ImageView`

**UX observations:**
- ✓ A breathing/calm module tied to a BP app is clinically meaningful — stress reduction directly lowers BP. They just don't advertise it.
- ✓ Warning screen before breathing exercise = safety-conscious design
- ✗ Hidden feature — users who'd benefit most (stressed, hypertensive) never find it
- → **Hartessa:** Could offer a "Take a breath before measuring" prompt when readings are high (High Stage 2 / Crisis). Simple 60-second box breathing animation. Differentiator.

---

### Google Fit / Health Connect Screen
**File:** `fragment_fit.xml`
**Purpose:** Connect to Google Fit or Health Connect for additional health data.
**Layout:** ConstraintLayout
**Key elements:**
- `Toolbar` with `Button` — text `download` (download health data)
- `ImageView` (Google Fit logo)
- `TextView` — `google_fit_description`
- `TextView` — **hardcoded: `"Sign In with Google"`** (third instance of this localization bug)
- `Switch` — text `health_switch` (toggle sync on/off)

**UX observations:**
- ✓ Dedicated screen for health integration setup — not buried in settings
- ✗ `"Sign In with Google"` hardcoded a third time — consistent localization failure pattern
- ✗ The screen is titled "fit" but actually connects Health Connect (not Google Fit legacy) — naming confusion
- → **Hartessa:** HealthKit integration is implicit (iOS permission request). No dedicated screen needed.

---

### Credits (Open Source Licenses)
**File:** `credits.xml`
**Purpose:** List open source library attributions.
**Layout:** LinearLayout → Toolbar + RecyclerView

**Third-party libraries exposed by the credits screen:**
- MPAndroidChart (pie chart)
- mobi.klimaszewski.view.picker (number picker — the developer's own library)
- FlexboxLayout
- Their custom `com.szyk.extras.ui.plot.graph` charting library

**UX observations:**
- ✓ Shipping an open source attribution screen is legally required for some licenses and is good practice
- → **Hartessa:** Settings → About → Open Source Licenses (using the standard iOS Settings bundle or a simple list view).

---

## DESIGN ARCHITECTURE SUMMARY

### What My Heart does technically well

| Pattern | Implementation | Signal |
|---|---|---|
| Custom number pickers | `mobi.klimaszewski.view.picker` — their own library | Invested in the core data entry UX. The picker is better than anything off-the-shelf. |
| Custom graph library | `com.szyk.extras.ui.plot.graph.Graph` | Performance > MPAndroidChart. Consistent styling across all chart types. |
| Compose hybrid | ComposeView islands in View layouts | Migrating to Compose incrementally. History list and calm animation in Compose. |
| PillsView | Custom `com.szyk.myheart.intelligence.inner.view.PillsView` | Bespoke data visualization component. Not available anywhere else. |
| A/B testing | `item_intelligence_switch_version` + dual paywall layouts | Shippping variants to production for live user testing. |

### What My Heart does poorly

| Issue | Evidence | Impact |
|---|---|---|
| Localization bugs | `"Click the save button."`, `"Szymon Klimaszewski"`, `"Sign In with Google"` × 3, `"One time payment"` all hardcoded in layout XML | Shown verbatim in all non-English locales |
| PDF viewer Android 15+ only | `androidx.pdf.view.PdfContentLayout` requires Android 15 | PDF broken on ~60% of their minSdk-32 user base |
| Legacy ListView | `reminder.xml` uses `ListView` | Deprecated, poor performance vs RecyclerView |
| TableLayout for statistics | `statistics_data.xml` | Cramped on small screens, breaks on larger ones |
| Developer name in PDF | `"Szymon Klimaszewski"` hardcoded in `pdf_main.xml` | Shows developer's name in user-generated health reports if username unset |
| Missing arm/position fields | Confirmed absent in `data_pressure.xml` | Key clinical context lost on every reading |

---

## HARTESSA DESIGN IMPLICATIONS

### Copy directly
- Minimal onboarding (5 screens, zero paywall)
- Custom number pickers for sys/dia/pulse (iOS: WheelPicker-style, larger hit targets than stock)
- PillsView equivalent (capsule-shaped distribution indicators)
- SeekBar/scrubber for graph timeline navigation (iOS: DragGesture on chart)
- Chip filter row above graphs (iOS: SwiftUI segmented control or chip row)
- `include_always` toggle on weight entry
- Diabetes flag in profile (v1.1) for personalized BP targets
- Breathing/calm module (hidden but clinically valuable) — surface it contextually when readings are high

### Fix and improve
- Add arm side + body position to entry form (My Heart's biggest omission)
- PDF always readable (PDFKit works on all iOS 17+ devices — no version gate)
- Fix all hardcoded strings (every label in `strings.swift`, no raw text in Views)
- Replace TableLayout stats with vertical stat cards
- Replace ListView reminders with SwiftUI List
- Replace pie chart with horizontal stacked bar for category distribution
- Surface calm/breathing module contextually instead of hiding it

### Avoid entirely
- Ad banner container in the main shell
- Hardcoded developer personal data in layouts
- Dual charting libraries
- Sign-in-required for backup (iCloud works silently)
- Paywall with hardcoded English "One time payment"

---

*Source: APK binary XML decompilation via aapt2 · String resource resolution via aapt2 dump · Cross-referenced with 1,381 string resource names · All findings from com.szyk.myheart version 7.8.5 (versionCode 70805)*
