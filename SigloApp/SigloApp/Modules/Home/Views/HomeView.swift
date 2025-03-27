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
                                        .padding(.vertical, 8)
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
