//
//  EBuddyTestApp.swift
//  EBuddyTest
//
//  Created by Dicky Geraldi on 25/12/24.
//

import SwiftUI
import FirebaseCore
import BackgroundTasks

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        FirebaseApp.configure()

        BGTaskScheduler.shared.register(forTaskWithIdentifier: "personal.EBuddy-Test.upload", using: nil) { task in
            self.handleUploadTask(task: task as! BGProcessingTask)
        }

        BackgroundUploader.shared.restoreQueueState()

        return true
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        BackgroundUploader.shared.handleAppGoesToBackground()
    }

    func scheduleUploadTask() {
        let request = BGProcessingTaskRequest(identifier: "personal.EBuddy-Test.upload")
        request.requiresNetworkConnectivity = true
        request.requiresExternalPower = false

        do {
            try BGTaskScheduler.shared.submit(request)
            print("Background upload task scheduled successfully.")
        } catch {
            print("Failed to schedule background upload task: \(error)")
        }
    }

    func handleUploadTask(task: BGProcessingTask) {
        scheduleUploadTask()

        task.expirationHandler = {
            print("Background upload task expired.")
            task.setTaskCompleted(success: false)
        }
        
        BackgroundUploader.shared.processQueue()
        if BackgroundUploader.shared.uploadQueue.isEmpty {
            task.setTaskCompleted(success: true)
        }
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
