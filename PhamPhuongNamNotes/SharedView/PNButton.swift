//
//  PNButton.swift
//  PhamPhuongNamNotes
//
//  Created by P. Nam on 21/01/2024.
//

import Foundation
import SwiftUI

struct PNButton: View {
    let isLoading: Bool
    let title: String
    let action: (() -> ())?
    
    init(title: String, isLoading: Bool = false, action: (() -> Void)?) {
        self.title = title
        self.isLoading = isLoading
        self.action = action
    }
    
    @ViewBuilder var body: some View {
        if isLoading {
            ZStack {
                ProgressView()
            }.foregroundColor(.white)
                .frame(height: 32)
                .frame(minWidth: 100)
                .background {
                    Color.blue
                        .clipShape(RoundedRectangle(cornerRadius: 16))
                }
        } else {
            Button {
                action?()
            } label: {
                Text(title)
                    .foregroundColor(.white)
                    .frame(height: 32)
                    .frame(minWidth: 100)
                    .background {
                        Color.blue
                            .clipShape(RoundedRectangle(cornerRadius: 16))
                    }
            }
        }
    }
}
