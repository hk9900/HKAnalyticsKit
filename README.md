# HKAnalyticsKit

A lightweight, Firebase Analytics-focused framework for iOS applications with comprehensive crash reporting and user interaction tracking.

## Features

- 🎯 **Event Tracking**: Custom events with parameters and validation
- 📱 **Screen Tracking**: Automatic screen view tracking with custom parameters
- 👤 **User Properties**: User identification and custom properties
- 🚨 **Crash Reporting**: Detailed crash reporting with context and breadcrumbs
- 🖱️ **User Interaction Tracking**: Button taps, selections, gestures, and more
- 🔒 **Privacy & Compliance**: Built-in data sanitization
- 🛠️ **Developer Friendly**: Debug mode and comprehensive logging

## Requirements

- iOS 16.0+
- Swift 5.9+
- Xcode 15.0+
- Firebase Analytics
- Firebase Crashlytics

## Quick Start

### 1. Configure HKAnalyticsKit

```swift
import SwiftUI
import HKAnalyticsKit

@main
struct MyApp: App {
    init() {
        HKAnalyticsKit.configure(with: .production)
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
```

### 2. Track Events

```swift
// Track custom events
HKAnalyticsKit.track("button_tapped", parameters: ["button": "login"])

// Track screen views
HKAnalyticsKit.trackScreen("login_view")

// Set user properties
HKAnalyticsKit.setUserProperty("subscription", value: "premium")
HKAnalyticsKit.setUserId("user123")
```

### 3. Track User Interactions

```swift
// Track button taps
HKAnalyticsKit.trackInteraction("button_tap", element: "login_button", screen: "login_view")

// Track selections
HKAnalyticsKit.trackSelection("dropdown", value: "premium", screen: "subscription_view")
```

### 4. Crash Reporting

```swift
// Set user context
HKAnalyticsKit.setUserContext(["user_id": "123", "subscription": "premium"])

// Add breadcrumbs
HKAnalyticsKit.addBreadcrumb("user_attempted_login", data: ["method": "email"])

// Record errors
HKAnalyticsKit.recordError(error, additionalData: ["context": "login_flow"])
```

## License

This project is licensed under the MIT License.

---

Made with ❤️ for the iOS community
