# Hearteesa — Blood Pressure Log

> The blood pressure logger that respects you — free PDF, no onboarding paywall, no ads.

A premium, frictionless, cross-platform blood pressure tracker for iOS (Android to follow). Built by MetaTec as the company's highest-scoring next-app candidate (Core-4: 16.5/20, grand total 33.5/40 across a 6-session market scan).

**App Store target:** "blood pressure app" — 3/5 Apple Ads score, 273k rating-mass, no dominant incumbent.

---

## Key differentiators vs. SmartBP / My Heart / Health Tracker

| What competitors do | What Hearteesa does |
|---|---|
| SmartBP charges $40/year for PDF export | PDF always free |
| SmartBP gates Apple Watch behind $40/year | Apple Watch in a fair premium ($1.99/mo) |
| SmartBP shows paywall at step 4 of 24-step onboarding | Zero paywall in onboarding |
| Health Tracker: ad every minute, unskippable | Zero ads |
| None capture arm side or body position | Both included as first-class entry fields |
| None detect morning surge automatically | Morning surge card on home screen |
| My Heart: unencrypted local DB | Encrypted SwiftData storage |

---

## Sprint Roadmap

| Sprint | Goal | Days | Status |
|---|---|---|---|
| Sprint 0 | Foundations — Xcode project, data model, Firebase, RevenueCat skeleton | 1–5 | 🔜 Planned |
| Sprint 1 | Core loop — log reading, history list, basic chart, HealthKit, reminders | 6–14 | 🔜 Planned |
| Sprint 2 | Polish + paywall — onboarding, dual BP standards, free PDF, RevenueCat paywall, Apple Watch | 15–22 | 🔜 Planned |
| Sprint 3 | Release prep — store assets, TestFlight, App Review hardening | 23–28 | 🔜 Planned |

**Target:** TestFlight build by Day 28 from kickoff.

---

## Research & Planning

Full competitor teardown, master feature list, and detailed sprint plan with user stories and acceptance criteria:

→ [`docs/teardown-and-plan.md`](docs/teardown-and-plan.md)

---

## Tech Stack

- **iOS:** SwiftUI · SwiftData · WidgetKit · HealthKit · WatchKit
- **Backend:** Firebase Firestore (optional sync, premium)
- **Monetization:** RevenueCat — two tiers only: $1.99/month · $12.99/year
- **Bundle ID:** com.heartessa.app
- **Team ID:** 9F2G8CQ45J
- **Min deployment:** iOS 17.0

---

## Freemium Model

**Free forever:** unlimited readings · all entry fields (incl. arm side + body position) · charts · PDF export · HealthKit sync · reminders · zero ads  
**Premium:** Apple Watch · iCloud sync · unlimited profiles · medication tracking · advanced analytics

---

*MetaTec · metatec.dubai@gmail.com · 2026*
