import SwiftUI

struct SectionsView: View {
    @StateObject private var viewModel = SectionListViewModel()


    var body: some View {
        NavigationView {
            List(viewModel.secciones, id: \.id) { seccion in
                NavigationLink(destination: SectionDetailView(payload: seccion)) {
                    Text(seccion.nombre)
                }
            }
            .navigationTitle("Secciones")
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
        }
    }
}
