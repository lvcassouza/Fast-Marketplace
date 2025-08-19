//
//  Service.swift
//  FastMktp
//
//  Created by Lucas Souza on 18/08/25.
//

import Foundation
import CoreData

@objc(Service)
public class Service: NSManagedObject {
    
}

// MARK: - Service Extensions
extension Service {
    
    // Computed properties para facilitar o uso
    var formattedPrice: String {
        return String(format: "R$ %.2f", suggestedPrice)
    }
    
    var formattedDate: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.locale = Locale(identifier: "pt_BR")
        return formatter.string(from: availableDate ?? Date())
    }
}

// MARK: - Mock Data Extension
extension Service {
    static func createMockServices(context: NSManagedObjectContext) -> [Service] {
        let mockData = [
            ("Montagem de Móveis", "Monto móveis IKEA, Tok&Stok e outros. Experiência de 5 anos.", 80.0, "Carpintaria", "João Silva"),
            ("Limpeza Residencial", "Limpeza completa de casas e apartamentos. Produtos inclusos.", 120.0, "Limpeza", "Maria Santos"),
            ("Aulas de Violão", "Aulas particulares de violão para iniciantes e intermediários.", 60.0, "Educação", "Pedro Costa"),
            ("Passeio com Pets", "Passeio seguro e carinhoso com seu pet. Disponível manhã e tarde.", 25.0, "Pet Care", "Ana Oliveira"),
            ("Jardinagem", "Cuidado de jardins, poda de plantas e manutenção de gramados.", 90.0, "Jardinagem", "Carlos Mendes"),
            ("Delivery de Comida", "Entrego comida caseira saudável. Cardápio variado diariamente.", 35.0, "Alimentação", "Lucia Ferreira")
        ]
        
        var services: [Service] = []
        
        for (title, description, price, category, provider) in mockData {
            let service = Service(context: context)
            service.id = UUID()
            service.title = title
            service.serviceDescription = description
            service.suggestedPrice = price
            service.availableDate = Calendar.current.date(byAdding: .day, value: Int.random(in: 1...30), to: Date()) ?? Date()
            service.availableTime = ["Manhã", "Tarde", "Noite"].randomElement() ?? "Manhã"
            service.category = category
            service.providerName = provider
            service.location = "São Paulo, SP"
            service.isActive = true
            service.createdAt = Date()
            
            services.append(service)
        }
        
        return services
    }
}
