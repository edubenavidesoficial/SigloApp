import SwiftUI

struct SuplementosView: View {
    @StateObject var viewModel = PrintViewModel()
    @AppStorage("isLoggedIn") var isLoggedIn: Bool = false
    @State private var pushNotificationsEnabled = true
    @State private var isMenuOpen: Bool = false
    @State private var selectedOption: MenuOption? = nil

    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                HeaderView(
                    selectedOption: $selectedOption,
                    isMenuOpen: $isMenuOpen,
                    isLoggedIn: isLoggedIn
                )
                Picker("Selecciona una pestaña", selection: $viewModel.selectedTab) {
                    ForEach(TabTypetwo.allCases, id: \.self) { tab in
                        Text(tab.rawValue).tag(tab)
                    }
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding()

                PrintCarouselView(viewModel: viewModel)
                
                if let errorMessage = viewModel.errorMessage {
                    Text(errorMessage).foregroundColor(.red)
                }

                ScrollView { }

                Divider()
            }
        }
        .onAppear { viewModel.fetchNewspaper() // Se recarga cada vez que se entra a la vista
        }
    }
}
