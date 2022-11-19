//
//  UAlertApp.swift
//  UAlert
//
//  Created by Oleh Kiurchev on 21.07.2022.
//

import SwiftUI
import Pulse
import Logging

@main
struct UAlertApp: App {
    var body: some Scene {
        let _ = LoggingSystem.bootstrap(PersistentLogHandler.init)
        let _ = URLSessionProxyDelegate.enableAutomaticRegistration()

        WindowGroup {
            ContentView()
        }
    }
}
