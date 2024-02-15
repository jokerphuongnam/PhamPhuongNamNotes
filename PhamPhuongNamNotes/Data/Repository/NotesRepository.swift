//
//  NotesRepository.swift
//  PhamPhuongNamNotes
//
//  Created by P. Nam on 18/01/2024.
//

import Foundation

protocol NotesRepository {
    func saveNote(username: String, noteText: String) async throws
    func getAllNotes() -> AsyncThrowingStream<[UserNotes], Error>
    func deleteNote(username: String, note: String) async throws
}

final class NotesRepositoryImpl: NotesRepository {
    private let network: NoteNetwork
    
    init(network: NoteNetwork) {
        self.network = network
    }
    
    func saveNote(username: String, noteText: String) async throws {
        try await network.saveNote(username: username, noteText: noteText)
    }
    
    func getAllNotes() -> AsyncThrowingStream<[UserNotes], Error> {
        network.fetchAllNotes()
    }
    
    func deleteNote(username: String, note: String) async throws {
        try await network.deleteNote(username: username, noteText: note)
    }
}
