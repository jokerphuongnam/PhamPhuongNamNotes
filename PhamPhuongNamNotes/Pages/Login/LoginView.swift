//
//  LoginView.swift
//  PhamPhuongNamNotes
//
//  Created by P. Nam on 18/01/2024.
//

import SwiftUI

struct LoginView: View {
    @StateObject private var viewModel: LoginViewModel = AppDelegate.instance.resolve()
    
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
        HStack(spacing: 4) {
            TextField(text: $viewModel.username) {
                Text("Input username to create note")
                    .frame(maxWidth: .infinity)
            }
            
            PNButton(title: "Login", isLoading: viewModel.isLogin, action: viewModel.saveLogin)
        }
        .padding(4)
        .alert(isPresented: errorBoolBinding) {
            createAlertError()
        }
    }
    
    func createAlertError() -> Alert {
        if let error = viewModel.error as? PNError {
            switch error {
            case .empty:
                return Alert(title: Text(""), message: Text("Username can't empty"), dismissButton: nil)
            }
        } else if let error = viewModel.error {
            return Alert(title: Text(""), message: Text(error.localizedDescription), dismissButton: nil)
        } else {
            return Alert(title: Text(""), message: Text(""), dismissButton: nil)
        }
    }
}
