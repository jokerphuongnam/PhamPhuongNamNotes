//
//  AppDelegate.swift
//  PhamPhuongNamNotes
//
//  Created by P. Nam on 17/01/2024.
//

import Foundation
import UIKit
import FirebaseCore
import Swinject

final class AppDelegate: NSObject, UIApplicationDelegate {
    let container: Container = Container()
    static private(set) var instance: AppDelegate! = nil
    
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        register(container: container)
        AppDelegate.instance = self
        FirebaseApp.configure()
        return true
    }
    
    func resolve<T>() -> T {
        container.resolve(T.self)!
    }
}
