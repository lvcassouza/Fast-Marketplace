//
//  User.swift
//  FastMktp
//
//  Created by Lucas Souza on 18/08/25.
//

import Foundation
import CoreData

// MARK: - User Extensions
extension User {
    
    var displayName: String {
        return isGuest ? "Usuário Visitante" : name ?? "Usuário"
    }
    
    var formattedCreatedDate: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.locale = Locale(identifier: "pt_BR")
        return formatter.string(from: createdAt ?? Date())
    }
    
    static var guestUser: User {
        let context = CoreDataManager.shared.context
        let user = User(context: context)
        user.id = UUID()
        user.name = "Visitante"
        user.location = "São Paulo, SP"
        user.isGuest = true
        user.createdAt = Date()
        return user
    }
}

@objc(User)
public class User: NSManagedObject {
    
}

extension User {
    
    @nonobjc public class func fetchRequest() -> NSFetchRequest<User> {
        return NSFetchRequest<User>(entityName: "User")
    }
    
    @NSManaged public var id: UUID
    @NSManaged public var name: String
    @NSManaged public var email: String?
    @NSManaged public var phone: String?
    @NSManaged public var location: String
    @NSManaged public var isGuest: Bool
    @NSManaged public var createdAt: Date
    @NSManaged public var services: NSSet?
    @NSManaged public var requests: NSSet?
}

// MARK: - Generated accessors for services
extension User {
    
    @objc(addServicesObject:)
    @NSManaged public func addToServices(_ value: Service)
    
    @objc(removeServicesObject:)
    @NSManaged public func removeFromServices(_ value: Service)
    
    @objc(addServices:)
    @NSManaged public func addToServices(_ values: NSSet)
    
    @objc(removeServices:)
    @NSManaged public func removeFromServices(_ values: NSSet)
}

// MARK: - Generated accessors for requests
extension User {
    
    @objc(addRequestsObject:)
    @NSManaged public func addToRequests(_ value: ServiceRequest)
    
    @objc(removeRequestsObject:)
    @NSManaged public func removeFromRequests(_ value: ServiceRequest)
    
    @objc(addRequests:)
    @NSManaged public func addToRequests(_ values: NSSet)
    
    @objc(removeRequests:)
    @NSManaged public func removeFromRequests(_ values: NSSet)
}