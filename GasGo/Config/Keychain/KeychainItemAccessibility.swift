import Foundation

protocol KeychainAttributeRepresentable {
    var keychainAttributeValue: CFString? { get }
}

// MARK: - KeychainItemAccessibility
public enum KeychainItemAccessibility {
    case afterFirstUnlock
    case afterFirstUnlockThisDeviceOnly
    case always
    case whenPasscodeSetThisDeviceOnly
    case alwaysThisDeviceOnly
    case whenUnlocked
    case whenUnlockedThisDeviceOnly

    static func accessibilityForAttributeValue(_ keychainAttrValue: CFString) -> KeychainItemAccessibility? {
        for (key, value) in keychainItemAccessibilityLookup where value == keychainAttrValue {
            return key
        }

        return nil
    }

    private static let keychainItemAccessibilityLookup: [KeychainItemAccessibility: CFString] = {
        var lookup: [KeychainItemAccessibility: CFString] = [
            .afterFirstUnlock: kSecAttrAccessibleAfterFirstUnlock,
            .afterFirstUnlockThisDeviceOnly: kSecAttrAccessibleAfterFirstUnlockThisDeviceOnly,
            .always: kSecAttrAccessibleAlways,
            .whenPasscodeSetThisDeviceOnly: kSecAttrAccessibleWhenPasscodeSetThisDeviceOnly,
            .alwaysThisDeviceOnly : kSecAttrAccessibleAlwaysThisDeviceOnly,
            .whenUnlocked: kSecAttrAccessibleWhenUnlocked,
            .whenUnlockedThisDeviceOnly: kSecAttrAccessibleWhenUnlockedThisDeviceOnly
        ]

        return lookup
    }()
}

extension KeychainItemAccessibility: KeychainAttributeRepresentable {
    internal var keychainAttributeValue: CFString? {
        return KeychainItemAccessibility.keychainItemAccessibilityLookup[self]
    }
}
