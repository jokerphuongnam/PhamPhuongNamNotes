//
//  MainUseCase.swift
//  PhamPhuongNamNotes
//
//  Created by P. Nam on 18/01/2024.
//

import Foundation

protocol MainUseCase {
    func getUsername() async throws -> String?
    func isLogin() -> AsyncStream<Bool>
    func getAllNotes() -> AsyncThrowingStream<[UserNotes], Error>
    func deleteNote(username: String, note: String) async throws
}

final class MainUseCaseImpl: MainUseCase {
    private let userRepository: UserRepository
    private let notesRepository: NotesRepository
    
    init(userRepository: UserRepository, notesRepository: NotesRepository) {
        self.userRepository = userRepository
        self.notesRepository = notesRepository
    }
    
    func getUsername() async throws -> String? {
        try await userRepository.getUsername()
    }
    
    func isLogin() -> AsyncStream<Bool> {
        userRepository.isLogin()
    }
    
    func getAllNotes() -> AsyncThrowingStream<[UserNotes], Error> {
        notesRepository.getAllNotes()
    }
    
    func deleteNote(username: String, note: String) async throws {
        try await notesRepository.deleteNote(username: username, note: note)
    }
}
