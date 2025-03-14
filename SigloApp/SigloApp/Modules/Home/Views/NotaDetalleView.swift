//
//  NotaDetalleView.swift
//  SigloApp
//
//  Created by Macbook Pro 17 i5R on 3/14/25.
//

import SwiftUI

struct NotaDetalleView: View {
    let nota: Nota

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                Text(nota.titulo)
                    .font(.title)
                    .fontWeight(.bold)

                if let contenido = nota.contenido, !contenido.isEmpty {
                    ForEach(contenido, id: \.self) { parrafo in
                        Text(parrafo)
                            .font(.body)
                    }
                } else {
                    Text("Sin contenido disponible")
                        .foregroundColor(.gray)
                        .italic()
                }


                if let fotos = nota.fotos {
                    ForEach(fotos, id: \.self) { fotoUrl in
                        AsyncImage(url: URL(string: fotoUrl)) { image in
                            image
                                .resizable()
                                .scaledToFit()
                                .cornerRadius(8)
                        } placeholder: {
                            ProgressView()
                        }
                    }
                }
            }
            .padding()
        }
        .navigationTitle("Detalle")
        .navigationBarTitleDisplayMode(.inline)
    }
}

