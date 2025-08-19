//
//  CoreDataManager.swift
//  FastMktp
//
//  Created by Lucas Souza on 18/08/25.
//

import Foundation
import CoreData

class CoreDataManager: ObservableObject {
    static let shared = CoreDataManager()
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "DataModel")
        container.loadPersistentStores { _, error in
            if let error = error {
                fatalError("Core Data error: \(error.localizedDescription)")
            }
        }
        container.viewContext.automaticallyMergesChangesFromParent = true
        return container
    }()
    
    var context: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    func save() {
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                print("Save error: \(error.localizedDescription)")
            }
        }
    }
    
    // MARK: - Service Operations
    func fetchServices() -> [Service] {
        let request: NSFetchRequest<Service> = Service.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(keyPath: \Service.createdAt, ascending: false)]
        request.predicate = NSPredicate(format: "isActive == true")
        
        do {
            return try context.fetch(request)
        } catch {
            print("Fetch services error: \(error.localizedDescription)")
            return []
        }
    }
    
    func createService(title: String, description: String, price: Double, date: Date, time: String, category: String, provider: String) -> Service {
        let service = Service(context: context)
        service.id = UUID()
        service.title = title
        service.serviceDescription = description
        service.suggestedPrice = price
        service.availableDate = date
        service.availableTime = time
        service.category = category
        service.providerName = provider
        service.location = "São Paulo, SP"
        service.isActive = true
        service.createdAt = Date()
        
        save()
        return service
    }
    
    func deleteService(_ service: Service) {
        context.delete(service)
        save()
    }
    
    // MARK: - ServiceRequest Operations
    func createServiceRequest(for service: Service, message: String, requester: User) -> ServiceRequest {
        let request = ServiceRequest(context: context)
        request.id = UUID()
        request.message = message
        request.requestedAt = Date()
        request.status = "pending"
        request.service = service
        request.requester = requester
        
        save()
        return request
    }
    
    func fetchServiceRequests() -> [ServiceRequest] {
        let request: NSFetchRequest<ServiceRequest> = ServiceRequest.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(keyPath: \ServiceRequest.requestedAt, ascending: false)]
        
        do {
            return try context.fetch(request)
        } catch {
            print("Fetch requests error: \(error.localizedDescription)")
            return []
        }
    }
    
    // MARK: - User Operations
    func getCurrentUser() -> User {
        let request: NSFetchRequest<User> = User.fetchRequest()
        request.predicate = NSPredicate(format: "isGuest == false")
        request.fetchLimit = 1
        
        do {
            if let user = try context.fetch(request).first {
                return user
            }
        } catch {
            print("Fetch user error: \(error.localizedDescription)")
        }
        
        return createGuestUser()
    }
    
    private func createGuestUser() -> User {
        let user = User(context: context)
        user.id = UUID()
        user.name = "Visitante"
        user.location = "São Paulo, SP"
        user.isGuest = true
        user.createdAt = Date()
        
        save()
        return user
    }
    
    // MARK: - Mock Data
    func loadMockDataIfNeeded() {
        let services = fetchServices()
        if services.isEmpty {
            let mockServices = Service.createMockServices(context: context)
            save()
            print("Loaded \(mockServices.count) mock services")
        }
    }
}
