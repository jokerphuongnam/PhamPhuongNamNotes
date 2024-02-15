//
//  MainView.swift
//  PhamPhuongNamNotes
//
//  Created by P. Nam on 18/01/2024.
//

import SwiftUI

struct MainView: View {
    @StateObject private var viewModel: MainViewModel = AppDelegate.instance.resolve()
    
    private var errorBoolBinding: Binding<Bool> {
        Binding<Bool>(
            get: { viewModel.error != nil },
            set: { hasError in
                if !hasError {
                    viewModel.error = nil
                }
            }
        )
    }
    
    @ViewBuilder var body: some View {
        ScrollView {
            allNotesView
        }
        .navigationTitle("Phạm Phương Nam Notes")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            viewModel.initData()
        }.toolbar {
            if viewModel.isLogin {
                ToolbarItemGroup(placement: .navigation) {
                    HStack {
                        LoginedView()
                    }
                }
                
                ToolbarItemGroup(placement: .topBarTrailing) {
                    if viewModel.loading == .add {
                        ProgressView()
                    } else {
                        Button {
                            viewModel.isAddNote = true
                            viewModel.loading = .add
                        } label: {
                            Image(systemName: "plus")
                        }
                    }
                }
            } else {
                ToolbarItemGroup(placement: .navigation) {
                    LoginView()
                }
            }
        }.alert("", isPresented: $viewModel.isAddNote) {
            AddNoteView()
        }.alert(isPresented: errorBoolBinding) {
            createAlertError()
        }.alert(item: $viewModel.confirmDeleteNote) { confirmDeleteNote in
            Alert(
                title: Text("confirm delete"),
                message: Text("Delete note: \(confirmDeleteNote.note)?"),
                dismissButton: .default(Text("Delete")) {
                    viewModel.deleteNote(confirmDeleteNote: confirmDeleteNote)
                }
            )
        }
    }
    
    @ViewBuilder var allNotesView: some View {
        switch viewModel.allNotes {
        case .loading:
            ProgressView()
        case .success(let data):
            if data.isEmpty {
                Text("Empty user")
            } else {
                LazyVStack(spacing: 4) {
                    ForEach(data, id: \.username) { userNotes in
                        Section {
                            ForEach(userNotes.notes, id: \.self) { note in
                                HStack {
                                    Text(note)
                                        .multilineTextAlignment(.leading)
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                    
                                    Spacer(minLength: 4)
                                    
                                    if viewModel.username == userNotes.username {
                                        if let confirmDeleteNote = viewModel.confirmDeleteNote, viewModel.loading == .delete, confirmDeleteNote.username == userNotes.username, confirmDeleteNote.note == note  {
                                            ProgressView()
                                        } else {
                                            Button {
                                                viewModel.confirmDeleteNote = ConfirmDeleteNote(
                                                    username: userNotes.username,
                                                    note: note
                                                )
                                                viewModel.loading = .delete
                                            } label: {
                                                Image(systemName: "minus")
                                                    .tint(Color.red)
                                            }
                                        }
                                    }
                                }.padding(4)
                            }
                        } header: {
                            HStack {
                                Text(userNotes.username)
                                    .font(.system(size: 24))
                                    .fontWeight(viewModel.username == userNotes.username ? .bold : .semibold)
                                Spacer()
                            }.padding(4)
                        }
                    }
                }
            }
        case .error(let error):
            Text(error.localizedDescription).foregroundStyle(.red)
        }
    }
    
    func createAlertError() -> Alert {
        if let error = viewModel.error {
            return Alert(title: Text(""), message: Text(error.localizedDescription), dismissButton: nil)
        } else {
            return Alert(title: Text(""), message: Text(""), dismissButton: nil)
        }
    }
}
