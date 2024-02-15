//
//  AddNoteView.swift
//  PhamPhuongNamNotes
//
//  Created by P. Nam on 21/01/2024.
//

import SwiftUI

struct AddNoteView: View {
    @Environment(\.dismiss) var dismiss
    @ObservedObject var viewModel: AddNoteViewModel = AppDelegate.instance.resolve()
    
    var body: some View {
        VStack {
            TextField(text: $viewModel.note) {
                Text("Input note")
                    .frame(maxWidth: .infinity)
            }
            
            HStack {
                Button(role: .destructive) {
                    viewModel.saveNote()
                } label: {
                    Text("Add note")
                }
                
                Divider().background(.gray)
                
                Button(role: .cancel) {
                    dismiss()
                } label: {
                    Text("Cancel")
                }
            }
        }
    }
}
