//
//  UserRepository.swift
//  PhamPhuongNamNotes
//
//  Created by P. Nam on 18/01/2024.
//

import Foundation

protocol UserRepository {
    func isLogin() -> AsyncStream<Bool>
    func getUsername() async throws -> String?
    func saveUsername(username: String) async throws
    func logout() async throws
}

final class UserRepositoryImpl: UserRepository {
    private let local: UserLocal
    
    init(local: UserLocal) {
        self.local = local
    }
    
    func isLogin() -> AsyncStream<Bool> {
        local.isLogin()
    }
    
    func getUsername() async throws -> String? {
        try await local.findUsername()
    }
    
    func saveUsername(username: String) async throws {
        try await local.saveUsername(username: username)
    }
    
    func logout() async throws {
        try await local.logout()
    }
}
