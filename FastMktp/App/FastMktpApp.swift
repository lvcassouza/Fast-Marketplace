//
//  FastMktpApp.swift
//  FastMktp
//
//  Created by Lucas Souza on 18/08/25.
//

import SwiftUI
import UserNotifications

@main
struct FastMktpApp: App {
    let persistenceController = CoreDataManager.shared
    
    init() {
        requestNotificationPermission()
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.context)
        }
    }
    
    private func requestNotificationPermission() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { granted, error in
            if let error = error {
                print("Notification permission error: \(error.localizedDescription)")
            }
        }
    }
}
