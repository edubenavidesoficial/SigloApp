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

                Text("Bienvenido a El Siglo de Torreón")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .multilineTextAlignment(.center)

                ScrollView {
                    VStack(spacing: 16) {
                        if viewModel.isLoading {
                            ProgressView("Cargando noticias...")
                        } else if let errorMessage = viewModel.errorMessage {
                            Text("Error: \(errorMessage)")
                                .foregroundColor(.red)
                        } else {
                            ForEach(viewModel.secciones, id: \.seccion) { seccion in
                                Section(header: Text(seccion.seccion)
                                    .font(.title2)
                                    .bold()
                                    .padding(.horizontal)) {

                                    ForEach(seccion.notas) { nota in
                                        SecondaryNewsCardView(news: nota)
                                            .padding(.horizontal)
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
