//
//  MoveoNotesAppApp.swift
//  MoveoNotesApp
//
//  Created by elad on 01/07/2025.
//


import SwiftUI
import FirebaseCore
import ComposableArchitecture


class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        FirebaseApp.configure()
        
        return true
    }
}

@main
struct MoveoNotesAppApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
    let store = Store(initialState: RootReducer.State.authentication(AuthenticationFeature.State())) {
        RootReducer()
    }
    
    var body: some Scene {
        WindowGroup {
            RootView(store: store)
        }
    }
}


