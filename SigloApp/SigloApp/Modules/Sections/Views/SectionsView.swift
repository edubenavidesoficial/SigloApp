import SwiftUI

struct SectionsView: View {
    @StateObject private var viewModel = SectionListViewModel()
    @Environment(\.dismiss) var dismiss

    var body: some View {
        NavigationStack {
            ZStack(alignment: .leading) {
                // Fondo semi-transparente
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
                        .frame(height: 206)
                        .padding(.top, -15)
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
                        NavigationLink(destination: HomeView()
                                        .navigationBarBackButtonHidden(true)) {
                            Text("Portada")
                                .foregroundColor(.red)
                        }
                        .buttonStyle(PlainButtonStyle())
                        .listRowBackground(Color.white)

                        // Minuto a minuto
                        NavigationLink(destination: CoversView()) {
                            Text("Minuto a minuto")
                                .foregroundColor(.red)
                        }
                        .buttonStyle(PlainButtonStyle())
                        .listRowBackground(Color.white)

                        // Secciones dinámicas
                        ForEach(viewModel.secciones.filter { ![67, 32, 35, 219].contains($0.id) }, id: \.id) { seccion in
                            NavigationLink(destination: SectionDetailView(payload: seccion)) {
                                Text(seccion.nombre)
                                    .foregroundColor(seccion.nombre == "Siglo TV" ? .red : .black)
                            }
                            .buttonStyle(PlainButtonStyle())
                            .listRowBackground(Color.white)
                        }

                        // Suplementos
                        Section(header: Text("SUPLEMENTOS")
                            .font(.system(size: 16))
                            .foregroundColor(.gray)
                        ) {
                            ForEach(viewModel.secciones.filter { [67, 32, 35, 219].contains($0.id) }, id: \.id) { suplemento in
                                NavigationLink(destination: SectionDetailView(payload: suplemento)) {
                                    Text(suplemento.nombre)
                                        .foregroundColor(.black)
                                }
                                .buttonStyle(PlainButtonStyle())
                                .listRowBackground(Color.white)
                            }
                        }

                        // Anuncios
                        Section(header: Text("ANUNCIOS")
                            .font(.system(size: 16))
                            .foregroundColor(.gray)
                        ) {
                            let anuncios = ["Clasificados", "Desplegados", "Esquelas", "Felicitaciones"]
                            ForEach(anuncios, id: \.self) { anuncio in
                                NavigationLink(destination: ClassifiedsView()
                                                .navigationBarBackButtonHidden(true)) {
                                    Text(anuncio)
                                        .foregroundColor(.black)
                                }
                                .buttonStyle(PlainButtonStyle())
                                .listRowBackground(Color.white)
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

                    // Botones “Anúnciate” y “Suscríbete”
                    VStack(spacing: 8) {
                        actionButton(title: "Anúnciate") {
                            if let url = URL(string: "https://www.elsiglodetorreon.com.mx/login/") {
                                UIApplication.shared.open(url)
                            }
                        }

                        actionButton(title: "Suscríbete") {
                            if let url = URL(string: "https://www.elsiglodetorreon.com.mx/suscripcion/") {
                                UIApplication.shared.open(url)
                            }
                        }
                    }
                    .padding(.bottom, 10)
                    .frame(maxWidth: .infinity)
                }
                .frame(maxWidth: 290)
                .padding()
                .background(Color.white)
                .edgesIgnoringSafeArea(.vertical)
            }
        }
    }

    func actionButton(title: String, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            Text(title)
                .font(.headline)
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 12)
                .background(Color.red)
                .cornerRadius(1)
        }
        .buttonStyle(PlainButtonStyle())
        .frame(width: 285)
    }
}
