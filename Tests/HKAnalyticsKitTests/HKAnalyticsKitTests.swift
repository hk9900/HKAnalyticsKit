import XCTest
@testable import HKAnalyticsKit

final class HKAnalyticsKitTests: XCTestCase {
    
    func testEventTracking() {
        // Test basic event tracking without Firebase initialization
        HKAnalyticsKit.track("test_event", parameters: ["param1": "value1"])
        HKAnalyticsKit.trackScreen("test_screen")
    }
    
    func testUserInteractionTracking() {
        HKAnalyticsKit.trackInteraction("button_tap", element: "test_button", screen: "test_screen")
        HKAnalyticsKit.trackSelection("dropdown", value: "test_value")
    }
    
    func testUserProperties() {
        HKAnalyticsKit.setUserProperty("test_property", value: "test_value")
        HKAnalyticsKit.setUserProperties(["prop1": "value1", "prop2": "value2"])
    }
    
    func testAnalyticsCollection() {
        HKAnalyticsKit.setAnalyticsCollectionEnabled(false)
        HKAnalyticsKit.setAnalyticsCollectionEnabled(true)
    }
}
