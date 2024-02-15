//
//  AddNoteViewModel.swift
//  PhamPhuongNamNotes
//
//  Created by P. Nam on 21/01/2024.
//

import Foundation

final class AddNoteViewModel: ObservableObject {
    private let usecase: AddNoteUseCase
    
    @Published var note = ""
    @Published var error: Error?
    
    init(usecase: AddNoteUseCase) {
        self.usecase = usecase
    }
    
    func saveNote() {
        Task(priority: .background) { [weak self] in
            guard let self else { return }
            do {
                try await self.usecase.saveNote(noteText: self.note)
            } catch {
                self.error = error
            }
        }
    }
}
