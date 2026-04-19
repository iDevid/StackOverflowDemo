# StackOverflow Demo

A simple iOS app that fetches Stack Overflow users and lets you follow/unfollow them locally.

## How It Works

The app shows a table of Stack Overflow users with their avatars, reputation, and a follow button. You can scroll through the list, follow or unfollow users, and if the network fails you get an error screen with a retry action.

On launch, the app fetches the first page of users from the Stack Overflow API. 

As cells appear, it loads and caches their avatars. Follow status is persisted with Core Data, so it survives app restarts.

## Installation & Setup

### Requirements
- Xcode 26.0
- iOS 26.0
- Swift 5

### Steps

1. Clone the repo and open `StackOverflowDemo.xcodeproj`
2. Local modules are resolved via SPM, no external dependencies.
3. Build and run on simulator or device

## Technical Decisions & Why

### Modular Architecture with SPM

I split the app into separate Swift packages + Main Target:
- NetworkLayer
- PersistenceLayer
- NavigationLayer
- ImageLoader

This is deliberately more structure than a single screen app requires. The goal is to demonstrate clear module boundaries and isolated testability, so the architecture is ready to scale as the app grows.

### MVVM + Coordinators

I chose MVVM + Coordinators to show how this pattern can be built and maintained without external dependencies. View controllers hold no business logic, that's the responsibility of the ViewModel, observed through Swift's @Observable.

The coordinator pattern keeps navigation logic out of view controllers. Even with a single screen today, adding more flows later is straightforward.

### Async/Await

All asynchronous work (networking, image loading, persistence) uses async/await. The result is a consistent, linear syntax across the codebase with no mixing of callback or Combine styles.

### Diffable Data Source for the Table

The table is backed by `UITableViewDiffableDataSource`, which handles animations automatically when data changes. Snapshots are produced by the ViewModel and applied in the view controller via `updateProperties`.

### CoreData for Follow Persistence

I used CoreData instead of UserDefaults because:

1. Follow status is keyed by user ID, and makes querying and updating those records natural.
2. It scales cleanly if more persisted entities are added later.

### Error States as View Models

When the network fails, the view controller doesn't show a generic alert.

The ViewModel wraps the failure in an ErrorPlaceholderViewModel that describes what to render (title, message, retry action) without coupling the view to any specific error type. The same placeholder can be reused for empty states or other failure modes.

### Pagination Awareness

The ViewModel tracks `currentPage` and appends new users when you load more. Infinite scroll isn't wired up in this demo, but the plumbing is in place: triggering loadData() with an incremented page from a prefetch data source is all that's needed, and the diffable data source takes care of the animation.

### Image Loading with Task Cancellation

Images load asynchronously when cells appear. If a cell is reused before the image loads, the old task gets cancelled so you don't see stale images in the wrong cells. This is handled in `UserCellViewModel.loadImageIfNeeded()` with a stored `imageLoadTask` that you cancel before starting a new one.

### HTML Entity Decoding in the Decoder

User names from the API come with HTML entities like `&#243;` instead of `ó`. I added a `@HTMLDecoded` property wrapper that decodes these using regex during JSON decoding, so the ViewController never sees raw entities. It's cleaner than post-processing.

### Testing with Swift Testing

I used the Swift Testing framework instead of XCTest because it's cleaner and more readable. Tests cover:
- Happy paths and error cases
- State transitions
- Retry logic

### Localization

Localization is provided through a String Catalog (for the demo only English is provided)

## Possible Next Steps

### For this demo

- Pagination with infinite scrolling through PrefetchDataSource

### For the app architecture

- Screen Based modules, each app section could lay in its own module, to optimise build / test times

### For testing

- Snapshot Testing using https://github.com/pointfreeco/swift-snapshot-testing
- UI Tests for essential flows
- Test navigation flow when more screen are added
