//
//  ServiceDetailView.swift
//  FastMktp
//
//  Created by Lucas Souza on 18/08/25.
//

import SwiftUI

struct ServiceDetailView: View {
    let service: Service
    let servicesViewModel: ServicesViewModel
    
    @Environment(\.dismiss) private var dismiss
    @State private var showingRequestSheet = false
    @State private var requestMessage = ""
    @State private var showingSuccessAlert = false
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    // Header with category and price
                    HStack {
                        Text(service.category)
                            .font(.subheadline)
                            .fontWeight(.medium)
                            .padding(.horizontal, 12)
                            .padding(.vertical, 6)
                            .background(Color.blue.opacity(0.1))
                            .foregroundColor(.blue)
                            .cornerRadius(8)
                        
                        Spacer()
                        
                        Text(service.formattedPrice)
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundColor(.green)
                    }
                    
                    // Title
                    Text(service.title)
                        .font(.title)
                        .fontWeight(.bold)
                    
                    // Description
                    Text(service.serviceDescription)
                        .font(.body)
                        .lineSpacing(4)
                    
                    // Provider info
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Prestador")
                            .font(.headline)
                            .fontWeight(.semibold)
                        
                        HStack {
                            Image(systemName: "person.circle.fill")
                                .font(.title2)
                                .foregroundColor(.blue)
                            
                            VStack(alignment: .leading) {
                                Text(service.providerName)
                                    .font(.body)
                                    .fontWeight(.medium)
                                
                                Text(service.location)
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                        }
                    }
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(12)
                    
                    // Availability info
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Disponibilidade")
                            .font(.headline)
                            .fontWeight(.semibold)
                        
                        HStack {
                            Label(service.formattedDate, systemImage: "calendar")
                            Spacer()
                            Label(service.availableTime, systemImage: "clock")
                        }
                        .font(.body)
                        .foregroundColor(.secondary)
                    }
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(12)
                    
                    Spacer(minLength: 100) // Space for button
                }
                .padding()
            }
            .navigationTitle("Detalhes do Serviço")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Fechar") {
                        dismiss()
                    }
                }
            }
            .safeAreaInset(edge: .bottom) {
                // Request service button
                Button(action: {
                    showingRequestSheet = true
                }) {
                    Text("Solicitar Serviço")
                        .font(.headline)
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .cornerRadius(12)
                }
                .padding()
                .background(Color(.systemBackground))
            }
        }
        .sheet(isPresented: $showingRequestSheet) {
            ServiceRequestSheet(
                service: service,
                message: $requestMessage,
                onSend: {
                    servicesViewModel.requestService(service, message: requestMessage)
                    showingRequestSheet = false
                    showingSuccessAlert = true
                    requestMessage = ""
                }
            )
        }
        .alert("Solicitação Enviada!", isPresented: $showingSuccessAlert) {
            Button("OK") {
                dismiss()
            }
        } message: {
            Text("Sua solicitação foi enviada para \(service.providerName). Você receberá uma notificação quando houver resposta.")
        }
    }
}

struct ServiceRequestSheet: View {
    let service: Service
    @Binding var message: String
    let onSend: () -> Void
    
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationView {
            VStack(alignment: .leading, spacing: 20) {
                // Service info
                VStack(alignment: .leading, spacing: 8) {
                    Text("Solicitando:")
                        .font(.headline)
                        .fontWeight(.semibold)
                    
                    Text(service.title)
                        .font(.body)
                        .foregroundColor(.secondary)
                    
                    Text("Para: \(service.providerName)")
                        .font(.body)
                        .foregroundColor(.secondary)
                }
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(12)
                
                // Message input
                VStack(alignment: .leading, spacing: 8) {
                    Text("Mensagem (opcional)")
                        .font(.headline)
                        .fontWeight(.semibold)
                    
                    TextEditor(text: $message)
                        .frame(minHeight: 100)
                        .padding(8)
                        .background(Color(.systemGray6))
                        .cornerRadius(8)
                }
                
                Spacer()
            }
            .padding()
            .navigationTitle("Solicitar Serviço")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancelar") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Enviar") {
                        onSend()
                    }
                    .fontWeight(.semibold)
                }
            }
        }
    }
}

#Preview {
    let context = CoreDataManager.shared.context
    let service = Service(context: context)
    service.id = UUID()
    service.title = "Montagem de Móveis"
    service.serviceDescription = "Monto móveis IKEA, Tok&Stok e outros. Experiência de 5 anos."
    service.suggestedPrice = 80.0
    service.category = "Carpintaria"
    service.providerName = "João Silva"
    service.location = "São Paulo, SP"
    service.availableDate = Date()
    service.availableTime = "14:00"
    
    return ServiceDetailView(service: service, servicesViewModel: ServicesViewModel())
}