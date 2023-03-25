//
//  ToDoApp.swift
//  todo
//
//  Created by Aimee Esler on 3/22/23.
//

import SwiftUI
import FirebaseCore


class AppDelegate: NSObject, UIApplicationDelegate {
  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
    FirebaseApp.configure()

    return true
  }
}

@main
struct ToDoApp: App {
    // register app delegate for Firebase setup
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
    @StateObject var todoCache: TodoListCache = .shared
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(todoCache)
        }
    }
}
