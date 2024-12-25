//
//  EBuddyTestApp.swift
//  EBuddyTest
//
//  Created by Dicky Geraldi on 25/12/24.
//

import SwiftUI
import FirebaseCore

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        FirebaseApp.configure()

        return true
    }

    private func configureFirebase() {
        let environment: String
#if DEBUG
        environment = "Staging"
#else
        environment = "Production"
#endif
  
        if let filePath = Bundle.main.path(forResource: "GoogleService-Info-\(environment)", ofType: "plist") {
            let options = FirebaseOptions(contentsOfFile: filePath)
            FirebaseApp.configure(options: options!)
        } else {
            fatalError("Missing Firebase configuration file for \(environment).")
        }
    }
}

@main
struct EBuddyTestApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    @StateObject private var appEnvironment = AppEnvironment()

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
