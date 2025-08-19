//
//  ProfileViewModel.swift
//  FastMktp
//
//  Created by Lucas Souza on 18/08/25.
//

import Foundation
import SwiftUI

class ProfileViewModel: ObservableObject {
    @Published var user: User
    @Published var myServices: [Service] = []
    @Published var myRequests: [ServiceRequest] = []
    
    private let coreDataManager = CoreDataManager.shared
    
    init() {
        self.user = coreDataManager.getCurrentUser()
        loadUserData()
    }
    
    func loadUserData() {
        // Load services created by user (simplified - in real app would have user relationship)
        myServices = coreDataManager.fetchServices().filter { $0.providerName == user.name }
        
        // Load service requests made by user
        myRequests = coreDataManager.fetchServiceRequests().filter { $0.requester?.id == user.id }
    }
    
    func deleteService(_ service: Service) {
        coreDataManager.deleteService(service)
        loadUserData()
    }
    
    func refreshData() {
        loadUserData()
    }
}