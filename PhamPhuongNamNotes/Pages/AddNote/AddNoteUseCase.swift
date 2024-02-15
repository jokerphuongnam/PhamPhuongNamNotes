//
//  AddNoteUseCase.swift
//  PhamPhuongNamNotes
//
//  Created by P. Nam on 21/01/2024.
//

import Foundation

protocol AddNoteUseCase {
    func saveNote(noteText: String) async throws
}

final class AddNoteUseCaseImpl: AddNoteUseCase {
    private let userRepository: UserRepository
    private let notesRepository: NotesRepository
    
    init(userRepository: UserRepository, notesRepository: NotesRepository) {
        self.userRepository = userRepository
        self.notesRepository = notesRepository
    }
    
    func saveNote(noteText: String) async throws {
        if let username = try await userRepository.getUsername() {
            return try await notesRepository.saveNote(username: username, noteText: noteText)
        }
        throw NeedLoginError()
    }
}
