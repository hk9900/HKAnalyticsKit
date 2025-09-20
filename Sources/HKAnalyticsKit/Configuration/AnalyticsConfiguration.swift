import Foundation

public struct AnalyticsConfiguration {
    public let debugMode: Bool
    public let analyticsEnabled: Bool
    public let crashReportingEnabled: Bool
    public let maxParametersPerEvent: Int
    public let maxParameterValueLength: Int
    
    public init(
        debugMode: Bool = false,
        analyticsEnabled: Bool = true,
        crashReportingEnabled: Bool = true,
        maxParametersPerEvent: Int = 25,
        maxParameterValueLength: Int = 100
    ) {
        self.debugMode = debugMode
        self.analyticsEnabled = analyticsEnabled
        self.crashReportingEnabled = crashReportingEnabled
        self.maxParametersPerEvent = maxParametersPerEvent
        self.maxParameterValueLength = maxParameterValueLength
    }
    
    public static let `default` = AnalyticsConfiguration()
    public static let debug = AnalyticsConfiguration(debugMode: true)
    public static let production = AnalyticsConfiguration(debugMode: false)
    public static let disabled = AnalyticsConfiguration(
        analyticsEnabled: false,
        crashReportingEnabled: false
    )
}

@MainActor
public final class ConfigurationManager: ObservableObject {
    public static let shared = ConfigurationManager()
    
    @Published public private(set) var configuration: AnalyticsConfiguration?
    @Published public private(set) var debugMode: Bool = false
    
    private init() {}
    
    public func setConfiguration(_ configuration: AnalyticsConfiguration) {
        self.configuration = configuration
        self.debugMode = configuration.debugMode
    }
    
    public func setDebugMode(_ enabled: Bool) {
        self.debugMode = enabled
    }
    
    public func log(_ message: String, level: LogLevel = .info) {
        guard debugMode else { return }
        
        let timestamp = DateFormatter.debugFormatter.string(from: Date())
        print("🔍 [HKAnalyticsKit] \(timestamp) [\(level.rawValue.uppercased())] \(message)")
    }
}

public enum LogLevel: String, CaseIterable {
    case debug
    case info
    case warning
    case error
}

extension DateFormatter {
    static let debugFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm:ss.SSS"
        return formatter
    }()
}
