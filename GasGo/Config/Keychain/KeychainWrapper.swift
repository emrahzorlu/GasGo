import Foundation

/// `KeychainWrapper` is a class to help make Keychain access in Swift more straightforward.
///
/// It is designed to make accessing the Keychain services more like using `NSUserDefaults`, which is much more familiar to people.
///
public final class KeychainWrapper {

    /// Default keychain wrapper access.
    public static let standard = KeychainWrapper()

    /// Shared keychain wrapper access.
    public static let shared = KeychainWrapper(serviceName: KeychainSharedConstants.serviceNameForKeychainWrapper, accessGroup: KeychainSharedConstants.accessGroup)

    /// `serviceName` is used for the `kSecAttrService` property to uniquely identify this keychain accessor.
    ///
    /// If no service name is specified, Keychain will default to using the bundle identifier.
    private(set) public var serviceName: String

    /// `accessGroup` is used for the `kSecAttrAccessGroup` property to identify which Keychain Access Group this entry belongs to.
    ///
    /// This allows you to use the Keychain with shared keychain access between different applications.
    private(set) public var accessGroup: String?

    /// Default name for the Keychain to be created.
    ///
    /// Use different service names to create different Keychain instances.
    private static let defaultServiceName: String = {
        return KeychainStandardConstants.serviceName
    }()

    private convenience init() {
        self.init(serviceName: KeychainWrapper.defaultServiceName)
    }

    /// Creates a custom instance of Keychain with a custom `serviceName` and optional custom `accessGroup`.
    ///
    /// - parameter serviceName: The ServiceName for this instance. Used to uniquely identify all keys stored using this keychain wrapper instance.
    /// - parameter accessGroup: Optional unique AccessGroup for this instance. Use a matching AccessGroup between applications to allow shared keychain access.
    public init(serviceName: String, accessGroup: String? = nil) {
        self.serviceName = serviceName
        self.accessGroup = accessGroup
    }

    // MARK: - Public Methods

    /// Checks if keychain data exists for a specified key.
    ///
    /// - parameter forKey: The key to check for.
    /// - parameter withAccessibility: Optional accessibility to use when retrieving the keychain item.
    /// - returns: `true` if a value exists for the key. `false` otherwise.
    public func hasValue(forKey key: String, withAccessibility accessibility: KeychainItemAccessibility? = nil) -> Bool {
        return data(forKey: key, withAccessibility: accessibility) != nil
    }

    /// Returns the accessibility of the given key.
    public func accessibility(of key: String) -> KeychainItemAccessibility? {
        var keychainQueryDictionary = setupKeychainQueryDictionary(forKey: key)

        // Remove accessibility attribute
        keychainQueryDictionary.removeValue(forKey: KeychainSecurityConstants.secAttrAccessible)
        
        // Limit search results to one
        keychainQueryDictionary[KeychainSecurityConstants.secMatchLimit] = kSecMatchLimitOne
        
        // Specify we want SecAttrAccessible returned
        keychainQueryDictionary[KeychainSecurityConstants.secReturnAttributes] = kCFBooleanTrue

        // Search
        var result: AnyObject?
        let status = SecItemCopyMatching(keychainQueryDictionary as CFDictionary, &result)

        guard 
            status == noErr,
            let resultsDictionary = result as? [String: AnyObject],
            let accessibilityAttrValue = resultsDictionary[KeychainSecurityConstants.secAttrAccessible] as? String
        else { return nil }

        return KeychainItemAccessibility.accessibilityForAttributeValue(accessibilityAttrValue as CFString)
    }

    /// Get the keys of all keychain entries matching the current `serviceName` and `accessGroup` if one is set.
    public func allKeys() -> Set<String> {
        var keychainQueryDictionary: [String: Any] = [
            KeychainSecurityConstants.secClass: kSecClassGenericPassword,
            KeychainSecurityConstants.secAttrService: serviceName,
            KeychainSecurityConstants.secReturnAttributes: kCFBooleanTrue!,
            KeychainSecurityConstants.secMatchLimit: kSecMatchLimitAll,
        ]

        if let accessGroup = self.accessGroup {
            keychainQueryDictionary[KeychainSecurityConstants.secAttrAccessGroup] = accessGroup
        }

        var result: AnyObject?
        let status = SecItemCopyMatching(keychainQueryDictionary as CFDictionary, &result)

        guard status == errSecSuccess else { return [] }

        var keys = Set<String>()
        if let results = result as? [[AnyHashable: Any]] {
            for attributes in results {
                if let accountData = attributes[KeychainSecurityConstants.secAttrAccount] as? Data,
                    let account = String(data: accountData, encoding: .utf8) {
                    keys.insert(account)
                }
            }
        }
        return keys
    }

    // MARK: - Public Getters

    /// Returns an `Int` value for a specified key.
    ///
    /// - parameter forKey: The key to lookup data for.
    /// - parameter withAccessibility: Optional accessibility to use when retrieving the keychain item.
    /// - returns: The `Int` associated with the key if it exists. If no data exists, or the data found cannot be encoded as a `Int`, returns `nil`.
    public func integer(
        forKey key: String,
        withAccessibility accessibility: KeychainItemAccessibility? = nil
    ) -> Int? {
        guard let numberValue = object(forKey: key, withAccessibility: accessibility) as? NSNumber else { return nil }
        return numberValue.intValue
    }

    /// Returns a `Double` value for a specified key.
    ///
    /// - parameter forKey: The key to lookup data for.
    /// - parameter withAccessibility: Optional accessibility to use when retrieving the keychain item.
    /// - returns: The `Double` associated with the key if it exists. If no data exists, or the data found cannot be encoded as a `Double`, returns `nil`.
    public func double(
        forKey key: String,
        withAccessibility accessibility: KeychainItemAccessibility? = nil
    ) -> Double? {
        guard let numberValue = object(forKey: key, withAccessibility: accessibility) as? NSNumber else { return nil }
        return numberValue.doubleValue
    }

    /// Returns a `Bool` value for a specified key.
    ///
    /// - parameter forKey: The key to lookup data for.
    /// - parameter withAccessibility: Optional accessibility to use when retrieving the keychain item.
    /// - returns: The `Bool` associated with the key if it exists. If no data exists, or the data found cannot be encoded as a `Bool`, returns `nil`.
    public func bool(
        forKey key: String,
        withAccessibility accessibility: KeychainItemAccessibility? = nil
    ) -> Bool? {
        guard let numberValue = object(forKey: key, withAccessibility: accessibility) as? NSNumber else { return nil }
        return numberValue.boolValue
    }

    /// Returns a `String` value for a specified key.
    ///
    /// - parameter forKey: The key to lookup data for.
    /// - parameter withAccessibility: Optional accessibility to use when retrieving the keychain item.
    /// - returns: The `String` associated with the key if it exists. If no data exists, or the data found cannot be encoded as a `String`, returns `nil`.
    public func string(
        forKey key: String,
        withAccessibility accessibility: KeychainItemAccessibility? = nil
    ) -> String? {
        guard let keychainData = data(forKey: key, withAccessibility: accessibility) else { return nil }
        return String(data: keychainData, encoding: .utf8) as String?
    }

    /// Returns an object that conforms to `NSCoding for a specified key.
    ///
    /// - parameter forKey: The key to lookup data for.
    /// - parameter withAccessibility: Optional accessibility to use when retrieving the keychain item.
    /// - returns: The decoded object associated with the key if it exists. If no data exists, or the data found cannot be decoded, returns `nil`.
    public func object(
        forKey key: String,
        withAccessibility accessibility: KeychainItemAccessibility? = nil
    ) -> NSCoding? {
        guard let keychainData = data(forKey: key, withAccessibility: accessibility) else { return nil }
        return try? NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(keychainData) as? NSCoding
    }

    /// Returns a `Data` object for a specified key.
    ///
    /// - parameter forKey: The key to lookup data for.
    /// - parameter withAccessibility: Optional accessibility to use when retrieving the keychain item.
    /// - returns: The `Data` object associated with the key if it exists. If no data exists, returns `nil`.
    public func data(
        forKey key: String,
        withAccessibility accessibility: KeychainItemAccessibility? = nil
    ) -> Data? {
        var keychainQueryDictionary = setupKeychainQueryDictionary(forKey: key, withAccessibility: accessibility)

        // Limit search results to one
        keychainQueryDictionary[KeychainSecurityConstants.secMatchLimit] = kSecMatchLimitOne
        
        // Specify we want Data/CFData returned
        keychainQueryDictionary[KeychainSecurityConstants.secReturnData] = kCFBooleanTrue

        // Search
        var result: AnyObject?
        let status = SecItemCopyMatching(keychainQueryDictionary as CFDictionary, &result)
        return status == noErr ? result as? Data : nil
    }

    /// Returns a persistent data reference object for a specified key.
    ///
    /// - parameter forKey: The key to lookup data for.
    /// - parameter withAccessibility: Optional accessibility to use when retrieving the keychain item.
    /// - returns: The persistent data reference object associated with the key if it exists. If no data exists, returns `nil`.
    public func dataRef(
        forKey key: String,
        withAccessibility accessibility: KeychainItemAccessibility? = nil
    ) -> Data? {
        var keychainQueryDictionary = setupKeychainQueryDictionary(forKey: key, withAccessibility: accessibility)

        // Limit search results to one
        keychainQueryDictionary[KeychainSecurityConstants.secMatchLimit] = kSecMatchLimitOne
        
        // Specify we want persistent Data/CFData reference returned
        keychainQueryDictionary[KeychainSecurityConstants.secReturnPersistentRef] = kCFBooleanTrue

        // Search
        var result: AnyObject?
        let status = SecItemCopyMatching(keychainQueryDictionary as CFDictionary, &result)
        return status == noErr ? result as? Data : nil
    }

    // MARK: - Public Setters

    /// Saves an `Int` value to the keychain associated with a specified key.
    ///
    /// If a value already exists for the given key, the value will be overwritten.
    ///
    /// - parameter value: The `Int` value to save.
    /// - parameter forKey: The key to save the value under.
    /// - parameter withAccessibility: Optional accessibility to use when setting the keychain item.
    /// - returns: `true` if the save was successful, `false` otherwise.
    @discardableResult public func set(
        value: Int,
        forKey key: String,
        withAccessibility accessibility: KeychainItemAccessibility? = nil
    ) -> Bool {
        return set(value: NSNumber(value: value), forKey: key, withAccessibility: accessibility)
    }

    /// Saves a `Double` value to the keychain associated with a specified key.
    ///
    /// If a value already exists for the given key, the value will be overwritten.
    ///
    /// - parameter value: The `Double` value to save.
    /// - parameter forKey: The key to save the value under.
    /// - parameter withAccessibility: Optional accessibility to use when setting the keychain item.
    /// - returns: `true` if the save was successful, `false` otherwise.
    @discardableResult public func set(
        value: Double,
        forKey key: String,
        withAccessibility accessibility: KeychainItemAccessibility? = nil
    ) -> Bool {
        return set(value: NSNumber(value: value), forKey: key, withAccessibility: accessibility)
    }

    /// Saves a `Bool` value to the keychain associated with a specified key.
    ///
    /// If a value already exists for the given key, the value will be overwritten.
    ///
    /// - parameter value: The `Bool` value to save.
    /// - parameter forKey: The key to save the value under.
    /// - parameter withAccessibility: Optional accessibility to use when setting the keychain item.
    /// - returns: `true` if the save was successful, `false` otherwise.
    @discardableResult public func set(
        value: Bool,
        forKey key: String,
        withAccessibility accessibility: KeychainItemAccessibility? = nil
    ) -> Bool {
        return set(value: NSNumber(value: value), forKey: key, withAccessibility: accessibility)
    }

    /// Saves a `String` value to the keychain associated with a specified key.
    ///
    /// If a value already exists for the given key, the value will be overwritten.
    ///
    /// - parameter value: The `String` value to save.
    /// - parameter forKey: The key to save the String under.
    /// - parameter withAccessibility: Optional accessibility to use when setting the keychain item.
    /// - returns: `true` if the save was successful, `false` otherwise.
    @discardableResult public func set(
        value: String,
        forKey key: String,
        withAccessibility accessibility: KeychainItemAccessibility? = nil
    ) -> Bool {
        guard let data = value.data(using: .utf8) else { return false }
        return set(value: data, forKey: key, withAccessibility: accessibility)
    }

    /// Saves an `NSCoding` compliant object to the keychain associated with a specified key.
    ///
    /// If an object already exists for the given key, the object will be overwritten with the new value.
    ///
    /// - parameter value: The NSCoding compliant object to save.
    /// - parameter forKey: The key to save the object under.
    /// - parameter withAccessibility: Optional accessibility to use when setting the keychain item.
    /// - returns: `true` if the save was successful, `false` otherwise.
    @discardableResult public func set(
        value: NSCoding,
        forKey key: String,
        withAccessibility accessibility: KeychainItemAccessibility? = nil
    ) -> Bool {
        guard let data = try? NSKeyedArchiver.archivedData(withRootObject: value, requiringSecureCoding: false) else { return false }
        return set(value: data, forKey: key, withAccessibility: accessibility)
    }

    /// Saves a `Data` object to the keychain associated with a specified key.
    ///
    /// If data already exists for the given key, the data will be overwritten with the new value.
    ///
    /// - parameter value: The Data object to save.
    /// - parameter forKey: The key to save the object under.
    /// - parameter withAccessibility: Optional accessibility to use when setting the keychain item.
    /// - returns: `true` if the save was successful, `false` otherwise.
    @discardableResult public func set(
        value: Data,
        forKey key: String,
        withAccessibility accessibility: KeychainItemAccessibility? = nil
    ) -> Bool {
        var keychainQueryDictionary: [String: Any] = setupKeychainQueryDictionary(forKey: key, withAccessibility: accessibility)
        keychainQueryDictionary[KeychainSecurityConstants.secValueData] = value

        if let accessibility = accessibility {
            keychainQueryDictionary[KeychainSecurityConstants.secAttrAccessible] = accessibility.keychainAttributeValue
        } else {
            keychainQueryDictionary[KeychainSecurityConstants.secAttrAccessible] = KeychainItemAccessibility.whenUnlocked.keychainAttributeValue
        }

        let status: OSStatus = SecItemAdd(keychainQueryDictionary as CFDictionary, nil)

        if status == errSecSuccess {
            return true
        } else if status == errSecDuplicateItem {
            return update(value: value, forKey: key, withAccessibility: accessibility)
        } else {
            return false
        }
    }

    /// Removes an object associated with a specified key.
    ///
    /// If re-using a key but with a different accessibility, first remove the previous key value using `removeObject(forKey:withAccessibility)` using the same accessibilty it was saved with.
    ///
    /// - parameter forKey: The key value to remove data for.
    /// - parameter withAccessibility: Optional accessibility level to use when looking up the keychain item.
    /// - returns: True if successful, false otherwise.
    @discardableResult public func removeObject(
        forKey key: String,
        withAccessibility accessibility: KeychainItemAccessibility? = nil
    ) -> Bool {
        let keychainQueryDictionary: [String: Any] = setupKeychainQueryDictionary(forKey: key, withAccessibility: accessibility)
        
        // Delete
        let status: OSStatus = SecItemDelete(keychainQueryDictionary as CFDictionary)

        return status == errSecSuccess
    }

    /// Removes all keychain data added through Keychain.
    ///
    /// This will only delete items matching the currnt `serviceName` and `accessGroup` if one is set.
    @discardableResult public func removeAllKeys() -> Bool {
        // Setup dictionary to access keychain and specify we are using a generic password (rather than a certificate, internet password, etc)
        var keychainQueryDictionary: [String: Any] = [KeychainSecurityConstants.secClass: kSecClassGenericPassword]

        // Uniquely identify this keychain accessor
        keychainQueryDictionary[KeychainSecurityConstants.secAttrService] = serviceName

        // Set the keychain access group if defined
        if let accessGroup = self.accessGroup {
            keychainQueryDictionary[KeychainSecurityConstants.secAttrAccessGroup] = accessGroup
        }

        let status: OSStatus = SecItemDelete(keychainQueryDictionary as CFDictionary)

        return status == errSecSuccess
    }

    /// Removes all keychain data, including data not added through keychain wrapper.
    ///
    /// - Warning: This may remove custom keychain entries you did not add via `KeychainWrapper`.
    public class func wipeKeychain() {
        deleteKeychainSecClass(kSecClassGenericPassword) // Generic password items
        deleteKeychainSecClass(kSecClassInternetPassword) // Internet password items
        deleteKeychainSecClass(kSecClassCertificate) // Certificate items
        deleteKeychainSecClass(kSecClassKey) // Cryptographic key items
        deleteKeychainSecClass(kSecClassIdentity) // Identity items
    }

    // MARK: - Private Methods

    /// Removes all items for a given Keychain Item Class
    @discardableResult private class func deleteKeychainSecClass(_ secClass: AnyObject) -> Bool {
        let query = [KeychainSecurityConstants.secClass: secClass]
        let status: OSStatus = SecItemDelete(query as CFDictionary)

        return status == errSecSuccess
    }

    /// Updates existing data associated with a specified key name.
    ///
    /// The existing data will be overwritten by the new data.
    private func update(
        value: Data,
        forKey key: String,
        withAccessibility accessibility: KeychainItemAccessibility? = nil
    ) -> Bool {
        var keychainQueryDictionary: [String: Any] = setupKeychainQueryDictionary(forKey: key, withAccessibility: accessibility)
        let updateDictionary = [KeychainSecurityConstants.secValueData: value]

        // on update, only set accessibility if passed in
        if let accessibility = accessibility {
            keychainQueryDictionary[KeychainSecurityConstants.secAttrAccessible] = accessibility.keychainAttributeValue
        }

        // Update
        let status: OSStatus = SecItemUpdate(keychainQueryDictionary as CFDictionary, updateDictionary as CFDictionary)

        return status == errSecSuccess
    }

    /// Setup the keychain query dictionary used to access the keychain on iOS for a specified key name. 
    ///
    /// Takes into account the `serviceName` and `accessGroup` if one is set.
    ///
    /// - parameter forKey: The key this query is for
    /// - parameter withAccessibility: Optional accessibility to use when setting the keychain item. If none is provided, will default to .WhenUnlocked
    /// - returns: A dictionary with all the needed properties setup to access the keychain on iOS
    private func setupKeychainQueryDictionary(
        forKey key: String,
        withAccessibility accessibility: KeychainItemAccessibility? = nil
    ) -> [String: Any] {
        // Setup default access as generic password (rather than a certificate, internet password, etc)
        var keychainQueryDictionary: [String: Any] = [KeychainSecurityConstants.secClass: kSecClassGenericPassword]

        // Uniquely identify this keychain accessor
        keychainQueryDictionary[KeychainSecurityConstants.secAttrService] = serviceName

        // Only set accessibiilty if it's passed in, we don't want to default it here in case the user didn't want it set
        if let accessibility = accessibility {
            keychainQueryDictionary[KeychainSecurityConstants.secAttrAccessible] = accessibility.keychainAttributeValue
        }

        // Set the keychain access group if defined
        if let accessGroup = self.accessGroup {
            keychainQueryDictionary[KeychainSecurityConstants.secAttrAccessGroup] = accessGroup
        }

        // Uniquely identify the account who will be accessing the keychain
        let encodedIdentifier: Data? = key.data(using: .utf8)
        keychainQueryDictionary[KeychainSecurityConstants.secAttrGeneric] = encodedIdentifier
        keychainQueryDictionary[KeychainSecurityConstants.secAttrAccount] = encodedIdentifier
        return keychainQueryDictionary
    }
}
