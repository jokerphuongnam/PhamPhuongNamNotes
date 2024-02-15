//
//  KeyChainManager.swift
//  PhamPhuongNamNotes
//
//  Created by P. Nam on 18/01/2024.
//

import Foundation
import Security

protocol KeychainManaging {
    func addKey(_ key: String, value: String) throws
    func removeKey(_ key: String) throws
    func getKey(_ key: String) -> String?
}

final class KeychainManager: KeychainManaging {
    private let service: String
    
    init(service: String) {
        self.service = service
    }
    
    func addKey(_ key: String, value: String) throws {
        let query = [
            kSecClass as String: kSecClassGenericPassword as String,
            kSecAttrService as String: service,
            kSecAttrAccount as String: key,
            kSecValueData as String: value.data(using: .utf8)!
        ] as CFDictionary
        
        let status = SecItemAdd(query, nil)
        
        if status == errSecSuccess {
            print("Key '\(key)' added to the keychain.")
        } else {
            if status == errSecDuplicateItem {
                try removeKey(key)
                try addKey(key, value: value)
            } else {
                throw KeychainError(status: status)
            }
        }
    }
    
    func removeKey(_ key: String) throws {
        let query = [
            kSecClass as String: kSecClassGenericPassword as String,
            kSecAttrService as String: service,
            kSecAttrAccount as String: key
        ] as CFDictionary
        
        let status = SecItemDelete(query)
        
        if status == errSecSuccess {
            print("Key '\(key)' removed from the keychain.")
        } else {
            throw KeychainError(status: status)
        }
    }
    
    func getKey(_ key: String) -> String? {
        let query = [
            kSecClass as String: kSecClassGenericPassword as String,
            kSecAttrService as String: service,
            kSecAttrAccount as String: key,
            kSecMatchLimit as String: kSecMatchLimitOne,
            kSecReturnData as String: kCFBooleanTrue!
        ] as CFDictionary
        
        var result: AnyObject?
        let status = SecItemCopyMatching(query, &result)
        
        if status == errSecSuccess, let data = result as? Data, let value = String(data: data, encoding: .utf8) {
            return value
        } else {
            print("Failed to retrieve key from the keychain. Status: \(status)")
            return nil
        }
    }
}
