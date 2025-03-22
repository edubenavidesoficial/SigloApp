import SwiftUI

struct HomeView: View {
    @StateObject private var viewModel = HomeViewModel()
    @AppStorage("isLoggedIn") var isLoggedIn: Bool = false

    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                // Header fijo
                if !isLoggedIn {
                    HomeHeaderView()
                }

                // Contenido desplazable
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
            .onAppear {
            }
            .navigationBarHidden(true)
        }
    }
}
