//
//  LoginedViewModel.swift
//  PhamPhuongNamNotes
//
//  Created by P. Nam on 21/01/2024.
//

import Foundation

final class LoginedViewModel: ObservableObject {
    private let usecase: LoginedUseCase
    
    @Published var username: String = ""
    @Published var isLoading = false
    
    init(usecase: LoginedUseCase) {
        self.usecase = usecase
    }
    
    func initData() {
        isLoading = true
        Task(priority: .background) { [weak self] in
            guard let self else { return }
            do {
                if let username = try await self.usecase.getUsername() {
                    Task { @MainActor in
                        self.username = username
                        self.isLoading = false
                    }
                }
            } catch {
#if DEBUG
                print(error)
#endif
                self.isLoading = false
            }
        }
    }
    
    func logout() {
        Task(priority: .background) { [weak self] in
            guard let self else { return }
            do {
                try await self.usecase.logout()
            } catch {
#if DEBUG
                print(error)
#endif
            }
        }
    }
}
