//
//  LoginedView.swift
//  PhamPhuongNamNotes
//
//  Created by P. Nam on 21/01/2024.
//

import SwiftUI

struct LoginedView: View {
    @StateObject private var viewModel: LoginedViewModel = AppDelegate.instance.resolve()
    
    @ViewBuilder var body: some View {
        HStack(spacing: 4) {
            Text(viewModel.username)
            
            PNButton(title: "Logout", isLoading: viewModel.isLoading, action: viewModel.logout)
        }.onAppear(perform: viewModel.initData)
    }
}
