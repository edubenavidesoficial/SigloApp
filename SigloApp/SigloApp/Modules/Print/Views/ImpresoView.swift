import SwiftUI

struct ImpresoView: View {
    @StateObject var viewModel = PrintViewModel()
    @State private var pushNotificationsEnabled = true
    @AppStorage("isLoggedIn") var isLoggedIn: Bool = false

    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                HeaderView(isLoggedIn: isLoggedIn) // Se actualiza dinámicamente
                // Picker de pestañas
                Picker("Selecciona una pestaña", selection: $viewModel.selectedTab) {
                    ForEach(TabTypetwo.allCases, id: \.self) { tab in
                        Text(tab.rawValue).tag(tab)
                    }
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding()

                // Carrusel
                PrintCarouselView(viewModel: viewModel)

                // Contenido adicional opcional
                ScrollView {
                    // Aquí puedes agregar más vistas si deseas
                }

                Divider()
            }
        }
    }
}
