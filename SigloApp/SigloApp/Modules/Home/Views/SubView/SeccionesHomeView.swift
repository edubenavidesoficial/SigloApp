//
//  ss.swift
//  SigloApp
//
//  Created by Macbook Pro 17 i5R on 3/27/25.
//

import SwiftUI

struct NoticiaView: View {
    let nota: Nota

    var body: some View {
ForEach(viewModel.secciones.filter { $0.seccion == "Portada" }, id: \.seccion) { seccion in
                            Section(header: Text(seccion.seccion ?? "Siglo")
                                .font(.title2)
                                .bold()
                                .padding(.horizontal)) {
                                    
                                // Aislar notas en una variable separada
                                let notas = seccion.notas ?? []  // Usa un array vacío si no hay notas
                                ForEach(notas, id: \.id) { nota in
                                    VStack(alignment: .leading, spacing: 8) {
                                        Text(nota.titulo)
                                            .font(.headline)

                                        // Usamos FotoView para mostrar las fotos
                                        if !nota.fotos.isEmpty {
                                            ForEach(nota.fotos, id: \.url_foto) { foto in
                                                FotoView(foto: foto)
                                            }
                                        }
                                    }
                                }
                                }
                            }
