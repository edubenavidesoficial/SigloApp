import SwiftUI

struct ImpresoView: View {
    @StateObject var viewModel = PrintViewModel()
    @State private var pushNotificationsEnabled = true
    @AppStorage("isLoggedIn") var isLoggedIn: Bool = false
    @State private var isMenuOpen: Bool = false
    @State private var selectedOption: MenuOption? = nil

    var body: some View {
        ZStack(alignment: .bottom) {
            NavigationView {
                ScrollView {
                    VStack(spacing: 0) {

                        // Header con menú
                        HeaderView(
                            selectedOption: $selectedOption,
                            isMenuOpen: $isMenuOpen,
                            isLoggedIn: isLoggedIn
                        )

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

                            // Contenido según pestaña
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
                .blur(radius: isLoggedIn ? 0 : 8)
                .disabled(!isLoggedIn)
                .onAppear {
                    if !viewModel.isNewspaperLoaded {
                        viewModel.fetchNewspaper()
                    }
                }
                .onChange(of: viewModel.selectedTab) { newTab in
                    if newTab == .hemeroteca && !viewModel.isNewspaperLoaded {
                        viewModel.fetchNewspaper()
                    }
                }
            }

            // Panel inferior si no ha iniciado sesión
            if !isLoggedIn {
                VStack(spacing: 16) {
                    Text("ESTE CONTENIDO ES SOLO PARA SUSCRIPTORES")
                        .font(.headline)
                        .multilineTextAlignment(.center)
                        .foregroundColor(.primary)

                    Button(action: {
                        print("Ir a página de suscripción")
                    }) {
                        Text("SUSCRÍBETE")
                            .foregroundColor(.white)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.red)
                    }

                    Button(action: {
                        print("Ir a inicio de sesión")
                    }) {
                        Text("YA SOY SUSCRIPTOR")
                            .underline()
                            .foregroundColor(.primary)
                    }
                }
                .padding()
                .background(.ultraThinMaterial)
                .cornerRadius(8)
                .padding()
                .transition(.move(edge: .bottom))
                .animation(.easeInOut, value: isLoggedIn)
            }
        }
    }
}
