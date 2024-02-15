//
//  PNError.swift
//  PhamPhuongNamNotes
//
//  Created by P. Nam on 21/01/2024.
//

import Foundation

enum PNError: Error, Identifiable {
    case empty
    
    var id: String {
        localizedDescription
    }
}

struct NeedLoginError: Error {
    
}

struct KeychainError: Error, Identifiable {
    let status: OSStatus
    
    init(status: OSStatus) {
        self.status = status
    }
    
    var id: String {
        localizedDescription
    }
}

extension NSError: Identifiable {
    public var id: String {
        localizedDescription
    }
}
