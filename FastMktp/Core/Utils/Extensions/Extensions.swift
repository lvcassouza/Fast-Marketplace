//
//  Extensions.swift
//  FastMktp
//
//  Created by Lucas Souza on 19/08/25.
//
import Foundation
import CoreData

// MARK: - Service Extension
extension Service {
    // Computed property to format the price
    var formattedPrice: String {
        return String(format: "R$ %.2f", suggestedPrice)
    }
    
    // Computed property to format the date
    var formattedDate: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.locale = Locale(identifier: "pt_BR")
        return formatter.string(from: availableDate ?? Date())
    }
}

// MARK: - ServiceRequest Extension
extension ServiceRequest {
    var statusDescription: String {
        switch self.status {
        case "pending": return "Pendente"
        case "accepted": return "Aceito"
        case "completed": return "Concluído"
        case "cancelled": return "Cancelado"
        default: return "Desconhecido"
        }
    }

    var formattedDate: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .short
        formatter.locale = Locale(identifier: "pt_BR")
        return formatter.string(from: self.requestedAt ?? Date())
    }
}
