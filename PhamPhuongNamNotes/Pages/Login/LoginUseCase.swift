//
//  LoginUseCase.swift
//  PhamPhuongNamNotes
//
//  Created by P. Nam on 19/01/2024.
//

import Foundation

protocol LoginUseCase {
    func login(username: String) async throws 
}

final class LoginUseCaseImpl: LoginUseCase {
    private let userRepository: UserRepository
    
    init(userRepository: UserRepository) {
        self.userRepository = userRepository
    }
    
    func login(username: String) async throws {
        try await userRepository.saveUsername(username: username.trimmingCharacters(in: .whitespacesAndNewlines))
    }
}
