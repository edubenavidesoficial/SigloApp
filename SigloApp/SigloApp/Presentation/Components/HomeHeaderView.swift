//
//  HomeHeaderView.swift
//  SigloApp
//
//  Created by Macbook Pro 17 i5R on 3/13/25.
//

import SwiftUI

struct HomeHeaderView: View {
    var body: some View {
        VStack(spacing: 0) {
            HStack {
                // Botón de menú
                Button(action: {
                    // Acción del menú
                }) {
                    Image(systemName: "line.horizontal.3")
                        .font(.title2)
                        .foregroundColor(.black)
                }

                Spacer()

                // Logo de "El Siglo"
                Image("titulo")
                    .resizable()
                    .scaledToFit()
                    .frame(height: 30)

                Spacer()

                // Botón de búsqueda
                Button(action: {
                    // Acción de búsqueda
                }) {
                    Image(systemName: "magnifyingglass")
                        .font(.title2)
                        .foregroundColor(.black)
                }
            }
            .padding(.horizontal)
            .padding(.top, 15)

            Divider()
                .frame(height: 0.5)
                .background(Color.black)
        }
    }
}

