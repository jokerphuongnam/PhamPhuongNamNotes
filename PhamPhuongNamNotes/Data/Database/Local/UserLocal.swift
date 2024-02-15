//
//  UserLocal.swift
//  PhamPhuongNamNotes
//
//  Created by P. Nam on 18/01/2024.
//

import Foundation

protocol UserLocal {
    func isLogin() -> AsyncStream<Bool>
    func findUsername() async throws -> String?
    func saveUsername(username: String) async throws
    func logout() async throws
    
}

final class KeychainUser: UserLocal {
    private let keychainManager: KeychainManaging
    private let userKey = "Username"
    private var _isLoginContinuation: AsyncStream<Bool>.Continuation?
    private lazy var _isLoginStream = AsyncStream<Bool> { [weak self] continuation in
        guard let self else { return }
        self._isLoginContinuation = continuation
        let isLogin = self.keychainManager.getKey(self.userKey) != nil
        continuation.yield(isLogin)
    }
    
    init(keychainManager: KeychainManaging) {
        self.keychainManager = keychainManager
    }
    
    func isLogin() -> AsyncStream<Bool> {
        _isLoginStream
    }
    
    func findUsername() async throws -> String? {
        return try await withCheckedThrowingContinuation { [weak self] continuation in
            guard let self else { return }
            continuation.resume(returning: self.keychainManager.getKey(self.userKey))
        }
    }
    
    func saveUsername(username: String) async throws {
        if username.isEmpty {
            throw PNError.empty
        }
        return try await withCheckedThrowingContinuation { [weak self] continuation in
            guard let self else { return }
            do {
                try self.keychainManager.addKey(self.userKey, value: username)
                self._isLoginContinuation?.yield(true)
            } catch {
                continuation.resume(throwing: error)
            }
        }
    }
    
    func logout() async throws {
        return try await withCheckedThrowingContinuation { [weak self] continuation in
            guard let self else { return }
            do {
                try self.keychainManager.removeKey(self.userKey)
                self._isLoginContinuation?.yield(false)
            } catch {
                continuation.resume(throwing: error)
            }
        }
    }
}
