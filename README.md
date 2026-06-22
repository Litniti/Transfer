# TransferApp

A SwiftUI transfer management app built as a technical exercise. Users can create transfer requests, review a recap before confirming, browse transfer history, and view full transfer details.

## Features

- **New Transfer** — form with beneficiary, IBAN, amount, currency, reason, execution date, and instant transfer toggle
- **Validation** — required fields, amount > 0, IBAN format and minimum length, future execution date for scheduled transfers
- **Recap** — review all entered data before confirming
- **Submission** — simulated async transfer with local persistence
- **History** — bundled seed data merged with user-created transfers
- **Detail** — full transfer information including status, dates, and type

## Requirements

- Xcode 16+
- iOS 17+ (Simulator or device)
- CocoaPods (for workspace setup)

## Getting Started

1. Clone the repository.
2. Install dependencies:
   ```bash
   pod install
   ```
3. Open **`TransferApp.xcworkspace`** (not the `.xcodeproj`).
4. Select a simulator and run (`⌘R`).

## Architecture

The project follows **MVVM** with a clean separation of concerns:

```
TransferApp/
├── App/                 # Entry point, dependency injection
├── Domain/              # Business rules, errors, validation, state types
├── Models/              # Core domain models (Transfer, TransferDraft)
├── Services/            # Networking, persistence, history store
├── UseCases/            # Application-specific operations (submit transfer)
├── ViewModels/          # Screen presentation logic
├── Views/               # SwiftUI screens and reusable components
├── Utils/               # Formatting helpers
└── Resources/           # Bundled JSON seed data
```

### Data flow

```
Views → ViewModels → UseCases / Store → Services → Local JSON / UserDefaults
```

### Key components

| Component | Responsibility |
|-----------|----------------|
| `AppDependencyContainer` | Composition root — wires services, store, and use cases |
| `CreateTransferViewModel` | Form state and validation |
| `TransferRecapViewModel` | Submission state (`OperationState`) |
| `TransferHistoryStore` | Transfer list state (`LoadState`) |
| `TransferSubmissionUseCase` | Simulates submission and persists transfers |
| `NetworkingService` | Protocol for fetching transfers (local JSON implementation) |
| `TransferPersistenceService` | Protocol for saving user-created transfers (UserDefaults) |

### Dependency injection

Dependencies are created once in `AppDependencyContainer` and injected via SwiftUI's environment:

```swift
@State private var dependencies = AppDependencyContainer()

ContentView()
    .environment(dependencies)
```

## Navigation

The app uses a `TabView` with two tabs:

| Tab | Flow |
|-----|------|
| **New Transfer** | Form → Recap → Confirm → History (optional) |
| **History** | List → Detail |

Navigation is handled with `NavigationStack` and value-based destinations (`TransferDraft`, `Transfer`).

## Validation rules

| Field | Rule |
|-------|------|
| Beneficiary | Required, minimum 2 characters |
| IBAN | Required, minimum 15 characters, letters and numbers only |
| Amount | Required, greater than 0, maximum 1,000,000 |
| Reason | Required |
| Execution date | Must be in the future for scheduled (non-instant) transfers |

Invalid forms cannot navigate to the recap screen.

## Bundled data

Seed transfers are loaded from `Resources/transfers.json`. User-created transfers are stored in `UserDefaults` and merged with bundled data on load.

Sample JSON shape:

```json
{
  "id": "1",
  "beneficiary": "John Doe",
  "rib": "123456789012345678901234",
  "amount": 2500,
  "currency": "MAD",
  "reason": "Rent",
  "status": "Completed",
  "createdAt": "2026-05-20T10:00:00Z",
  "executionDate": "2026-05-20T10:00:00Z",
  "isInstant": false
}
```

> The JSON field `rib` is mapped to `iban` in the Swift model.

## Tech stack

- **SwiftUI** — UI framework
- **Observation** (`@Observable`) — state management
- **async/await** — asynchronous operations
- **Codable** — JSON encoding and decoding
- **NavigationStack** — type-safe navigation

## Possible extensions

- Replace `LocalJSONNetworkingService` with a real HTTP client
- Swap `UserDefaults` for SwiftData or Core Data
- Add unit tests for validation, use cases, and store logic
- Add authentication and secure token storage
- Add deep linking to transfer details

## Author

Oussama Litniti

## License

This project was created as a technical assessment exercise.
