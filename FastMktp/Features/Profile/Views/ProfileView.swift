//
//  ProfileView.swift
//  FastMktp
//
//  Created by Lucas Souza on 18/08/25.
//

import SwiftUI

struct ProfileView: View {
    @StateObject private var viewModel = ProfileViewModel()
    @State private var selectedTab = 0
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                // User info header
                VStack(spacing: 16) {
                    // Avatar and basic info
                    HStack(spacing: 16) {
                        Image(systemName: "person.circle.fill")
                            .font(.system(size: 60))
                            .foregroundColor(.blue)
                        
                        VStack(alignment: .leading, spacing: 4) {
                            Text(viewModel.user.name!)
                                .font(.title2)
                                .fontWeight(.bold)
                            
                            if viewModel.user.isGuest {
                                Text("Usuário Visitante")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                            
                            Text(viewModel.user.location!)
                                .font(.body)
                                .foregroundColor(.secondary)
                        }
                        
                        Spacer()
                    }
                    
                    // Stats
                    HStack(spacing: 30) {
                        StatView(title: "Serviços", value: "\(viewModel.myServices.count)")
                        StatView(title: "Solicitações", value: "\(viewModel.myRequests.count)")
                    }
                }
                .padding()
                .background(Color(.systemGray6))
                
                // Tab selector
                Picker("Tab", selection: $selectedTab) {
                    Text("Meus Serviços").tag(0)
                    Text("Solicitações").tag(1)
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding()
                
                // Content based on selected tab
                TabView(selection: $selectedTab) {
                    // My Services Tab
                    MyServicesTab(viewModel: viewModel)
                        .tag(0)
                    
                    // My Requests Tab
                    MyRequestsTab(viewModel: viewModel)
                        .tag(1)
                }
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
            }
            .navigationTitle("Perfil")
            .navigationBarTitleDisplayMode(.inline)
            .refreshable {
                viewModel.refreshData()
            }
        }
    }
}

struct StatView: View {
    let title: String
    let value: String
    
    var body: some View {
        VStack(spacing: 4) {
            Text(value)
                .font(.title2)
                .fontWeight(.bold)
            
            Text(title)
                .font(.caption)
                .foregroundColor(.secondary)
        }
    }
}

struct MyServicesTab: View {
    @ObservedObject var viewModel: ProfileViewModel
    
    var body: some View {
        if viewModel.myServices.isEmpty {
            VStack(spacing: 16) {
                Image(systemName: "briefcase")
                    .font(.system(size: 50))
                    .foregroundColor(.gray)
                
                Text("Nenhum serviço publicado")
                    .font(.title2)
                    .fontWeight(.medium)
                
                Text("Seus serviços publicados aparecerão aqui")
                    .font(.body)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
            }
            .padding()
        } else {
            List {
                ForEach(viewModel.myServices, id: \.id) { service in
                    MyServiceCard(service: service) {
                        viewModel.deleteService(service)
                    }
                    .listRowSeparator(.hidden)
                    .listRowInsets(EdgeInsets(top: 8, leading: 16, bottom: 8, trailing: 16))
                }
                .onDelete { indexSet in
                    for index in indexSet {
                        viewModel.deleteService(viewModel.myServices[index])
                    }
                }
            }
            .listStyle(PlainListStyle())
        }
    }
}

struct MyRequestsTab: View {
    @ObservedObject var viewModel: ProfileViewModel
    
    var body: some View {
        if viewModel.myRequests.isEmpty {
            VStack(spacing: 16) {
                Image(systemName: "hand.raised")
                    .font(.system(size: 50))
                    .foregroundColor(.gray)
                
                Text("Nenhuma solicitação")
                    .font(.title2)
                    .fontWeight(.medium)
                
                Text("Suas solicitações de serviços aparecerão aqui")
                    .font(.body)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
            }
            .padding()
        } else {
            List(viewModel.myRequests, id: \.id) { request in
                RequestCard(request: request)
                    .listRowSeparator(.hidden)
                    .listRowInsets(EdgeInsets(top: 8, leading: 16, bottom: 8, trailing: 16))
            }
            .listStyle(PlainListStyle())
        }
    }
}

struct MyServiceCard: View {
    let service: Service
    let onDelete: () -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text(service.category!)
                    .font(.caption)
                    .fontWeight(.medium)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(Color.blue.opacity(0.1))
                    .foregroundColor(.blue)
                    .cornerRadius(6)
                
                Spacer()
                
                Text(service.formattedPrice)
                    .font(.headline)
                    .fontWeight(.bold)
                    .foregroundColor(.green)
            }
            
            Text(service.title!)
                .font(.headline)
                .fontWeight(.semibold)
            
            Text(service.serviceDescription!)
                .font(.body)
                .foregroundColor(.secondary)
                .lineLimit(2)
            
            HStack {
                Label(service.formattedDate, systemImage: "calendar")
                    .font(.caption)
                    .foregroundColor(.secondary)
                
                Spacer()
                
                Button(action: onDelete) {
                    Image(systemName: "trash")
                        .foregroundColor(.red)
                }
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(color: .black.opacity(0.1), radius: 4, x: 0, y: 2)
    }
}

struct RequestCard: View {
    let request: ServiceRequest
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text(request.statusDescription)
                    .font(.caption)
                    .fontWeight(.medium)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(statusColor.opacity(0.1))
                    .foregroundColor(statusColor)
                    .cornerRadius(6)
                
                Spacer()
                
                Text(request.formattedDate)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            if let service = request.service {
                Text(service.title!)
                    .font(.headline)
                    .fontWeight(.semibold)
                
                Text("Prestador: \(service.providerName)")
                    .font(.body)
                    .foregroundColor(.secondary)
            }
            
            if !request.message!.isEmpty {
                Text("Mensagem: \(request.message)")
                    .font(.body)
                    .foregroundColor(.secondary)
                    .lineLimit(2)
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(color: .black.opacity(0.1), radius: 4, x: 0, y: 2)
    }
    
    private var statusColor: Color {
        switch request.status {
        case "pending": return .orange
        case "accepted": return .green
        case "completed": return .blue
        case "cancelled": return .red
        default: return .gray
        }
    }
}

#Preview {
    ProfileView()
}
