//
//  PortadaView.swift
//  SigloApp
//
//  Created by Macbook Pro 17 i5R on 3/14/25.
//
import SwiftUI

struct PortadaView: View {
    @StateObject private var viewModel = PortadaViewModel()

    var body: some View {
        NavigationView {
            Group {
                if let error = viewModel.errorMessage {
                    VStack {
                        Spacer()
                        Text("❌ Error al cargar la portada")
                            .font(.headline)
                        Text(error)
                            .foregroundColor(.red)
                            .multilineTextAlignment(.center)
                        Spacer()
                    }
                    .padding()
                } else if viewModel.secciones.isEmpty {
                    VStack {
                        Spacer()
                        ProgressView("Cargando portada...")
                        Spacer()
                    }
                } else {
                    List {
                        ForEach(viewModel.secciones) { seccion in
                            Section(header: Text(seccion.seccion)) {
                                ForEach(seccion.notas) { nota in
                                    NavigationLink(destination: NotaDetalleView(nota: nota)) {
                                        VStack(alignment: .leading) {
                                            Text(nota.titulo)
                                                .font(.headline)
                                            if let balazo = nota.balazo {
                                                Text(balazo)
                                                    .font(.subheadline)
                                                    .foregroundColor(.secondary)
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
            .onAppear {
                viewModel.obtenerPortada()
            }
        }
    }
}
