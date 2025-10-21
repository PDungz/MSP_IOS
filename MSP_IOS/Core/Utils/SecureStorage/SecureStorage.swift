//
//  SecureStorage.swift
//  MSP_IOS
//
//  Created by Phùng Văn Dũng on 21/10/25.
//

import Foundation
import Security
import CryptoKit

/// Enhanced secure storage with additional encryption layer
class SecureStorage {
    static let shared = SecureStorage()

    private let encryptionKey: SymmetricKey

    private init() {
        // ✅ Load hoặc tạo encryption key
        self.encryptionKey = Self.loadOrCreateEncryptionKey()
    }

    // MARK: - Encryption Key Management

    private static func loadOrCreateEncryptionKey() -> SymmetricKey {
        let keyTag = "com.msp_ios.encryption.key"

        // Try to load existing key
        if let existingKey = loadKeyFromKeychain(tag: keyTag) {
            AppLogger.i("Loaded existing encryption key")
            return existingKey
        }

        // Create new key
        let newKey = SymmetricKey(size: .bits256)
        saveKeyToKeychain(key: newKey, tag: keyTag)
        AppLogger.s("Created new encryption key")

        return newKey
    }

    private static func saveKeyToKeychain(key: SymmetricKey, tag: String) {
        let keyData = key.withUnsafeBytes { Data($0) }

        let query: [String: Any] = [
            kSecClass as String: kSecClassKey,
            kSecAttrApplicationTag as String: tag,
            kSecValueData as String: keyData,
            kSecAttrAccessible as String: kSecAttrAccessibleWhenUnlockedThisDeviceOnly
        ]

        SecItemDelete(query as CFDictionary) // Remove old key if exists

        let status = SecItemAdd(query as CFDictionary, nil)

        if status != errSecSuccess {
            AppLogger.e("Failed to save encryption key: \(status)")
        }
    }

    private static func loadKeyFromKeychain(tag: String) -> SymmetricKey? {
        let query: [String: Any] = [
            kSecClass as String: kSecClassKey,
            kSecAttrApplicationTag as String: tag,
            kSecReturnData as String: true
        ]

        var result: AnyObject?
        let status = SecItemCopyMatching(query as CFDictionary, &result)

        guard status == errSecSuccess,
              let keyData = result as? Data else {
            return nil
        }

        return SymmetricKey(data: keyData)
    }

    // MARK: - Encryption/Decryption

    private func encrypt(_ data: Data) throws -> Data {
        let sealedBox = try AES.GCM.seal(data, using: encryptionKey)

        guard let combined = sealedBox.combined else {
            throw EncryptionError.encryptionFailed
        }

        return combined
    }

    private func decrypt(_ data: Data) throws -> Data {
        let sealedBox = try AES.GCM.SealedBox(combined: data)
        let decryptedData = try AES.GCM.open(sealedBox, using: encryptionKey)

        return decryptedData
    }

    // MARK: - Public Methods

    /// Save any Codable object to Keychain with encryption
    func save<T: Codable>(_ value: T, forKey key: String) -> Bool {
        do {
            // 1. Encode to JSON
            let jsonData = try JSONEncoder().encode(value)

            // 2. ✅ Encrypt data
            let encryptedData = try encrypt(jsonData)

            // 3. Save to Keychain
            return saveData(encryptedData, forKey: key)
        } catch {
            AppLogger.e("Failed to save encrypted value for key '\(key)': \(error)")
            return false
        }
    }

    /// Save String to Keychain with encryption
    func save(_ value: String, forKey key: String) -> Bool {
        guard let data = value.data(using: .utf8) else {
            AppLogger.e("Failed to convert string to data for key '\(key)'")
            return false
        }

        do {
            // ✅ Encrypt data
            let encryptedData = try encrypt(data)
            return saveData(encryptedData, forKey: key)
        } catch {
            AppLogger.e("Failed to save encrypted string for key '\(key)': \(error)")
            return false
        }
    }

    /// Load Codable object from Keychain with decryption
    func load<T: Codable>(forKey key: String, as type: T.Type) -> T? {
        guard let encryptedData = loadData(forKey: key) else {
            return nil
        }

        do {
            // 1. ✅ Decrypt data
            let decryptedData = try decrypt(encryptedData)

            // 2. Decode JSON
            return try JSONDecoder().decode(type, from: decryptedData)
        } catch {
            AppLogger.e("Failed to load encrypted value for key '\(key)': \(error)")
            return nil
        }
    }

    /// Load String from Keychain with decryption
    func loadString(forKey key: String) -> String? {
        guard let encryptedData = loadData(forKey: key) else {
            return nil
        }

        do {
            // ✅ Decrypt data
            let decryptedData = try decrypt(encryptedData)
            return String(data: decryptedData, encoding: .utf8)
        } catch {
            AppLogger.e("Failed to load encrypted string for key '\(key)': \(error)")
            return nil
        }
    }

    /// Delete item from Keychain
    @discardableResult
    func delete(forKey key: String) -> Bool {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: key
        ]

        let status = SecItemDelete(query as CFDictionary)

        if status == errSecSuccess {
            AppLogger.i("Deleted item from Keychain: \(key)")
            return true
        } else if status == errSecItemNotFound {
            AppLogger.w("Item not found in Keychain: \(key)")
            return true
        } else {
            AppLogger.e("Failed to delete item from Keychain: \(key), status: \(status)")
            return false
        }
    }

    /// Check if key exists in Keychain
    func exists(forKey key: String) -> Bool {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: key,
            kSecReturnData as String: false
        ]

        let status = SecItemCopyMatching(query as CFDictionary, nil)
        return status == errSecSuccess
    }

    /// Clear all items (use with caution!)
    func clearAll() -> Bool {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword
        ]

        let status = SecItemDelete(query as CFDictionary)

        if status == errSecSuccess || status == errSecItemNotFound {
            AppLogger.w("Cleared all items from Keychain")
            return true
        } else {
            AppLogger.e("Failed to clear Keychain, status: \(status)")
            return false
        }
    }

    // MARK: - Private Helpers

    private func saveData(_ data: Data, forKey key: String) -> Bool {
        // Delete existing item first
        delete(forKey: key)

        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: key,
            kSecValueData as String: data,
            kSecAttrAccessible as String: kSecAttrAccessibleWhenUnlockedThisDeviceOnly
        ]

        let status = SecItemAdd(query as CFDictionary, nil)

        if status == errSecSuccess {
            AppLogger.i("Saved encrypted item to Keychain: \(key)")
            return true
        } else {
            AppLogger.e("Failed to save item to Keychain: \(key), status: \(status)")
            return false
        }
    }

    private func loadData(forKey key: String) -> Data? {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: key,
            kSecReturnData as String: true,
            kSecMatchLimit as String: kSecMatchLimitOne
        ]

        var result: AnyObject?
        let status = SecItemCopyMatching(query as CFDictionary, &result)

        guard status == errSecSuccess,
              let data = result as? Data else {
            if status != errSecItemNotFound {
                AppLogger.w("Item not found in Keychain: \(key)")
            }
            return nil
        }

        return data
    }
}

// MARK: - Error Types

enum EncryptionError: Error, LocalizedError {
    case encryptionFailed
    case decryptionFailed
    case keyGenerationFailed

    var errorDescription: String? {
        switch self {
        case .encryptionFailed:
            return "Failed to encrypt data"
        case .decryptionFailed:
            return "Failed to decrypt data"
        case .keyGenerationFailed:
            return "Failed to generate encryption key"
        }
    }
}
