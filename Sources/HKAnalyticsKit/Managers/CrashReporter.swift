import Foundation
import FirebaseCrashlytics

@MainActor
public final class CrashReporter {
    public static let shared = CrashReporter()
    
    private let crashlytics = Crashlytics.crashlytics()
    private var userContext: [String: Any] = [:]
    private var breadcrumbs: [Breadcrumb] = []
    private var isEnabled: Bool = true
    
    private init() {}
    
    public func setup() {
        crashlytics.setCrashlyticsCollectionEnabled(isEnabled)
    }
    
    public func setUserIdentifier(_ identifier: String) {
        crashlytics.setUserID(identifier)
        userContext["user_id"] = identifier
    }
    
    public func setUserContext(_ context: [String: Any]) {
        userContext.merge(context) { _, new in new }
        
        context.forEach { key, value in
            if let stringValue = value as? String {
                crashlytics.setCustomValue(stringValue, forKey: key)
            } else {
                crashlytics.setCustomValue(String(describing: value), forKey: key)
            }
        }
    }
    
    public func addBreadcrumb(
        _ message: String,
        data: [String: Any]? = nil
    ) {
        let breadcrumb = Breadcrumb(
            message: message,
            data: data ?? [:],
            timestamp: Date()
        )
        
        breadcrumbs.append(breadcrumb)
        
        if breadcrumbs.count > 100 {
            breadcrumbs.removeFirst(breadcrumbs.count - 100)
        }
        
        var breadcrumbMessage = message
        if let data = data, !data.isEmpty {
            let dataString = data.map { "\($0.key)=\($0.value)" }.joined(separator: ", ")
            breadcrumbMessage += " | \(dataString)"
        }
        
        crashlytics.log(breadcrumbMessage)
    }
    
    public func recordError(
        _ error: Error,
        additionalData: [String: Any]? = nil
    ) {
        var errorContext = userContext
        if let additionalData = additionalData {
            errorContext.merge(additionalData) { _, new in new }
        }
        
        errorContext["breadcrumbs"] = breadcrumbs.map { $0.description }
        
        crashlytics.record(error: error)
        
        ConfigurationManager.shared.log("Error recorded: \(error.localizedDescription)", level: .error)
    }
    
    public func setCrashReportingEnabled(_ enabled: Bool) {
        isEnabled = enabled
        crashlytics.setCrashlyticsCollectionEnabled(enabled)
    }
}

public struct Breadcrumb {
    public let message: String
    public let data: [String: Any]
    public let timestamp: Date
    
    public var description: String {
        let timestampString = DateFormatter.breadcrumbFormatter.string(from: timestamp)
        var description = "[\(timestampString)] \(message)"
        
        if !data.isEmpty {
            let dataString = data.map { "\($0.key)=\($0.value)" }.joined(separator: ", ")
            description += " | \(dataString)"
        }
        
        return description
    }
}

extension DateFormatter {
    static let breadcrumbFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm:ss.SSS"
        return formatter
    }()
}
