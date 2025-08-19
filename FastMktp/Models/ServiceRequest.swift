//
//  ServiceRequest.swift
//  FastMktp
//
//  Created by Lucas Souza on 18/08/25.
//

import Foundation
import CoreData

// MARK: - ServiceRequest Extensions
extension ServiceRequest {
    
    var statusDescription: String {
        switch status {
        case "pending": return "Aguardando"
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
        return formatter.string(from: requestedAt ?? Date())
    }
    
    var statusColor: String {
        switch status {
        case "pending": return "orange"
        case "accepted": return "green"
        case "completed": return "blue"
        case "cancelled": return "red"
        default: return "gray"
        }
    }
}
