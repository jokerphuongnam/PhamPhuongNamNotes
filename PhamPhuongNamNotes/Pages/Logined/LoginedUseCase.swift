//
//  LoginedUseCase.swift
//  PhamPhuongNamNotes
//
//  Created by P. Nam on 21/01/2024.
//

import Foundation

protocol LoginedUseCase {
    func logout() async throws
    func getUsername() async throws -> String?
}

final class LoginedUseCaseImpl: LoginedUseCase {
    private let userRepository: UserRepository
    
    init(userRepository: UserRepository) {
        self.userRepository = userRepository
    }
    
    func logout() async throws {
        try await userRepository.logout()
    }
    
    func getUsername() async throws -> String? {
        try await userRepository.getUsername()
    }
}
