//
//  MainViewModel.swift
//  PhamPhuongNamNotes
//
//  Created by P. Nam on 18/01/2024.
//

import Foundation

final class MainViewModel: ObservableObject {
    private let mainUseCase: MainUseCase
    
    @Published var isLogin: Bool = false
    @Published var allNotes: PNState<[UserNotes]> = .loading
    @Published var error: Error? = nil
    @Published var isAddNote = false
    @Published var username: String? = nil
    @Published var confirmDeleteNote: ConfirmDeleteNote? = nil
    @Published var loading: MainLoading?
    
    init(mainUseCase: MainUseCase) {
        self.mainUseCase = mainUseCase
    }
    
    func initData() {
        Task(priority: .background) { [weak self] in
            guard let self else { return }
            await self.loadUsername()
            await self.checkLogin()
            await self.loadUserNotes()
        }
    }
    
    private func loadUsername() async {
        do {
            let username = try await self.mainUseCase.getUsername()
            Task { @MainActor in
                self.username = username
            }
        } catch {
            
        }
    }
    
    private func checkLogin() async {
        for await isLoginAsync in self.mainUseCase.isLogin() {
            Task { @MainActor in
                self.isLogin = isLoginAsync
            }
            await self.loadUsername()
        }
    }
    
    func loadUserNotes() async {
        allNotes = .loading
        do {
            for try await userNotes in mainUseCase.getAllNotes() {
                Task { @MainActor in
                    allNotes = .success(data: userNotes)
                    loading = nil
                }
            }
        } catch {
            Task { @MainActor in
                allNotes = .error(error: error)
            }
        }
    }
    
    func deleteNote(confirmDeleteNote: ConfirmDeleteNote) {
        Task(priority: .background) { [weak self] in
            guard let self else { return }
            do {
                try await self.mainUseCase.deleteNote(
                    username: confirmDeleteNote.username,
                    note: confirmDeleteNote.note
                )
                self.loading = nil
            } catch {
                self.error = error
                self.loading = nil
            }
        }
    }
}
