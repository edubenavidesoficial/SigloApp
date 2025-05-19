import SwiftUI

struct ImpresoView: View {
    @StateObject var viewModel = PrintViewModel()
    @State private var pushNotificationsEnabled = true
    @AppStorage("isLoggedIn") var isLoggedIn: Bool = false
    @State private var isMenuOpen: Bool = false
    @State private var selectedOption: MenuOption? = nil

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 0) {
                    
                    // Header con menú
                    HeaderView(
                        selectedOption: $selectedOption,
                        isMenuOpen: $isMenuOpen,
                        isLoggedIn: isLoggedIn
                    )
                    
                    // Si se seleccionó una opción de menú
                    if let selected = selectedOption {
                        NotesView(title: selected.title, selectedOption: $selectedOption)
                            .transition(.move(edge: .trailing))
                    
                    } else {
                        
                        // Selector de pestañas
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 20) {
                                ForEach(TabTypetwo.allCases, id: \.self) { tab in
                                    VStack(spacing: 4) {
                                        Text(tab.rawValue)
                                            .font(.system(size: 14))
                                            .lineLimit(1)
                                            .minimumScaleFactor(0.5)
                                            .fontWeight(viewModel.selectedTab == tab ? .bold : .regular)
                                            .foregroundColor(.primary)
                                            .onTapGesture {
                                                withAnimation {
                                                    viewModel.selectedTab = tab
                                                }
                                            }

                                        Rectangle()
                                            .fill(viewModel.selectedTab == tab ? Color.red : Color.clear)
                                            .frame(height: 2)
                                    }
                                    .padding(.horizontal, 8)
                                }
                            }
                            .padding(.horizontal)
                        }
                        .padding()
                        .background(Color(.systemBackground))

                        Divider()

                        // Contenido según la pestaña seleccionada
                        Group {
                            switch viewModel.selectedTab {
                            case .hemeroteca:
                                PrintCarouselView(viewModel: viewModel)
                                
                            case .suplementos:
                                SuplementsView()
                                
                            case .descargas:
                                DescargasView()
                            }
                        }

                        // Error si lo hay
                        if let errorMessage = viewModel.errorMessage {
                            Text(errorMessage)
                                .foregroundColor(.red)
                                .padding()
                        }

                        Divider()
                    }
                }
            }
            .onAppear {
                viewModel.fetchNewspaper()
            }
        }
    }
}
