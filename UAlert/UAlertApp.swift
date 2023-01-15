//
//  UAlertApp.swift
//  UAlert
//
//  Created by Oleh Kiurchev on 21.07.2022.
//

import SwiftUI
import Pulse
import Logging
import UserNotifications
import Get

@main
struct UAlertApp: App {
    @UIApplicationDelegateAdaptor private var appDelegate: AppDelegate

    var body: some Scene {
        let _ = LoggingSystem.bootstrap(PersistentLogHandler.init)
        let _ = URLSessionProxyDelegate.enableAutomaticRegistration()

        WindowGroup {
            ContentView()
        }
    }
}

struct DeviceRegistrationRequest: Encodable {
    var deviceId: String
    var regionId: String
}

class AppDelegate: NSObject, UIApplicationDelegate, ObservableObject {
    
    private var regionId: String? = nil
    
    func setRegionId(_ regionId: String) {
        self.regionId = regionId
    }
    
    func registerForPushNotifications() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound]) { granted, error in
            if let error = error {
                print("Failed: \(error.localizedDescription)")
            }
            DispatchQueue.main.async {
                UIApplication.shared.registerForRemoteNotifications()
            }
        }
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        print("Successfully received device token!")
        
        Task {
            let client = APIClient(baseURL: URL(string: "https://d051112ad970a7c3bc341f0a013832d3.m.pipedream.net"))
            let request = Request<Void>(method: "POST", path: "/", body: DeviceRegistrationRequest(deviceId: deviceToken.base64EncodedString(), regionId: self.regionId ?? ""))

            try await client.send(request)
            print("Successfully registered device for notifications!")
        }
    }

    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("Failed to register for notifications: \(error.localizedDescription)")
    }
}
