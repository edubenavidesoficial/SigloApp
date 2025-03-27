//
//  HometwoView.swift
//  SigloApp
//
//  Created by Macbook Pro 17 i5R on 3/26/25.
//
import SwiftUI

struct HomeView: View {
    @StateObject private var viewModel = HomeViewModel()
    @AppStorage("isLoggedIn") var isLoggedIn: Bool = false
    @State private var token: String? = nil
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                if !isLoggedIn {
                    HomeHeaderView()
                }

                ScrollView {
                    VStack(spacing: 16) {
                        if viewModel.isLoading {
                            ProgressView("Cargando noticias...")
                        } else if let errorMessage = viewModel.errorMessage {
                            Text("Error: \(errorMessage)")
                                .foregroundColor(.red)
                        } else {
                            ForEach(viewModel.secciones, id: \.seccion) { seccion in
                                Section(header: Text(seccion.seccion ?? "Siglo")
                                    .font(.title2)
                                    .bold()
                                    .padding(.horizontal)) {
                                        
                                    // Verificamos si la sección tiene notas
                                    if let notas = seccion.notas, !notas.isEmpty {
                                        ForEach(notas, id: \.id) { nota in
                                            VStack(alignment: .leading, spacing: 8) {
                                                Text(nota.titulo)
                                                    .font(.headline)
                                                    .foregroundColor(.primary)
                                                Text(nota.fecha_formato)
                                                    .font(.subheadline)
                                                    .foregroundColor(.secondary)
                                            }
                                            .padding(.vertical, 5)
                                        }
                                    } else {
                                        Text("No hay notas en esta sección")
                                            .foregroundColor(.gray)
                                            .italic()
                                    }
                                }
                            }
                        }
                    }
                    .padding(.top)
                }
            }
            .navigationBarHidden(true)
            .onAppear {
                viewModel.cargarPortada()
            }
            .task {
                do {
                    let generatedToken = try await TokenService.shared.getToken(correoHash: "")
                     print("✅ Token generado: \(generatedToken)")
                    token = generatedToken
                } catch {
                    print("❌ Error al generar token: \(error.localizedDescription)")
                }
            }
        }
    }
}
