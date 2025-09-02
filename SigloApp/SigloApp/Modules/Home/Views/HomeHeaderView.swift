//
//  HomeHeaderView.swift
//  SigloApp
//
//  Created by Macbook Pro 17 i5R on 3/13/25.
//
import SwiftUI

struct HomeHeaderView: View {
    var body: some View {
        HStack {
            Button(action: {
                // Menú lateral o acción
            }) {
                Image(systemName: "line.horizontal.3")
                    .font(.title2)
            }

            Spacer()

            Image("logo") // Usa el logo como PNG o PDF vectorial
                .resizable()
                .scaledToFit()
                .frame(height: 35)

            Spacer()

           
        }
        .padding(.horizontal)
    }
}

