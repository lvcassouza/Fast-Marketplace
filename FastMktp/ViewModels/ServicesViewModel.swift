//
//  ServicesViewModel.swift
//  FastMktp
//
//  Created by Lucas Souza on 18/08/25.
//

import Foundation
import SwiftUI
import UserNotifications

class ServicesViewModel: ObservableObject {
    @Published var services: [Service] = []
    @Published var isLoading = false
    @Published var searchText = ""
    @Published var selectedCategory = "Todos"
    
    private let coreDataManager = CoreDataManager.shared
    
    let categories = ["Todos", "Carpintaria", "Limpeza", "Educação", "Pet Care", "Jardinagem", "Alimentação"]
    
    init() {
        loadServices()
        coreDataManager.loadMockDataIfNeeded()
    }
    
    var filteredServices: [Service] {
        var filtered = services
        
        // Filter by category
        if selectedCategory != "Todos" {
            filtered = filtered.filter { $0.category == selectedCategory }
        }
        
        // Filter by search text
        if !searchText.isEmpty {
            filtered = filtered.filter { service in
                service.title.localizedCaseInsensitiveContains(searchText) ||
                service.serviceDescription.localizedCaseInsensitiveContains(searchText) ||
                service.providerName.localizedCaseInsensitiveContains(searchText)
            }
        }
        
        return filtered
    }
    
    func loadServices() {
        isLoading = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { // Simulate network delay
            self.services = self.coreDataManager.fetchServices()
            self.isLoading = false
        }
    }
    
    func refreshServices() {
        loadServices()
    }
    
    func deleteService(_ service: Service) {
        coreDataManager.deleteService(service)
        loadServices()
    }
    
    func requestService(_ service: Service, message: String) {
        let user = coreDataManager.getCurrentUser()
        let request = coreDataManager.createServiceRequest(for: service, message: message, requester: user)
        
        // Send local notification
        sendServiceRequestNotification(for: service)
    }
    
    private func sendServiceRequestNotification(for service: Service) {
        let content = UNMutableNotificationContent()
        content.title = "Solicitação Enviada!"
        content.body = "Sua solicitação para '\(service.title)' foi enviada para \(service.providerName)."
        content.sound = .default
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Notification error: \(error.localizedDescription)")
            }
        }
    }
}