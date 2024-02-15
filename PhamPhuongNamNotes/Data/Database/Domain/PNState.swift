//
//  PNState.swift
//  PhamPhuongNamNotes
//
//  Created by P. Nam on 19/01/2024.
//

import Foundation

enum PNState<T> {
    case loading
    case success(data: T)
    case error(error: Error)
}
