//
//  NoteNetwork.swift
//  PhamPhuongNamNotes
//
//  Created by P. Nam on 18/01/2024.
//

import Foundation
import FirebaseCore
import FirebaseFirestore

protocol NoteNetwork {
    func saveNote(username: String, noteText: String) async throws
    func deleteNote(username: String, noteText: String) async throws
    func fetchAllNotes() -> AsyncThrowingStream<[UserNotes], Error>
}

final class FirebaseNotes: NoteNetwork {
    private let db: Firestore
    
    init(db: Firestore) {
        self.db = db
    }
    
    func saveNote(username: String, noteText: String) async throws {
        if noteText.isEmpty {
            throw PNError.empty
        }
        let userNotesReference = db.collection("NotesApp").document("users").collection("usernames").document(username)
        
        do {
            let _ = try await userNotesReference.setData([noteText: ""], merge: true)
        } catch {
            throw error
        }
    }
    
    func deleteNote(username: String, noteText: String) async throws {
        let userNotesReference = db.collection("NotesApp").document("users").collection("usernames").document(username)
        
        do {
            let querySnapshot = try await userNotesReference.getDocument()
            
            if var data = querySnapshot.data() {
                data.removeValue(forKey: noteText)
                let _ = try await userNotesReference.setData(data, merge: false)
            }
        } catch {
            throw error
        }
    }
    
    func fetchAllNotes() -> AsyncThrowingStream<[UserNotes], Error> {
        AsyncThrowingStream { [weak self] continuation in
            guard let self else { return }
            db.collection("NotesApp").document("users").collection("usernames").addSnapshotListener(includeMetadataChanges: true) { querySnapshot, error in
                if let error { return continuation.finish(throwing: error) }
                var allNotes: [UserNotes] = []
                for document in querySnapshot!.documents {
                    let userNotes = UserNotes(username: document.documentID, notes: Array(document.data().keys))
                    allNotes.append(userNotes)
                }
                continuation.yield(allNotes)
            }
        }
    }
}
