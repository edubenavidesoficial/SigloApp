//
//  SearchView.swift
//  SigloApp
//
//  Created by Macbook Pro 17 i5R on 3/14/25.
//

import SwiftUI

struct SearchView: View {
    @State private var searchText = ""
    
    // Simulamos un listado de datos
    private let items = ["Apple", "Banana", "Orange", "Pineapple", "Grapes", "Strawberry", "Peach"]
    
    // Lista filtrada
    var filteredItems: [String] {
        if searchText.isEmpty {
            return items
        } else {
            return items.filter { $0.lowercased().contains(searchText.lowercased()) }
        }
    }

    var body: some View {
        VStack(spacing: 16) {
            // Barra de búsqueda
            HStack {
                Image(systemName: "magnifyingglass")
                    .foregroundColor(.gray)
                
                TextField("Buscar...", text: $searchText)
                    .textFieldStyle(PlainTextFieldStyle())
                    .padding(8)
            }
            .padding(.horizontal)
            .background(Color(.systemGray6))
            .cornerRadius(10)
            .padding()

            // Resultados filtrados
            if filteredItems.isEmpty {
                Spacer()
                Text("No se encontraron resultados")
                    .foregroundColor(.gray)
                Spacer()
            } else {
                ScrollView {
                    LazyVStack(alignment: .leading, spacing: 12) {
                        ForEach(filteredItems, id: \.self) { item in
                            Text(item)
                                .padding(.horizontal)
                                .padding(.vertical, 8)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .background(Color.white)
                                .cornerRadius(8)
                                .shadow(color: Color.black.opacity(0.05), radius: 2, x: 0, y: 1)
                        }
                    }
                    .padding(.horizontal)
                }
            }
        }
        .navigationTitle("Buscar")
        .background(Color(.systemGroupedBackground).ignoresSafeArea())
    }
}
