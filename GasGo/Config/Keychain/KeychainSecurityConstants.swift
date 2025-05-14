import Foundation

public enum KeychainSecurityConstants {
    static let secMatchLimit = String(kSecMatchLimit)
    static let secReturnData = String(kSecReturnData)
    static let secReturnPersistentRef = String(kSecReturnPersistentRef)
    static let secValueData = String(kSecValueData)
    static let secAttrAccessible = String(kSecAttrAccessible)
    static let secClass = String(kSecClass)
    static let secAttrService = String(kSecAttrService)
    static let secAttrGeneric = String(kSecAttrGeneric)
    static let secAttrAccount = String(kSecAttrAccount)
    static let secAttrAccessGroup = String(kSecAttrAccessGroup)
    static let secReturnAttributes = String(kSecReturnAttributes)
}
