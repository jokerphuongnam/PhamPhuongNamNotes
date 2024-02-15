//
//  LoginViewModel.swift
//  PhamPhuongNamNotes
//
//  Created by P. Nam on 19/01/2024.
//

import Foundation

final class LoginViewModel: ObservableObject {
    private let usecase: LoginUseCase
    
    @Published var username: String = ""
    @Published var error: Error? = nil
    @Published var isLogin: Bool = false
    
    init(usecase: LoginUseCase) {
        self.usecase = usecase
    }
    
    func saveLogin() {
        Task(priority: .background) { [weak self] in
            guard let self else { return }
            do {
                try await usecase.login(username: username)
                Task { @MainActor in
                    self.isLogin = true
                }
            } catch {
                Task { @MainActor in
                    self.error = error
                }
            }
        }
    }
}
