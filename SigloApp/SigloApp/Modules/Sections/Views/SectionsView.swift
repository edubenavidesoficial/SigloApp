import SwiftUI

struct SectionsView: View {
    @StateObject private var viewModel = SectionListViewModel()
    @Environment(\.dismiss) var dismiss

    var body: some View {
        NavigationStack {
            ZStack(alignment: .leading) {
                // Fondo semitransparente que permite cerrar tocando fuera
                Color.black.opacity(0.3)
                    .edgesIgnoringSafeArea(.all)
                    .onTapGesture {
                        dismiss()
                    }

                VStack(spacing: 0) {
                    // Imagen superior
                    Image("menu")
                        .resizable()
                        .scaledToFill()
                        .frame(height: 150)
                        .clipped()

                    // Iconos de redes sociales
                    HStack(spacing: 20) {
                        Spacer()
                        Image("logo.youtube").resizable().frame(width: 20, height: 20)
                        Image("logo.facebook").resizable().frame(width: 20, height: 18)
                        Image("logo.twitter").resizable().frame(width: 20, height: 20)
                        Image("logo.instagram").resizable().frame(width: 20, height: 20)
                        Image("logo.tiktok").resizable().frame(width: 20, height: 20)
                        Spacer()
                    }
                    .padding(.vertical, 5)

                    // Lista de secciones
                    List {
                        // Portada
                        NavigationLink(destination:
                            HomeView()
                                .navigationBarBackButtonHidden(true)
                        ) {
                            Text("Portada")
                                .foregroundColor(.red)
                        }

                        // Minuto a minuto
                        NavigationLink(destination: Text("Minuto a minuto")) {
                            Text("Minuto a minuto")
                                .foregroundColor(.red)
                        }

                        // Secciones dinámicas
                        ForEach(viewModel.secciones, id: \.id) { seccion in
                            NavigationLink(destination: SectionDetailView(payload: seccion)) {
                                Text(seccion.nombre)
                                    .foregroundColor(seccion.nombre == "Siglo TV" ? .red : .black)
                            }
                        }

                        // Anuncios (sección de encabezado)
                        Section(header: Text("ANUNCIOS")
                            .font(.system(size: 16))
                            .foregroundColor(.gray)
                        ) {
                            // Clasificados
                            NavigationLink(destination:
                                    ClassifiedsView()
                                    .navigationBarBackButtonHidden(true)
                            ) {
                                Text("Clasificados")
                                    .foregroundColor(.black)
                            }

                            // Desplegados
                            NavigationLink(destination:
                                Text("Desplegados")
                            ) {
                                Text("Desplegados")
                                    .foregroundColor(.black)
                            }

                            // Esquelas
                            NavigationLink(destination:
                                Text("Esquelas")
                            ) {
                                Text("Esquelas")
                                    .foregroundColor(.black)
                            }

                            // Felicitaciones
                            NavigationLink(destination:
                                Text("Felicitaciones") // Puedes reemplazar esto con una vista real
                            ) {
                                Text("Felicitaciones")
                                    .foregroundColor(.black)
                            }
                        }
                    }

                    .listStyle(.plain)
                    .onAppear {
                        viewModel.fetchSecciones()
                    }
                    .overlay {
                        if viewModel.isLoading {
                            ProgressView("Cargando...")
                                .frame(maxWidth: .infinity, maxHeight: .infinity)
                                .background(Color.white.opacity(0.8))
                        }
                    }

                    // Botones inferiores
                    VStack(spacing: 10) {
                        actionButton(title: "Anúnciate") {
                            print("Anúnciate presionado")
                        }

                        actionButton(title: "Suscríbete") {
                            print("Suscríbete presionado")
                        }
                    }
                    .padding(.bottom, 10)
                }
                .frame(maxWidth: 200)
                .padding()
                .background(Color.white)
                .edgesIgnoringSafeArea(.vertical)
            }
        }
    }

    // Botón reutilizable
    func actionButton(title: String, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            Text(title)
                .font(.headline)
                .foregroundColor(.white)
                .frame(width: 180, height: 40)
                .background(Color.red)
        }
    }
}
