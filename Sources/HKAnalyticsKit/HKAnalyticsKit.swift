import SwiftUI
import FirebaseCore
import FirebaseAnalytics
import FirebaseCrashlytics

@available(iOS 16.0, macOS 13.0, watchOS 9.0, tvOS 16.0, *)
public struct HKAnalyticsKit {
    
    @MainActor
    public static func configure(
        with configuration: AnalyticsConfiguration = AnalyticsConfiguration.default
    ) {
        ConfigurationManager.shared.setConfiguration(configuration)
        
        if FirebaseApp.app() == nil {
            FirebaseApp.configure()
        }
        
        CrashReporter.shared.setup()
    }
    
    public static func track(
        _ event: String,
        parameters: [String: Any]? = nil
    ) {
        let sanitizedParameters = sanitizeParameters(parameters)
        Analytics.logEvent(event, parameters: sanitizedParameters)
    }
    
    public static func trackScreen(
        _ screenName: String,
        parameters: [String: Any]? = nil
    ) {
        let sanitizedParameters = sanitizeParameters(parameters)
        Analytics.logEvent(AnalyticsEventScreenView, parameters: [
            AnalyticsParameterScreenName: screenName,
            AnalyticsParameterScreenClass: screenName
        ].merging(sanitizedParameters ?? [:]) { _, new in new })
    }
    
    @MainActor
    public static func setUserId(_ userId: String) {
        Analytics.setUserID(userId)
        CrashReporter.shared.setUserIdentifier(userId)
    }
    
    public static func setUserProperty(
        _ name: String,
        value: String?
    ) {
        Analytics.setUserProperty(value, forName: name)
    }
    
    public static func setUserProperties(_ properties: [String: String]) {
        properties.forEach { key, value in
            setUserProperty(key, value: value)
        }
    }
    
    public static func trackInteraction(
        _ interaction: String,
        element: String,
        screen: String? = nil,
        parameters: [String: Any]? = nil
    ) {
        var eventParameters: [String: Any] = [
            "interaction_type": interaction,
            "element": element
        ]
        
        if let screen = screen {
            eventParameters["screen"] = screen
        }
        
        if let parameters = parameters {
            eventParameters.merge(parameters) { _, new in new }
        }
        
        track("user_interaction", parameters: eventParameters)
    }
    
    public static func trackSelection(
        _ selection: String,
        value: String,
        screen: String? = nil,
        parameters: [String: Any]? = nil
    ) {
        var eventParameters: [String: Any] = [
            "selection_type": selection,
            "selected_value": value
        ]
        
        if let screen = screen {
            eventParameters["screen"] = screen
        }
        
        if let parameters = parameters {
            eventParameters.merge(parameters) { _, new in new }
        }
        
        track("user_selection", parameters: eventParameters)
    }
    
    @MainActor
    public static func setUserContext(_ context: [String: Any]) {
        CrashReporter.shared.setUserContext(context)
    }
    
    @MainActor
    public static func addBreadcrumb(
        _ message: String,
        data: [String: Any]? = nil
    ) {
        CrashReporter.shared.addBreadcrumb(message, data: data)
    }
    
    @MainActor
    public static func recordError(
        _ error: Error,
        additionalData: [String: Any]? = nil
    ) {
        CrashReporter.shared.recordError(error, additionalData: additionalData)
    }
    
    public static func setAnalyticsCollectionEnabled(_ enabled: Bool) {
        Analytics.setAnalyticsCollectionEnabled(enabled)
    }
    
    @MainActor
    public static func setCrashReportingEnabled(_ enabled: Bool) {
        CrashReporter.shared.setCrashReportingEnabled(enabled)
    }
    
    @MainActor
    public static func setDebugMode(_ enabled: Bool) {
        ConfigurationManager.shared.setDebugMode(enabled)
    }
    
    private static func sanitizeParameters(_ parameters: [String: Any]?) -> [String: Any]? {
        guard let parameters = parameters else { return nil }
        
        let sanitizedParameters = parameters.compactMapValues { value in
            let stringValue = String(describing: value)
            return stringValue.count > 100 ? String(stringValue.prefix(100)) : value
        }
        
        return sanitizedParameters.isEmpty ? nil : sanitizedParameters
    }
}

@MainActor
public extension HKAnalyticsKit {
    static var configuration: AnalyticsConfiguration? {
        ConfigurationManager.shared.configuration
    }
}
