import Foundation

public enum KeychainSharedConstants {
    static let teamId = ""
    static let serviceName = "mobilePasswordToken"

    static let serviceNameForKeychainWrapper = "mobilePasswordTokenKeychainWrapper"

    static var accessGroup: String {
        guard let bundleId = Bundle.main.bundleIdentifier else { return "" }
        return "\(teamId).\(bundleId)"
    }
}
