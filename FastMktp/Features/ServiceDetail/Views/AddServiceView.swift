//
//  AddServiceView.swift
//  FastMktp
//
//  Created by Lucas Souza on 18/08/25.
//

import SwiftUI

struct AddServiceView: View {
    @StateObject private var viewModel = AddServiceViewModel()
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Informações Básicas")) {
                    TextField("Título do serviço", text: $viewModel.title)
                    
                    TextField("Seu nome", text: $viewModel.providerName)
                    
                    Picker("Categoria", selection: $viewModel.selectedCategory) {
                        ForEach(viewModel.categories, id: \.self) { category in
                            Text(category).tag(category)
                        }
                    }
                }
                
                Section(header: Text("Descrição")) {
                    TextField("Descreva seu serviço...", text: $viewModel.description, axis: .vertical)
                        .lineLimit(3...6)
                }
                
                Section(header: Text("Valor e Disponibilidade")) {
                    HStack {
                        Text("R$")
                        TextField("0,00", text: $viewModel.suggestedPrice)
                            .keyboardType(.decimalPad)
                    }
                    
                    DatePicker("Data disponível", selection: $viewModel.selectedDate, displayedComponents: .date)
                    
                    Picker("Horário", selection: $viewModel.selectedTime) {
                        ForEach(viewModel.availableTimes, id: \.self) { time in
                            Text(time).tag(time)
                        }
                    }
                }
                
                Section {
                    Button(action: {
                        if viewModel.publishService() {
                            dismiss()
                        }
                    }) {
                        HStack {
                            Spacer()
                            Text("Publicar Serviço")
                                .fontWeight(.semibold)
                            Spacer()
                        }
                    }
                    .disabled(!viewModel.isFormValid)
                }
            }
            .navigationTitle("Novo Serviço")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancelar") {
                        dismiss()
                    }
                }
            }
            .alert("Atenção", isPresented: $viewModel.showingAlert) {
                Button("OK") { }
            } message: {
                Text(viewModel.alertMessage)
            }
        }
    }
}

#Preview {
    AddServiceView()
}