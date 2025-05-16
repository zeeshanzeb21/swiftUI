//
//  ContentView.swift
//  swiftUI
//
//  Created by Invicttus on 14/05/2025.
//

import SwiftUI

// MARK: - ProductCell: Reusable product item view
struct ProductCell: View {
    let item: Product

    var body: some View {
        Text("Item \(item.thumbnail)")
            .font(.custom("SairaCondensed-Black", size: 20))
            .frame(width: 200, height: 120)
            .background(Color.pink)
            .foregroundColor(.black)
            .cornerRadius(12)
    }
}

// MARK: - ContentView
struct ContentView: View {
    @ObservedObject var viewModel = ViewModel()
    @State private var searchText: String = ""
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                // 🔍 TextField for search or input
                TextField("Search products...", text: $searchText)
                    .padding()
                    .background(Color.white)
                    .cornerRadius(8)
                    .frame(height: 60)
                    .padding(.horizontal)
                    .foregroundColor(.black)
                ScrollView {
                    LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 4), spacing: 20) {
                        ForEach(viewModel.products) { item in
                            NavigationLink(destination: DetailScreen(item: item.id)) {
                                ProductCell(item: item)
                            }
                            .buttonStyle(.plain) // tvOS focus-friendly
                        }
                    }
                    .padding()
                }
                .alert("Error", isPresented: $viewModel.showAlert) {
                    Button("OK", role: .cancel) {
                        viewModel.showAlert = false
                    }
                } message: {
                    Text(viewModel.chatListLoadingError)
                }
            }
        }
    }
}
// MARK: - Preview
#Preview {
    ContentView()
}

