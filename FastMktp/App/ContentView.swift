//
//  ContentView.swift
//  FastMktp
//
//  Created by Lucas Souza on 18/08/25.
//

import SwiftUI

struct ContentView: View {
    @State private var selectedTab = 0
    @State private var showingAddService = false
    
    var body: some View {
        TabView(selection: $selectedTab) {
            HomeView()
                .tabItem {
                    Image(systemName: "house.fill")
                    Text("Início")
                }
                .tag(0)
            
            Color.clear
                .tabItem {
                    Image(systemName: "plus.circle.fill")
                    Text("Adicionar")
                }
                .tag(1)
            
            ProfileView()
                .tabItem {
                    Image(systemName: "person.fill")
                    Text("Perfil")
                }
                .tag(2)
        }
        .onChange(of: selectedTab) { newValue in
            if newValue == 1 {
                showingAddService = true
                selectedTab = 0 // Reset to home tab
            }
        }
        .sheet(isPresented: $showingAddService) {
            AddServiceView()
        }
        .accentColor(.blue)
    }
}

#Preview {
    ContentView()
}
