//
//  AddServiceViewModel.swift
//  FastMktp
//
//  Created by Lucas Souza on 18/08/25.
//

import Foundation
import SwiftUI

class AddServiceViewModel: ObservableObject {
    @Published var title = ""
    @Published var description = ""
    @Published var suggestedPrice = ""
    @Published var selectedDate = Date()
    @Published var selectedTime = "09:00"
    @Published var selectedCategory = "Carpintaria"
    @Published var providerName = ""
    
    @Published var showingAlert = false
    @Published var alertMessage = ""
    
    private let coreDataManager = CoreDataManager.shared
    
    let availableTimes = ["09:00", "10:00", "11:00", "14:00", "15:00", "16:00", "17:00", "18:00", "19:00"]
    let categories = ["Carpintaria", "Limpeza", "Educação", "Pet Care", "Jardinagem", "Alimentação"]
    
    init() {
        let user = coreDataManager.getCurrentUser()
        self.providerName = user.name
    }
    
    var isFormValid: Bool {
        !title.isEmpty && 
        !description.isEmpty && 
        !suggestedPrice.isEmpty && 
        !providerName.isEmpty &&
        Double(suggestedPrice) != nil
    }
    
    func publishService() -> Bool {
        guard isFormValid else {
            alertMessage = "Por favor, preencha todos os campos corretamente."
            showingAlert = true
            return false
        }
        
        guard let price = Double(suggestedPrice), price > 0 else {
            alertMessage = "Por favor, insira um valor válido."
            showingAlert = true
            return false
        }
        
        let service = coreDataManager.createService(
            title: title,
            description: description,
            price: price,
            date: selectedDate,
            time: selectedTime,
            category: selectedCategory,
            provider: providerName
        )
        
        // Reset form
        resetForm()
        
        alertMessage = "Serviço publicado com sucesso!"
        showingAlert = true
        
        return true
    }
    
    private func resetForm() {
        title = ""
        description = ""
        suggestedPrice = ""
        selectedDate = Date()
        selectedTime = "09:00"
        selectedCategory = "Carpintaria"
    }
}