//
//  MainNewsCardView.swift
//  SigloApp
//
//  Created by Macbook Pro 17 i5R on 3/13/25.
//
import SwiftUI

struct MainNewsCardView: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            TabView {
                // Otras pestañas...
             
            }

            Image("noticia_principal") // Puedes cargar desde URL más adelante
                .resizable()
                .scaledToFill()
                .frame(height: 220)
                .clipped()

            Text("GRUPO DE REACCIÓN TORREÓN")
                .font(.caption)
                .foregroundColor(.gray)

            Text("Municipio de Torreón da de baja al Grupo de Reacción; Gobierno del Estado lo rescata")
                .font(.headline)
                .foregroundColor(.primary)
                .lineLimit(3)

            Text("Alcalde Román Cepeda notificó al Grupo de Reacción su disolución con el gobierno municipal; inmediatamente el Estado entró al acogimiento y rescate del agrupamiento.")
                .font(.subheadline)
                .foregroundColor(.secondary)

            HStack {
                Text("EL SIGLO DE TORREÓN")
                    .font(.caption)
                    .foregroundColor(.gray)
                Spacer()
                Label("09:28 hrs", systemImage: "clock")
                    .font(.caption)
                    .foregroundColor(.gray)
            }
        }
        .padding(.horizontal)
    }
}

