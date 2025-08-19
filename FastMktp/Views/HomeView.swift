//
//  HomeView.swift
//  FastMktp
//
//  Created by Lucas Souza on 18/08/25.
//

import SwiftUI

struct HomeView: View {
    @StateObject private var viewModel = ServicesViewModel()
    @State private var showingServiceDetail = false
    @State private var selectedService: Service?
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                // Header with search and filters
                VStack(spacing: 16) {
                    // Search bar
                    HStack {
                        Image(systemName: "magnifyingglass")
                            .foregroundColor(.gray)
                        
                        TextField("Buscar serviços...", text: $viewModel.searchText)
                            .textFieldStyle(PlainTextFieldStyle())
                    }
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(12)
                    
                    // Category filter
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 12) {
                            ForEach(viewModel.categories, id: \.self) { category in
                                CategoryChip(
                                    title: category,
                                    isSelected: viewModel.selectedCategory == category
                                ) {
                                    viewModel.selectedCategory = category
                                }
                            }
                        }
                        .padding(.horizontal)
                    }
                }
                .padding()
                .background(Color(.systemBackground))
                
                // Services list
                if viewModel.isLoading {
                    Spacer()
                    ProgressView("Carregando serviços...")
                        .scaleEffect(1.2)
                    Spacer()
                } else if viewModel.filteredServices.isEmpty {
                    Spacer()
                    VStack(spacing: 16) {
                        Image(systemName: "magnifyingglass")
                            .font(.system(size: 50))
                            .foregroundColor(.gray)
                        
                        Text("Nenhum serviço encontrado")
                            .font(.title2)
                            .fontWeight(.medium)
                        
                        Text("Tente ajustar os filtros ou buscar por outros termos")
                            .font(.body)
                            .foregroundColor(.secondary)
                            .multilineTextAlignment(.center)
                    }
                    .padding()
                    Spacer()
                } else {
                    List(viewModel.filteredServices, id: \.id) { service in
                        ServiceCard(service: service) {
                            selectedService = service
                            showingServiceDetail = true
                        }
                        .listRowSeparator(.hidden)
                        .listRowInsets(EdgeInsets(top: 8, leading: 16, bottom: 8, trailing: 16))
                    }
                    .listStyle(PlainListStyle())
                    .refreshable {
                        viewModel.refreshServices()
                    }
                }
            }
            .navigationTitle("Fast Marketplace")
            .navigationBarTitleDisplayMode(.large)
            .sheet(isPresented: $showingServiceDetail) {
                if let service = selectedService {
                    ServiceDetailView(service: service, servicesViewModel: viewModel)
                }
            }
        }
    }
}

struct CategoryChip: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.subheadline)
                .fontWeight(.medium)
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
                .background(isSelected ? Color.blue : Color(.systemGray6))
                .foregroundColor(isSelected ? .white : .primary)
                .cornerRadius(20)
        }
    }
}

struct ServiceCard: View {
    let service: Service
    let onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            VStack(alignment: .leading, spacing: 12) {
                // Header with category and price
                HStack {
                    Text(service.category ?? "Sem Categoria")
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
                
                // Title and description
                VStack(alignment: .leading, spacing: 4) {
                    Text(service.title ?? "Sem Título")
                        .font(.headline)
                        .fontWeight(.semibold)
                        .lineLimit(2)
                    
                    Text(service.serviceDescription ?? "Sem Descrição")
                        .font(.body)
                        .foregroundColor(.secondary)
                        .lineLimit(3)
                }
                
                // Provider and date info
                HStack {
                    Label(service.providerName ?? "Usuário Anônimo", systemImage: "person.circle")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    
                    Spacer()
                    
                    Label(service.formattedDate, systemImage: "calendar")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
            .padding()
            .background(Color(.systemBackground))
            .cornerRadius(12)
            .shadow(color: .black.opacity(0.1), radius: 4, x: 0, y: 2)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

#Preview {
    HomeView()
}
