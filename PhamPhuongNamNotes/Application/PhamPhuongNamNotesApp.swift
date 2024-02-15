//
//  PhamPhuongNamNotesApp.swift
//  PhamPhuongNamNotes
//
//  Created by P. Nam on 16/01/2024.
//

import SwiftUI

@main
struct PhamPhuongNamNotesApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
    var body: some Scene {
        WindowGroup {
            NavigationView {
                MainView()
            }
        }
    }
}
