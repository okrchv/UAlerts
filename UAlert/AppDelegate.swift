//
//  AppDelegate.swift
//  UAlert
//
//  Created by Oleh Kiurchev on 17.01.2023.
//

import Foundation
import UIKit
import UserNotifications
import Get
import UkraineAlertAPI

class AppDelegate: NSObject, UIApplicationDelegate, ObservableObject {
    
    private var regionId: String? = nil

    func registerForPushNotifications(_ regionId: String) async {
        self.regionId = regionId

        let granted = try? await UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound])
        
        if granted == true {
            DispatchQueue.main.async {
                UIApplication.shared.registerForRemoteNotifications()
            }
        } else {
            print("Failed to request authorization for notifications")
        }
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        print("Successfully received device token!")
        
        Task {
            let client = APIClient(baseURL: URL(string: "https://d051112ad970a7c3bc341f0a013832d3.m.pipedream.net"))
            let request = Request<Void>(method: "POST", path: "/", body: DeviceRegistrationRequest(deviceToken: deviceToken.base64EncodedString(), regionId: self.regionId ?? ""))

            try await client.send(request)
            print("Successfully registered device for notifications!")
        }
    }

    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("Failed to register for notifications: \(error.localizedDescription)")
    }
    
    func application(_ application: UIApplication,
                     didReceiveRemoteNotification userInfo: [AnyHashable : Any],
                     fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void
                    ) {
        print("Received a new remote notification")
        
        if let event = userInfo["event"] as? [AnyHashable : Any],
           let regionId = event["regionId"] as? String {
            Task {
                let _ = try? await Client.shared.send(Paths.alerts.regionID(regionId).get)
                completionHandler(.newData)
            }
        } else {
            completionHandler(.noData)
        }
    }
}

struct DeviceRegistrationRequest: Encodable {
    var deviceToken: String
    var regionId: String
}
