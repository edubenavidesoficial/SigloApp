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
                        .padding(.top, 10)

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
                    List(viewModel.secciones, id: \.id) { seccion in
                        NavigationLink(destination: SectionDetailView(payload: seccion)) {
                            Text(seccion.nombre)
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
                .cornerRadius(8)
        }
    }
}
