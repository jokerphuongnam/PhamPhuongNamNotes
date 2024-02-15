//
//  MainModel.swift
//  PhamPhuongNamNotes
//
//  Created by P. Nam on 21/01/2024.
//

import Foundation

struct ConfirmDeleteNote: Identifiable {
    let username: String
    let note: String
    
    var id: String {
        "\(username) \(note)"
    }
}

enum MainLoading {
    case add
    case delete
}
