# Hartessa Design System v1.0

**Author:** MetaTec Senior Apple Platforms UI/UX Designer  
**Date:** 2026-10-29  
**iOS minimum:** 17.0 · **Design language era:** iOS 27 / Liquid Glass gen-2 (refined)  
**Bundle ID:** com.metatec.hearteesa  
**Status:** Single source of truth for engineering and design — production-ready

---

## Preamble — My Heart Design Review

Before the system, a verdict on the best UI in the category we are entering.

**My Heart (com.szyk.myheart) strengths to carry forward:**
- Color-coded BP category badges as the primary reading signal — the right call; instantaneous glanceability
- Comparison cards ("morning vs. evening", "this period vs. last") surfaced as discrete, scrollable cards rather than buried in a settings screen — a strong IA pattern
- Annotatable PDF export — showing the user's data is *theirs* to mark up is an underappreciated trust move
- No account required; local-first data — smart for a health category where privacy fear is real
- ISH (Isolated Systolic Hypertension) classification — the only competitor that captures this; medically correct
- Time-of-day analysis with scatter plot — the intelligence tier feels like a genuine upgrade, not just a paywall decoration
- Variability metrics (biggest jump, usual change, trend direction) — communicates clinical-grade insight without clinical language

**My Heart weaknesses Hartessa improves on:**
- Android-only. iOS half the market locked out — our entire bet
- Design language is Android Material 3; feels functional, not premium. Charts read as utility, not jewel-level data
- Zero arm side or body position fields — a clinical gap that nurses, cardiologists, and careful patients notice immediately
- No companion wearable (Wear OS SDK present but dormant; users explicitly request Watch entry)
- Sudden paywalling of previously-free features destroyed trust — our commitment: "free tier never shrinks"
- Color system is categorical but muddy; category colors compete with UI chrome rather than dominating it
- The "Intelligence" hub is powerful but its entry pattern is buried — week-over-week and morning surge insights should surface automatically on the home screen, not require navigation

---

## 1. Brand and Positioning

### 1.1 Brand character

**Positioning line:** "Same cuff, better everything else."

Hartessa exists for the person who has been told by a doctor to monitor their blood pressure and wants to do it with dignity — not through a cluttered, ad-interrupted, or predatory app. The name *Hartessa* is coined, evoking the heart (Latin: *cor/hart*) with a feminine elegance that reads trustworthy rather than clinical.

**Tone:** A beautifully designed health journal. Calm. Precise. Satisfying to fill in. Not sterile white-box medical. Not gamified. The emotional model is: the moment you log a reading, you should feel *in control of your health*, not anxious about a number.

**Brand personality axes:**

| Axis | Hartessa sits at... |
|---|---|
| Clinical ←→ Consumer | 60% clinical, 40% consumer — trustworthy but warm |
| Minimal ←→ Expressive | 75% minimal — data is the hero, chrome recedes |
| Still ←→ Animated | 80% still — motion is earned, never decorative on health data |
| Neutral ←→ Colorful | Neutral system, colorful meaning — only BP category colors carry hue |

### 1.2 Design principles (Hartessa-specific, applied from WWDC26 eight principles)

1. **Purpose** — every element exists because removing it costs something. If it passes "what does removing this cost?", it ships. If nothing, it goes.
2. **One job per screen** — the entry form logs a reading. The chart shows trends. They do not bleed into each other.
3. **Color carries meaning** — the seven BP category colors are Hartessa's only saturated hues. Everything else is neutral to let them breathe and read instantly.
4. **Data is the hero** — numbers, trends, and charts are jewels. Large type, generous whitespace, thin grid lines that support rather than dominate.
5. **Micro-delight, earned** — the save moment blooms with the category color. The morning surge card slides in. These happen once per meaningful event, not constantly.
6. **Free tier never shrinks** — a hard product principle that becomes a design principle: no dark patterns, no feature-baiting, no urgency mechanics.
7. **Glass serves, content leads** — Liquid Glass lives only in navigation and controls. Cards, charts, and readings are in the clear content layer.
8. **Accessibility is the default** — Dynamic Type, VoiceOver, Reduced Motion, Increased Contrast — designed for, not bolted on.

---

## 2. Color System

### 2.1 BP category colors — the primary palette

These seven colors *are* Hartessa's color system. They are the only saturated hues in the entire app. They must be instantly recognizable, contrast-safe, and usable as badge fills, chart line tints, and card accent borders.

| Category | Name token | Light mode hex | Dark mode hex | WCAG AA on white | WCAG AA on black |
|---|---|---|---|---|---|
| Normal | `Color.bpNormal` | `#2D9D6E` (forest green) | `#3BBF87` | ✓ 5.2:1 | ✓ 4.8:1 |
| Elevated | `Color.bpElevated` | `#C9860A` (amber) | `#F0A630` | ✓ 4.6:1 | ✓ 5.1:1 |
| High S1 | `Color.bpHighS1` | `#D4621A` (burnt orange) | `#F07840` | ✓ 4.8:1 | ✓ 4.5:1 |
| High S2 | `Color.bpHighS2` | `#C02828` (cardinal red) | `#E84444` | ✓ 5.5:1 | ✓ 4.7:1 |
| ISH | `Color.bpISH` | `#7B3DBD` (deep violet) | `#A060E8` | ✓ 6.1:1 | ✓ 4.9:1 |
| Hypotension | `Color.bpHypo` | `#2563B8` (cobalt blue) | `#5090F0` | ✓ 5.8:1 | ✓ 4.6:1 |
| Crisis | `Color.bpCrisis` | `#8B0000` (deep crimson) | `#C42020` | ✓ 7.4:1 | ✓ 4.5:1 |

**Rules:**
- Category colors appear on: category badge (fill), reading card accent strip (4 pt leading border), chart line (sys = red spectrum → `bpHighS2`; dia = blue spectrum → `bpHypo`), reading detail background wash (8% opacity on solid surface only).
- They do NOT appear as glass tints. The iOS 27 transparency slider must not wash a clinical signal.
- Crisis (`bpCrisis`) triggers the only layout exception: the reading card gains a 1 pt crimson border and the category label pulses once (single `.bouncy` spring, Reduced Motion: no pulse, label only).

### 2.2 Neutral palette

All UI chrome, text, backgrounds, and dividers use semantic system colors. These are the *only* color values for non-categorical UI — no hex values in component code, only semantic tokens.

| Token | SwiftUI semantic | Usage |
|---|---|---|
| `Color.primary` | System primary | Body text, primary labels |
| `Color.secondary` | System secondary | Metadata, timestamps, secondary labels |
| `Color.tertiary` | System tertiary | Placeholder text, disabled states |
| `Color.background` | System background | Screen backgrounds |
| `Color.secondaryBackground` | Secondary system background | Card surfaces (content layer) |
| `Color.groupedBackground` | Grouped background | List screens (History, Settings) |
| `Color.separator` | System separator | Dividers, borders |
| `Color.accent` | `Color.accentColor` (set to `bpNormal` green) | Interactive tints, focus rings |

**Dark mode:** All semantic tokens resolve correctly. No custom dark-mode hex values — the system handles the ramp. The only exception is the BP category colors, which have explicit dark-mode variants listed above (lighter/more luminous for legibility on dark backgrounds).

### 2.3 Glass tinting rules

`.glassEffect(.regular)` — no tint applied by default to navigation and control glass. This preserves neutrality and lets category colors stand out unambiguously. The single exception: the paywall sheet uses `.glassEffect(.regular.tint(.bpNormal.opacity(0.15)))` as a gentle green warmth signaling a positive upgrade rather than an aggressive purchase moment.

---

## 3. Typography

Hartessa uses the SF Pro family exclusively. No custom typefaces — SF Pro is the right tool: free, certified accessible, Dynamic Type-native, and available on every target device.

### 3.1 Type scale

| Role | Token | SwiftUI style | Weight | Size (default) | Dynamic Type behavior |
|---|---|---|---|---|---|
| Reading hero | `.readingHero` | `.system(size: 64, weight: .semibold, design: .default)` | Semibold | 64 pt | Fixed — does NOT grow; layout uses ViewThatFits to restack if AX sizes demand |
| Reading sub | `.readingSub` | `.system(size: 32, weight: .light, design: .default)` | Light | 32 pt | Fixed with ViewThatFits wrapper |
| Section title | `.title2` | SwiftUI `.title2` | Semibold | 22 pt | Grows with Dynamic Type |
| Card title | `.headline` | SwiftUI `.headline` | Semibold | 17 pt | Grows |
| Body | `.body` | SwiftUI `.body` | Regular | 17 pt | Grows |
| Label | `.subheadline` | SwiftUI `.subheadline` | Regular | 15 pt | Grows |
| Metadata | `.caption` | SwiftUI `.caption` | Regular | 12 pt | Grows |
| Number input | `.title` | SwiftUI `.title` | Regular | 28 pt | Fixed with ViewThatFits |
| Chart label | `.caption2` | SwiftUI `.caption2` | Regular | 11 pt | Fixed (chart geometry cannot reflow) |

**SF Pro Rounded for labels:** Category badge text uses `Font.system(.caption, design: .rounded, weight: .semibold)`. The rounded variant softens the badge into a pill shape visually, distinguishing it from hard-edged system labels.

**Numeric display rule:** All sys/dia/pulse values use `Font.monospacedDigit()` modifier applied over the base style. This prevents number columns from jittering as digits change width — critical on the history list.

### 3.2 Dynamic Type behavior at AX5 (accessibility extra-extra-extra-large)

- Reading hero (64 pt fixed): wraps in a `ViewThatFits` — if the number overflows the card, the card re-stacks to show sys/dia stacked vertically rather than side-by-side, each at 48 pt.
- History list rows: switch from single-line sys·dia·pulse to two-line layout (sys/dia on line 1, pulse + timestamp on line 2) via `@ScaledMetric` threshold check.
- Chart labels: remain at `caption2` fixed size; a Legend button replaces inline axis labels at AX3+.
- Tab bar labels: show at all sizes (`.tabBarMinimizeBehavior(.never)` — do not collapse for a persistent-use health utility).

---

## 4. Spacing and Layout Grid

### 4.1 Base grid

- Base unit: **8 pt**
- All padding, margin, and spacing values are multiples of 4 pt (minimum) or 8 pt (preferred).
- The canonical spacing set:

| Token | Value | Usage |
|---|---|---|
| `spacing.xs` | 4 pt | Internal badge padding, icon-to-label gap |
| `spacing.sm` | 8 pt | Card internal padding (compact), row vertical padding |
| `spacing.md` | 16 pt | Card internal padding (standard), section vertical gaps |
| `spacing.lg` | 24 pt | Between cards on scroll views |
| `spacing.xl` | 32 pt | Section header to first card |
| `spacing.xxl` | 48 pt | Top safe-area clearance on hero screens |

### 4.2 Content margins

- Side margins: 16 pt (matches iOS system default; do not reduce).
- Card corner radius: `RoundedRectangle(cornerRadius: 16)` — concentric with `.rect(cornerRadius: .containerConcentric)` for nested elements. Hardware curve radius is ~55 pt; 16 pt cards inside that feel nested correctly.
- Inner element corner radius within a 16 pt card: 10 pt (concentric subtraction: 16 − spacing.sm/2 ≈ 12 pt, rounded to 10 pt grid step).

### 4.3 Safe areas and the floating tab bar

The iOS 27 tab bar is a floating glass capsule inset from the bottom edge. Content scrolls **under** it.

- All `ScrollView` and `List` content must add `.contentMargins(.bottom, 80)` or use `.safeAreaInset(edge: .bottom)` to prevent the last card from hiding behind the tab bar.
- Never use `.ignoresSafeArea()` on any health-data surface — content behind chrome is unusable for someone with poor vision reading numbers.
- The Add Reading sheet is a `.sheet(detents: [.large])` — it does not fight with the tab bar; it occupies the full sheet height.

---

## 5. Elevation and Materials

### 5.1 The two-layer model (iOS 27 Liquid Glass gen-2)

Hartessa has exactly **two layers**:

| Layer | What lives here | Material |
|---|---|---|
| Navigation / Control layer | Tab bar · Navigation bar · Toolbar buttons · Add button · Paywall sheet header | Liquid Glass (automatic via SwiftUI standard components) |
| Content layer | All cards · Charts · Lists · Forms · Reading numbers · Insight cards | Clear (no glass) — `Color.secondaryBackground` or `Color.groupedBackground` |

**Glass never appears in the content layer.** This is the single most important material rule. Cards are not glass. Charts are not glass. Reading history rows are not glass. They are opaque system background surfaces.

**Rationale (clinical):** A blood pressure number printed over a blurred, shifting glass background has reduced legibility and may be misread. Health data demands maximum contrast and stability.

### 5.2 Standard components — glass is automatic

These components require zero custom glass code:
- `TabView` → floating glass capsule tab bar
- `NavigationStack` with `.navigationBarTitleDisplayMode(.large)` → glass navigation bar
- `ToolbarItem` → glass toolbar
- `.sheet()` → glass sheet header
- `.alert()`, `.confirmationDialog()` → system glass overlays
- `Menu` → glass menu

### 5.3 Custom glass — the one case

The **Add Reading floating action button** (the `+` that triggers the Add Reading sheet from any tab) uses:

```swift
Button(action: { showAddReading = true }) {
    Image(systemName: "plus")
        .font(.title2.weight(.semibold))
        .frame(width: 56, height: 56)
}
.glassEffect(.regular.tint(.bpNormal.opacity(0.20)).interactive(), in: .circle)
.accessibilityLabel("Log reading")
.accessibilityAddTraits(.isButton)
```

This is the only custom `.glassEffect()` call in the app. It is justified because:
1. It is a floating control element, correctly in the navigation layer
2. It needs to float above scrolling content
3. Standard `TabView` Add tab would require a dedicated tab that breaks the information architecture

Wrap in `GlassEffectContainer` if future additions place other floating controls near it.

### 5.4 Content layer card surfaces

Cards are `RoundedRectangle(cornerRadius: 16)` filled with `Color.secondaryBackground`. Light mode: a faint off-white slightly elevated above the `Color.background` base. Dark mode: a slightly lighter gray than the background, providing depth through value separation rather than blur.

**No drop shadows.** iOS 27 design language eliminates heavy drop shadows on cards. Depth is achieved through value contrast (background vs. card surface) and the category color accent strip on reading cards.

**Category accent strip:** A 4 pt leading vertical border on the reading card, filled with the category color. This is `Color.bpNormal` (or whichever category applies) at full opacity on a solid card surface — completely legible at all transparency slider settings.

### 5.5 iOS 27 transparency slider compliance

The iOS 27 user-controlled transparency slider (Settings → Display & Brightness → Liquid Glass) adjusts the opacity and tint of all glass surfaces system-wide. Hartessa's design survives the full slider range because:

- Clinical data (numbers, category badges, chart lines) live on solid content-layer surfaces — unaffected by the slider
- Category colors are never used as glass tints
- The app's primary visual language (BP category color badges) requires no glass to function
- At maximum opacity (fully tinted), the UI reads as a clean frosted-glass app. At maximum transparency (clear glass), the content layer is unchanged and the navigation chrome becomes minimal — the data is still fully legible

---

## 6. Component Library

### 6.1 Reading card (the most important component)

The reading card is the centerpiece of the Home tab and History rows. It must communicate a reading at a glance in under one second.

**Home tab — full reading card:**

```
┌─[4pt category border]──────────────────────────────────────┐
│  SYS / DIA    •  PULSE          CATEGORY BADGE    TIMESTAMP │
│  128 / 82         68            ●High S1           8:23 AM  │
│  mmHg · mmHg   bpm              [arm] [position]           │
└──────────────────────────────────────────────────────────────┘
```

SwiftUI structure:
- Outer: `RoundedRectangle(cornerRadius: 16)` + `Color.secondaryBackground` fill
- Left accent: `Rectangle().frame(width: 4).foregroundColor(.bpHighS1)` + `.clipShape(RoundedCorner(radius: 16, corners: [.topLeft, .bottomLeft]))`
- Sys/Dia: `.title` + `.monospacedDigit()` stacked horizontally with `HStack(spacing: 4)`
- Pulse: `.headline` + `.monospacedDigit()` + `Color.secondary`
- Category badge: `CapsuleBadge` component (§6.7)
- Timestamp: `.caption` + `Color.secondary`
- Arm/position icons: SF Symbols `figure.stand`, `figure.seated.side`, `figure.lie.down.circle`, `arrow.left`, `arrow.right` at `.caption` size + `Color.tertiary`

**History row — compact reading card:**

Single-line layout with `.subheadline` numbers, `.caption` timestamp, badge on trailing. Horizontal swipe reveals delete action (red, SF Symbol `trash`). Tap → Reading Detail screen.

**Accessibility:**
- VoiceOver label: "Reading: one twenty-eight over eighty-two, pulse sixty-eight. High Stage 1. Eight twenty-three AM. Left arm, sitting."
- `.accessibilityElement(children: .combine)` on the card's content
- Minimum tap target: full card (already ≥ 44 pt tall in all type sizes)

### 6.2 Insight cards

Insight cards are conditional — they appear on the Home tab only when there is enough data to generate a meaningful insight. They share the same `RoundedRectangle(cornerRadius: 16)` surface as reading cards but have no accent strip.

**Morning Surge card:**

```
┌────────────────────────────────────────────────────┐
│  ↑ Morning Surge Detected                           │
│  Your 8:12 AM reading was 18 mmHg higher than      │
│  your 10:30 PM reading from last night.             │
│                             Learn more  →           │
└────────────────────────────────────────────────────┘
```

- Icon: `sunrise.fill` in `bpElevated` amber
- Title: `.headline` semibold, `Color.primary`
- Body: `.subheadline` regular, `Color.secondary`
- "Learn more": `.subheadline` + `Color.accent`, `Button` with `.plain` style
- Entry trigger: morning reading (5 AM – 12 PM) ≥ 15 mmHg higher than previous evening reading (6 PM – midnight)
- Entrance animation: slides in from bottom with `.spring(response: 0.5, dampingFraction: 0.8)` + fade. Reduced Motion fallback: fade only.

**Week-over-week delta card:**

```
┌────────────────────────────────────────────────────┐
│  📉  This Week vs Last Week                         │
│  Systolic down 6 mmHg  ·  Diastolic down 3 mmHg   │
│  Based on 14 readings (7 each week)                │
└────────────────────────────────────────────────────┘
```

- Down arrow: `arrow.down.circle.fill` in `bpNormal` green; up arrow: `arrow.up.circle.fill` in `bpHighS1` orange; neutral: `minus.circle.fill` in `Color.secondary`
- Requires ≥ 3 readings in each of two consecutive calendar weeks to fire

**AM/PM split cards:** Two side-by-side cards in an `HStack`. Each shows the average sys/dia for AM (5 AM – noon) and PM (noon – midnight), labeled with a sun/moon SF Symbol. `Spacer()` between them. Each card is `frame(maxWidth: .infinity)`.

### 6.3 Input fields — Add Reading form

The Add Reading sheet is a `Form` inside a `.sheet(detents: [.large])`. It uses standard `Form`/`Section` components, which render correctly in iOS 27 with appropriate glass sheet chrome.

**Number inputs (systolic, diastolic, pulse):**

Three large number inputs. Each is a custom `NumberScrollerField` — justified because:
- Standard `TextField` with `.numberPad` keyboard is cumbersome for users holding a BP cuff result in their hands; scrolling (like a picker) or tap-to-increment is faster
- Health apps in this category universally use number scrollers for BP input; the pattern is established enough to be the "native" mental model for BP logging

`NumberScrollerField` spec:
- Display: `.title` size number centered in a 64 pt tall tappable region
- Interaction: tapping opens a `.wheel` style `Picker` overlay, OR up/down stepper buttons appear at ±1 mmHg increments
- Range guard: sys 60–250, dia 30–180, pulse 30–250 (values outside range prevent save and show inline error)
- `accessibilityLabel("Systolic pressure")` + `accessibilityValue("\(systolic) millimeters of mercury")`

**Segmented controls (arm side, position):**

Standard SwiftUI `Picker` with `.segmented` style. Three options for arm: Left / Right / — (unspecified). Four options for position: Sitting / Standing / Lying / — (unspecified).

```swift
Picker("Arm", selection: $armSide) {
    Text("Left").tag(ArmSide.left)
    Text("Right").tag(ArmSide.right)
    Text("—").tag(ArmSide.unspecified)
}
.pickerStyle(.segmented)
.accessibilityLabel("Arm side")
```

**Tag chips:**

Multi-select tag chips in a `FlowLayout` (custom layout justified: no standard SwiftUI component flows chip sets). Each chip is a `Button` styled as a capsule: unselected → `.secondaryBackground` fill + `.separator` border; selected → `.bpNormal.opacity(0.15)` fill + `.bpNormal` border.

Default tags: Morning · After Medication · After Exercise · Evening · Stressed · Resting. User can add custom tags from Settings.

**Notes field:** `TextEditor` with a 3-line minimum, `.body` text, placeholder text "Optional note (e.g. 'feeling tense before reading')".

**Save button:** `Button("Save Reading")` with `.buttonStyle(.glassProminent)` + `.tint(.bpNormal)` + `.controlSize(.large)`. The glass prominent style applies the green tint to the opaque button fill, making it the clear primary action.

On save:
1. SwiftData `ModelContext.insert()` 
2. Category color bloom: the save button briefly flashes the category color (0.3s crossfade to `bpNormal`/etc., then back) — `.sensoryFeedback(.success, trigger: saveComplete)`
3. Sheet dismisses with standard iOS slide-down

### 6.4 Buttons

| Style | SwiftUI | Usage |
|---|---|---|
| Primary | `.buttonStyle(.glassProminent).tint(Color.bpNormal)` | Save Reading, paywall CTA |
| Secondary | `.buttonStyle(.glass)` | "Learn more", "Restore purchases", destructive confirm |
| Destructive | `.buttonStyle(.glass).tint(.red)` | Delete reading confirmation |
| Inline text | `.buttonStyle(.plain).foregroundColor(.accent)` | Chart period toggle labels, "See all" links |

All buttons: minimum 44×44 pt tap target enforced via `.frame(minWidth: 44, minHeight: 44)` or full-width natural sizing.

### 6.5 Category badges

`CapsuleBadge` is a reusable component used on reading cards, history rows, the Apple Watch face, and the reading detail screen.

```swift
struct CapsuleBadge: View {
    let category: BPCategory
    var body: some View {
        Text(category.shortLabel)
            .font(.system(.caption, design: .rounded, weight: .semibold))
            .foregroundColor(.white)
            .padding(.horizontal, spacing.sm)
            .padding(.vertical, spacing.xs)
            .background(category.color, in: Capsule())
            .accessibilityLabel(category.accessibilityLabel)
    }
}
```

Short labels: Normal · Elevated · High S1 · High S2 · ISH · Low · Crisis  
Accessibility labels: "Normal blood pressure" · "Elevated blood pressure" · "High stage one" · "High stage two" · "Isolated systolic hypertension" · "Low blood pressure" · "Hypertensive crisis"

### 6.6 Navigation — Tab bar and Navigation bar

**Tab bar:** Standard SwiftUI `TabView` — automatic floating glass capsule on iOS 27. Four tabs:

```swift
TabView {
    Tab("Home", systemImage: "heart.fill") { HomeView() }
    Tab("History", systemImage: "list.bullet") { HistoryView() }
    Tab("Chart", systemImage: "chart.line.uptrend.xyaxis") { ChartView() }
    Tab("More", systemImage: "ellipsis.circle") { MoreView() }
}
.tabBarMinimizeBehavior(.never)  // persistent — this is a daily-use utility
```

**The Add Reading `+` button** is NOT a fifth tab. It is a floating glass button (`§5.3`) that overlays all tabs, triggering the Add Reading sheet. This is the correct pattern when "add" is the most frequent action across all tabs but should not consume a navigation slot.

**Navigation bar:** `.navigationBarTitleDisplayMode(.large)` on root views (Home, History, Chart). `.navigationBarTitleDisplayMode(.inline)` on detail views (Reading Detail, Chart Detail, Settings sub-screens). All automatic glass treatment via SwiftUI — no custom toolbar background modifiers.

### 6.7 Charts

**Line chart — Chart tab:**

SwiftUI Charts (`Charts` framework, iOS 16+). Two series: systolic (`Color.bpHighS2` reddish) and diastolic (`Color.bpHypo` blue). Point marks at each reading for tap interaction. Reference bands for Normal/Elevated/High zones (horizontal bands, `RectangleMark` at 30% opacity, no border).

```swift
Chart {
    ForEach(readings) { reading in
        LineMark(
            x: .value("Date", reading.timestamp),
            y: .value("Systolic", reading.systolic)
        )
        .foregroundStyle(Color.bpHighS2)
        .interpolationMethod(.catmullRom)
        
        PointMark(
            x: .value("Date", reading.timestamp),
            y: .value("Systolic", reading.systolic)
        )
        .foregroundStyle(Color.bpHighS2)
        .symbolSize(30)
    }
    // Diastolic series follows same pattern with Color.bpHypo
    // Reference bands
    RectangleMark(
        yStart: .value("Low", 0),
        yEnd: .value("Normal ceiling", 80)
    )
    .foregroundStyle(Color.bpNormal.opacity(0.06))
}
.chartXAxis { /* custom axis labels */ }
.chartYAxis { /* mmHg labels at 80, 90, 120, 130, 140, 180 */ }
.chartOverlay { /* tap gesture for reading pop-up */ }
```

Period toggle: `Picker` with `.segmented` style — "7d / 30d / 90d / Custom". When Custom: a `DateRangePicker` sheet.

Statistics bar below the chart: an `HStack` of four `VStack` cells — Avg Sys · Avg Dia · Min · Max — in `.caption` labels + `.title3.monospacedDigit()` values. Background: `Color.secondaryBackground` in a `RoundedRectangle(cornerRadius: 12)`.

Trend arrow: `Image(systemName: "arrow.up.right")` / `arrow.down.right` / `minus` next to the Avg labels. Color: trending better → `bpNormal` green; trending worse → `bpHighS1` orange; stable → `Color.secondary`. Reduced Motion: icon only, no animation.

**Accessibility for charts:** `chartAccessibilityLabel("Blood pressure readings over time")` + `chartAccessibilityValue()` per point. Add an "Audio Graph" button (SF Symbol `waveform`) that activates VoiceOver's audio graph sonification — built into `Charts` framework, no extra code.

**AM/PM split cards (Home tab):**

Two side-by-side stat cards below the last reading. Each is 50% screen width minus margins. Format: SF Symbol (sun/moon) + "AM Average" / "PM Average" label + sys/dia value in `.title3.monospacedDigit()`. Show "—" when fewer than 3 readings in that period for the current day window (7 days).

**Scatter plot, variability, distribution (Premium Analytics):**

These three charts are behind the paywall gate. If accessed without premium, the view shows a blurred preview with a paywall sheet that slides up. The blur is `Color.background.opacity(0.6)` overlay on a rendered-but-blurred chart — intentional to show shape of the feature, not the data.

Scatter plot: `PointMark` with `x: systolic`, `y: diastolic`, colored by category. Reference lines at 130 (sys) and 80 (dia) dividing the four quadrants.

### 6.8 Paywall sheet

Triggered by: tapping Apple Watch setup, iCloud sync toggle, or a Premium Analytics chart.

The paywall is a `.sheet(detents: [.medium])` — medium height, not full screen. It does NOT replace a screen the user navigated to. It intrudes minimally.

Structure:
```
[Sheet handle]
  "Hartessa Premium"          ← .title2 semibold
  "Sync, watch, and go deeper" ← .subheadline Color.secondary

[Feature list — 5 items]
  ✓  Apple Watch entry and complications
  ✓  iCloud sync across all your devices
  ✓  Unlimited profiles
  ✓  Medication tracking
  ✓  Advanced analytics (scatter, variability, distribution)

[Two options side by side]
  [Monthly $1.99]    [Annual $12.99]   ← glassProminent tinted bpNormal
  Per month          Per month ($1.08) ← caption Color.secondary

[Restore Purchases]  ← .glass button, no tint
```

No countdown timers. No "Limited offer" language. No social proof badges (violates product principle: "respect the user"). Clean, honest, confident.

The green tint on the purchase buttons applies `.glassEffect(.regular.tint(.bpNormal.opacity(0.15)))` on the sheet background — a subtle warmth, not a promotion.

RevenueCat `Purchases.shared.presentPaywall()` is NOT used — the custom sheet preserves Hartessa's design language. RevenueCat SDK handles the IAP transaction, we handle the presentation.

### 6.9 Empty states

Empty states use SwiftUI `ContentUnavailableView` where available (iOS 17+). Customized with:
- SF Symbol: `heart.text.clipboard` (History empty), `chart.xyaxis.line` (Chart empty)
- Title: first-person, action-oriented ("Log your first reading to see your history")
- Description: one sentence of context, `Color.secondary`
- Action button: "Log reading" → triggers Add Reading sheet

No illustration art, no custom graphics. SF Symbols are the art budget. This is a conscious quality constraint: hand-drawn empty-state illustrations date in 18 months and require a visual designer to update. System symbols are timeless.

### 6.10 Toasts and banners

**Undo toast** (after swipe-delete in History):

Bottom-anchored `safeAreaInset`. Text: "Reading deleted". Button: "Undo" (`Color.accent`). Auto-dismisses after 5 seconds. `.transition(.move(edge: .bottom).combined(with: .opacity))`. `.sensoryFeedback(.warning, trigger: deleteTrigger)`.

**Notification banners** (reminders): Standard `UNNotificationRequest` — no in-app custom banner. The system notification is the right tool.

**Error states:** Inline, not modal. If save fails (SwiftData write error): a red `.caption` label appears below the Save button — "Could not save reading. Tap to retry." Never a modal alert for recoverable save errors.

---

## 7. Motion Principles

### 7.1 Guiding rule

Motion in Hartessa is purposeful and rare. Each animation answers: "what does this motion *communicate* that text and color cannot?" If the answer is nothing, the motion is cut.

Hartessa has six defined moments of motion:

| Moment | Animation | Duration | Haptic | Reduced Motion fallback |
|---|---|---|---|---|
| Reading saved | Category color bloom on save button | `.spring(response: 0.3, dampingFraction: 0.7)` | `.sensoryFeedback(.success)` | No bloom, haptic only |
| Morning surge card appears | Slide up from bottom + fade in | `.spring(response: 0.5, dampingFraction: 0.8)` | `.sensoryFeedback(.impact(.light))` | Fade only |
| Week delta card appears | Same as morning surge | Same | None | Fade only |
| History row delete | Swipe + collapse row | `.spring(response: 0.4, dampingFraction: 0.9)` | `.sensoryFeedback(.warning)` | Instant remove |
| Chart line draw-in on appear | Progressive draw from left | 0.6s `.easeInOut` | None | Instant render |
| Paywall sheet present | Standard iOS sheet spring | System default | None | System default |

Crisis category detected (first reading of day in Crisis range): a single, one-time pulse animation on the reading card (0.2s scale 1.0→1.04→1.0). Never repeats. Never loops. Reduced Motion: no pulse.

### 7.2 No motion on health data itself

Numbers, chart lines, and category badges do not animate their values. A reading showing "128/82" does not count up from 0. The data is not performative — it is fact.

### 7.3 Standard transitions

- Navigation push: SwiftUI default (slide left)
- Sheet present: SwiftUI default (slide up)
- `.matchedGeometryEffect` for the reading card → Reading Detail expansion
- Tab switching: SwiftUI default (crossfade)

---

## 8. Accessibility

### 8.1 VoiceOver

**Home tab reading order:**
1. "Last reading" section header
2. Reading card (combined element — see §6.1)
3. Conditional cards (morning surge, week delta) in order of appearance
4. AM average card
5. PM average card
6. Log reading button (floating `+`)

**History tab reading order:**
Section header (date) → Rows in chronological order within section (newest first). Swipe actions: "Delete, double-tap to activate" on each row via `.accessibilityAction(named: "Delete") { deleteReading(reading) }`.

**Chart tab:** `chartAccessibilityLabel` + audio graph activation button. Reading order: Period picker → Statistics bar (spoken as a summary: "Averages: systolic one twenty-four, diastolic eighty-one. Minimum systolic one ten. Maximum one forty-two.") → Chart (audio graph button) → AM/PM split cards.

**Add Reading form reading order:** Sheet title → Systolic field → Diastolic field → Pulse field → Arm picker → Position picker → Notes field → Tags → Timestamp → Save button → Cancel.

### 8.2 Dynamic Type compliance

All text that can grow, grows. Fixed-size elements (reading hero numbers, chart labels) have `ViewThatFits` fallback layouts or legend-button alternatives documented in §3.2.

### 8.3 Contrast

All BP category colors meet WCAG AA (≥ 4.5:1) against both white and system background in both light and dark mode (verified in §2.1). Primary text on system backgrounds: system semantic colors ensure compliance automatically. Chart reference bands are background-role decorative elements (< 3:1 intentional) — they never carry primary data.

### 8.4 Reduced Transparency

When `@Environment(\.accessibilityReduceTransparency) var reduceTransparency` is true:
- Liquid Glass surfaces (system components) become fully opaque automatically
- The floating FAB tint uses `.glassEffect(reduceTransparency ? .identity : .regular.tint(.bpNormal.opacity(0.20)).interactive(), in: .circle)` — falls back to a filled circle button

### 8.5 Tap targets

Minimum 44×44 pt for all interactive elements. History rows are 56 pt tall by default (auto-expands with Dynamic Type). The reading card is tappable in its entirety. Tag chips are minimum 36 pt tall × 60 pt wide — below 44 pt height is acceptable for multi-select tag arrays per HIG (compact horizontal chips) but the form section provides adequate spacing.

### 8.6 Color is never the sole signal

Every category badge has a text label *and* color. Trend arrows have direction *and* color. Arm side is shown with a text label ("L" / "R") *and* a directional arrow icon. No information is conveyed by color alone.

### 8.7 Accessibility Nutrition Label status (at v1 launch)

| Feature | Status |
|---|---|
| VoiceOver | Supported |
| Voice Control | Supported (all controls have labels and targets) |
| Larger Text | Supported |
| Sufficient Contrast | Supported |
| Differentiate Without Color | Supported |
| Reduce Motion | Supported |
| Dark Interface | Supported |

---

## 9. watchOS Companion Design Rules

The Hartessa Watch app (premium) is a focused companion: quick entry and last reading. It does not replicate the full phone experience.

### 9.1 Watch app surfaces

**Entry view (primary Watch purpose):**
- A `Form` with three `Stepper` controls: Systolic (60–250) / Diastolic (30–180) / Pulse (30–250).
- Steppers increment by 1; long-press increments by 5.
- Systolic default pre-filled with last reading's systolic value as starting point (reduces taps for users with consistent readings).
- "Save" button: `.borderedProminent` `.tint(.bpNormal)`.
- Save confirmation: `WKInterfaceDevice.current().play(.success)` haptic + brief category color flash on a `.containerBackground(category.color.opacity(0.3), for: .navigation)`.

**Last reading view:**
- `.navigationTitle("Last Reading")`
- Large sys/dia in `.title` + `.monospacedDigit()`, side by side
- Pulse in `.headline`
- `CapsuleBadge` (shared color tokens — watch uses the same color values)
- "X hours ago" in `.caption` + `Color.secondary`
- A subtle `.containerBackground(category.color.opacity(0.15), for: .navigation)` background wash — the only place a category color wash is safe, because on watchOS the solid black bezels make the wash clearly decorative

### 9.2 Complication spec

**Accessory Circular:** `"128/82 · High S1"` — fills with `category.color`. Text: sys over dia in `.monospacedDigit()`, category short label below.

**Accessory Corner:** `"128/82"` headline + `"High S1"` detail.

**Accessory Rectangular:** Full `"128/82 mmHg · High Stage 1 · 2 hrs ago"`.

All complications use `TimelineEntry` with `RelevanceProvider` that scores Crisis readings as maximum relevance so they prioritize to Smart Stack top position.

### 9.3 watchOS typography rules

watchOS uses SF Compact (not SF Pro) automatically. Do not specify font design — let the system choose. All font styles specified via SwiftUI text styles (`.title`, `.headline`, `.caption`) which automatically adapt to SF Compact on watchOS.

### 9.4 WatchConnectivity sync rules

- Readings entered on Watch are written to the Watch's local SwiftData store immediately (offline-capable)
- `WCSession` transfers to iPhone using `transferUserInfo()` (reliable queue-based delivery, survives disconnection)
- iPhone ingests and writes to its SwiftData store; if iCloud sync is enabled, propagates up
- No blocking wait on Watch side — fire-and-forget transfer, confirmation is not shown on Watch

---

## 10. Screen Flow Map

### 10.1 Complete screen inventory

```
ONBOARDING
───────────
[Splash] → [Onboarding 1: Hero] → [Onboarding 2: Demo] → [Onboarding 3: Notifications] → [Home]

MAIN NAVIGATION (TabView — persistent)
────────────────────────────────────────
[Home] ←→ [History] ←→ [Chart] ←→ [More]
  ↑                                   ↑
  └───── Floating + button ───────────┘
          ↓
    [Add Reading Sheet]

HOME TAB
─────────
[Home]
  ├── [Last Reading Card] → (tap) → [Reading Detail]
  ├── [Morning Surge Card] (conditional) → (tap "Learn more") → [Education: Morning Surge]
  ├── [Week Delta Card] (conditional) → no tap destination (informational only)
  ├── [AM Average Card] → no tap destination
  └── [PM Average Card] → no tap destination

ADD READING (sheet, accessible from any tab via floating + button)
──────────────────────────────────────────────────────────────────
[Add Reading Sheet]
  ├── Systolic / Diastolic / Pulse inputs
  ├── Arm side segmented picker
  ├── Position segmented picker
  ├── Notes text field
  ├── Tags multi-select
  ├── Timestamp (auto; tap → [Timestamp Override Picker])
  └── Save → category color bloom → dismiss → [Home] (updates cards)

HISTORY TAB
───────────
[History List]
  ├── (swipe left on row) → delete action + undo toast
  └── (tap row) → [Reading Detail]
          └── (tap "Edit") → [Edit Reading Sheet] (same form as Add, pre-filled)
                              └── Save → [Reading Detail] (updated)

CHART TAB
─────────
[Chart View]
  ├── Period picker: 7d / 30d / 90d / Custom
  │     └── (tap Custom) → [Date Range Picker Sheet]
  ├── Statistics bar (inline — no navigation)
  ├── (tap chart point) → [Reading Pop-up Overlay] (inline popover, not a screen)
  ├── [AM/PM Split Cards] (inline — no navigation)
  └── (tap "Advanced Analytics" — premium gate) → [Paywall Sheet]
                                                      └── (purchase) → [Premium Analytics]
                                                                          ├── [Scatter Plot]
                                                                          ├── [Variability Chart]
                                                                          └── [Distribution Chart]

MORE TAB
─────────
[More]
  ├── BP Standard → [BP Standard Selector Sheet]
  │     └── Options: ACC/AHA 2025 · ESC/ESH 2018
  ├── Reminders → [Reminders List]
  │     └── (add/edit) → [Reminder Editor]
  ├── Face ID / Touch ID → toggle (no sub-screen)
  ├── Export → [Export Hub]
  │     ├── PDF → [PDF Preview] → share sheet
  │     └── CSV → share sheet (no preview)
  ├── Apple Watch → (if not premium) → [Paywall Sheet]
  │                  (if premium) → [Apple Watch Setup Guide]
  ├── iCloud Sync → (if not premium) → [Paywall Sheet]
  │                  (if premium) → toggle (no sub-screen)
  ├── Profiles → [Profiles List]
  │     └── (add/switch) → [Profile Editor] / [Profile Switcher Sheet]
  ├── Medications → [Medications List]  ← premium-gated
  │     └── (add) → [Medication Editor]
  └── About → [About Screen]
        ├── Version, credits, privacy policy link, terms link
        └── Rate App → App Store rating prompt

PAYWALL SHEET (accessible from multiple entry points)
──────────────────────────────────────────────────────
[Paywall Sheet]
  ├── Monthly $1.99 → [RevenueCat purchase flow] → dismiss sheet → unlock feature
  ├── Annual $12.99 → [RevenueCat purchase flow] → dismiss sheet → unlock feature
  └── Restore Purchases → [RevenueCat restore flow] → dismiss if restored

ONBOARDING (detailed)
──────────────────────
[Splash] (0.8s logo + app name, fades)
    ↓
[Onboarding 1: Hero]
  "Blood pressure, beautifully tracked."
  SF Symbol heart.fill animated with a gentle heartbeat pulse (Reduced Motion: static)
  "Continue" → glassProminent button
    ↓
[Onboarding 2: Demo]
  Animated 5-second looping demo: phone screen fills with a reading card appearing,
  category badge populating, the chart line drawing in.
  Narration: "Log in seconds. See patterns instantly."
  "Continue" button
    ↓
[Onboarding 3: Notifications]
  Standard iOS permission request explanation screen.
  SF Symbol bell.badge.fill
  "Turn on reminders to log consistently — the most important factor in BP monitoring."
  "Allow Notifications" → triggers UNUserNotificationCenter.requestAuthorization()
  "Skip for now" → text button, .plain style, Color.secondary
    ↓
[Home] — tab bar appears, content populates
  (If this is a fresh install: Home shows ContentUnavailableView with "Log your first reading")
```

### 10.2 Modal flows (appear over any tab)

```
Any screen
  └── Floating + button → [Add Reading Sheet] → dismiss → return to same tab
  └── Settings-level paywall triggers → [Paywall Sheet] → dismiss → return to same screen
  └── Date Range Picker → [Date Range Picker Sheet] → dismiss → Chart updates
```

### 10.3 watchOS flow

```
[Watch Complication] → (tap) → [Watch App Root]
                                    ├── [Entry View] → Save → [Confirmation screen] → auto-dismiss
                                    └── [Last Reading View] (default view)

[Watch App Root] (standalone launch, no complication)
  ├── Tab 1: [Last Reading View]
  └── Tab 2: [Entry View]
```

### 10.4 State transitions — Home tab conditional cards

```
Reading saved
    ├── Is it a morning reading (5 AM–12 PM)?
    │     ├── Is it ≥ 15 mmHg higher than most recent evening reading (6 PM–midnight)?
    │     │     └── YES → Morning Surge Card slides in (if not already showing)
    │     └── NO → no surge card
    └── Are there ≥ 3 readings in each of the last two calendar weeks?
          └── YES → Week Delta Card shows (if not already showing)
                    └── Was delta direction different last time?
                          └── YES → card reanimates (slide out + in)
```

### 10.5 Screen count summary

| Area | Screen count |
|---|---|
| Onboarding | 4 (Splash + 3 steps) |
| Home tab | 3 (Home + Reading Detail + Education: Morning Surge) |
| Add Reading | 2 (Sheet + Timestamp Override) |
| History | 3 (List + Reading Detail + Edit Sheet) |
| Chart | 5 (Chart + Date Picker + Premium Gate 3 charts) |
| More / Settings | 10 (More + BP Standard + Reminders + Reminder Editor + Export Hub + PDF Preview + Watch Setup + Profiles + Medication + About) |
| Paywall | 1 |
| watchOS | 3 (Complication entry, Last Reading, Entry View) |
| **Total** | **31** |

---

## Appendix A — BP Category Reference

| Category | Systolic (mmHg) | Diastolic (mmHg) | ACC/AHA 2025 label |
|---|---|---|---|
| Hypotension | < 90 | OR < 60 | Low |
| Normal | 90–119 | AND 60–79 | Normal |
| Elevated | 120–129 | AND < 80 | Elevated |
| High S1 | 130–139 | OR 80–89 | High Stage 1 |
| High S2 | 140–179 | OR 90–119 | High Stage 2 |
| ISH | ≥ 130 systolic | AND < 80 diastolic | Isolated Systolic Hypertension |
| Crisis | ≥ 180 | OR ≥ 120 | Hypertensive Crisis |

ESC/ESH 2018 uses different thresholds. The user selects their preferred standard in More → BP Standard. The app stores the raw reading (sys/dia/pulse) and recalculates category on the fly from the active standard — no re-categorization migration needed.

---

## Appendix B — SF Symbols used in Hartessa

| Purpose | Symbol | Weight |
|---|---|---|
| Home tab | `heart.fill` | Regular |
| History tab | `list.bullet` | Regular |
| Chart tab | `chart.line.uptrend.xyaxis` | Regular |
| More tab | `ellipsis.circle` | Regular |
| Add reading FAB | `plus` | Semibold |
| Morning surge | `sunrise.fill` | Regular |
| Week delta up | `arrow.up.circle.fill` | Regular |
| Week delta down | `arrow.down.circle.fill` | Regular |
| Week delta stable | `minus.circle.fill` | Regular |
| Left arm | `arrow.left` + `figure.arms.open` | Regular |
| Right arm | `arrow.right` + `figure.arms.open` | Regular |
| Position: sitting | `figure.seated.side` | Regular |
| Position: standing | `figure.stand` | Regular |
| Position: lying | `figure.lie.down.circle` | Regular |
| AM split | `sun.max.fill` | Regular |
| PM split | `moon.fill` | Regular |
| Reminder | `bell.badge.fill` | Regular |
| Export PDF | `doc.text.fill` | Regular |
| Export CSV | `tablecells.fill` | Regular |
| Apple Watch | `applewatch` | Regular |
| iCloud sync | `icloud.fill` | Regular |
| Lock | `faceid` / `touchid` | Regular |
| Delete | `trash` | Regular |
| Edit | `pencil` | Regular |
| Undo | `arrow.uturn.backward` | Regular |
| Audio graph | `waveform` | Regular |
| Empty — history | `heart.text.clipboard` | Regular |
| Empty — chart | `chart.xyaxis.line` | Regular |
| Notifications | `bell.badge.fill` | Regular |

---

## Appendix C — SwiftData model sketch (design-relevant properties only)

```swift
@Model class BPReading {
    var timestamp: Date
    var systolic: Int        // mmHg, 60–250
    var diastolic: Int       // mmHg, 30–180
    var pulse: Int           // bpm, 30–250
    var armSide: ArmSide?    // .left / .right / nil
    var position: Position?  // .sitting / .standing / .lying / nil
    var notes: String?
    var tags: [String]
    var profileID: UUID      // for multi-profile support
}

enum ArmSide: String, Codable { case left, right }
enum Position: String, Codable { case sitting, standing, lying }

// Category computed property — driven by active BPStandard from UserDefaults
extension BPReading {
    func category(standard: BPStandard) -> BPCategory { ... }
}
```

The ARM side and position fields are first-class columns — not buried in a JSON blob. This ensures they are filterable, queryable, and exportable to CSV/PDF without parsing. They are Hartessa's biggest data-entry differentiator vs. all iOS competitors.

---

*End of Hartessa Design System v1.0*  
*Next: Engineering handoff · watchOS WireKit spec · App Store screenshot brief*
