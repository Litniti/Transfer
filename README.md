# TransferApp

A portfolio-quality SwiftUI banking application for creating transfers, reviewing activity, and managing a personal account — built with MVVM, clean architecture, and modern UI/UX.

## Features

### Dashboard (default tab)
- Balance card with gradient styling
- Monthly transfer count, total sent, and activity stats
- Monthly activity chart (Swift Charts)
- Recent transfers list
- Quick actions (Send Money, History)

### Transfer
- Full transfer form with validation
- Recap screen before confirmation
- Dedicated success confirmation screen
- Simulated async submission with local persistence

### History
- Searchable transfer list (`.searchable`)
- Filter by status (All, Completed, Pending, Failed)
- Card-based row design
- Empty, error, and no-results states
- Pull-to-refresh

### Profile
- User name and email
- Dark mode toggle
- Account settings section

## Requirements

- Xcode 16+
- iOS 17+
- CocoaPods

## Getting Started

```bash
pod install
open TransferApp.xcworkspace
```

Run on a simulator with `⌘R`.

## Architecture

```
TransferApp/
├── App/              # Entry point, DI container, tab routing
├── Models/           # Transfer, UserProfile, TransferStatistics
├── Views/            # SwiftUI screens
├── ViewModels/       # Presentation logic per screen
├── Services/         # Persistence, stores, statistics
├── Network/          # Protocol-oriented networking layer
├── Domain/           # Validation, errors, state types
├── UseCases/         # Transfer submission
├── Components/       # Reusable UI (buttons, cards, rows)
├── Theme/            # AppColors, AppFonts, AppSpacing
├── Utils/            # Formatting helpers
└── Resources/        # Bundled JSON seed data
```

### Data flow

```
Views → ViewModels → UseCases / Stores → Services / Network → JSON / UserDefaults
```

### Key components

| Component | Role |
|-----------|------|
| `AppDependencyContainer` | Composition root |
| `TransferHistoryStore` | Transfer list state (`LoadState`) |
| `DashboardViewModel` | Dashboard stats and recent activity |
| `TransferHistoryViewModel` | Search and status filtering |
| `TransferSubmissionUseCase` | Submit and persist transfers |
| `TransferStatisticsService` | Compute balance and analytics |
| `AppAppearanceStore` | Dark mode preference |

## Design system

| Token | Purpose |
|-------|---------|
| `AppColors` | Primary blue, success green, error red, backgrounds |
| `AppFonts` | Typography scale (rounded headings, balance display) |
| `AppSpacing` | Consistent padding, card radius, shadows |

## Tech stack

- SwiftUI + Observation (`@Observable`)
- NavigationStack with value-based routing
- Swift Charts
- async/await
- Codable + UserDefaults persistence
- Protocol-oriented services

## Author

Oussama Litniti
