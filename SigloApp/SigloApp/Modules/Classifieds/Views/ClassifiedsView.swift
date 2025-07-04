import SwiftUI

struct ClassifiedsView: View {
    @StateObject private var classifiedsVM = ClassifiedsViewModel()
    @StateObject private var subVM = UserSubscriptionViewModel()
    @EnvironmentObject var userManager: UserManager
    @AppStorage("isLoggedIn") var isLoggedIn: Bool = false
    @State private var isMenuOpen: Bool = false
    @State private var selectedOption: MenuOption? = nil

    // Estado para mostrar u ocultar filtro categorías
    @State private var showCategories = false

    var body: some View {
        ZStack(alignment: .bottom) {
            NavigationStack {
                ScrollView {
                    VStack(spacing: 0) {
                        HeaderView(
                            selectedOption: $selectedOption,
                            isMenuOpen: $isMenuOpen,
                            isLoggedIn: isLoggedIn
                        )

                        if let selected = selectedOption {
                            NotesView(title: selected.title, selectedOption: $selectedOption)
                                .transition(.move(edge: .trailing))
                        } else {
                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack(spacing: 20) {
                                    ForEach(TabClassifieds.allCases) { tab in
                                        VStack(spacing: 4) {
                                            Text(tab.rawValue)
                                                .font(.system(size: 14))
                                                .lineLimit(1)
                                                .minimumScaleFactor(0.5)
                                                .fontWeight(classifiedsVM.selectedTab == tab ? .bold : .regular)
                                                .foregroundColor(.primary)
                                                .onTapGesture {
                                                    withAnimation {
                                                        classifiedsVM.selectedTab = tab
                                                    }
                                                }

                                            Rectangle()
                                                .fill(classifiedsVM.selectedTab == tab ? Color.red : Color.clear)
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

                            // Botón filtro con borde solo y texto en mayúsculas
                            HStack {
                                Button(action: {
                                    withAnimation {
                                   showCategories.toggle()
                                    }
                                }) {
                                    HStack(spacing: 6) {
                                        Text("CATEGORÍA")
                                            .foregroundColor(.black)
                                            .font(.subheadline)
                                            .bold()
                                        Image(systemName: showCategories ? "chevron.up" : "chevron.down")
                                            .foregroundColor(.gray)
                                    }
                                    .padding(.vertical, 8)
                                    .padding(.horizontal, 12)
                                    .overlay(
                                        Rectangle()
                                            .frame(width: 1)
                                            .foregroundColor(Color.gray.opacity(0.5)),
                                        alignment: .trailing
                                    )
                                }

                                // Mostrar categoría seleccionada como botón alineado a la derecha
                                if let selected = classifiedsVM.selectedCategory {
                                    Text(selected.uppercased())
                                        .font(.caption)
                                        .padding(.horizontal, 10)
                                        .padding(.vertical, 6)
                                        .background(Color.gray.opacity(0.2))
                                        .cornerRadius(6)
                                        .onTapGesture {
                                            withAnimation {
                                                classifiedsVM.selectedCategory = nil
                                            }
                                        }
                                        .transition(.opacity)
                                }

                                Spacer()
                            }
                            .padding(.horizontal)
                            .padding(.bottom, 4)

                            Divider()

                            // Vista principal que depende de la pestaña
                            Group {
                                switch classifiedsVM.selectedTab {
                                case .avisos:
                                    AvisosCarouselView(
                                        viewModel: classifiedsVM,
                                        filterCategory: classifiedsVM.selectedCategory
                                    )
                                case .desplegados:
                                    Text("DESPLEGADOS")
                                case .esquelas:
                                    Text("ESQUELAS")
                                case .anunciate:
                                    Text("ANUNCIATE")
                                }
                            }
                            

                            // Filtro de categorías tipo radio buttons cuadrados negros en mayúsculas
                            if showCategories {
                                VStack(alignment: .leading, spacing: 12) {
                                    // Botón "X" para cerrar alineado a la izquierda
                                    HStack {
                                        Button(action: {
                                            withAnimation {
                                                showCategories = false
                                            }
                                        }) {
                                            Image(systemName: "xmark.circle.fill")
                                                .foregroundColor(.gray)
                                                .font(.title2)
                                        }
                                        Spacer()
                                    }
                                    .padding(.horizontal)

                                    ForEach(classifiedsVM.avisos.map { $0.title.uppercased() }, id: \.self) { category in
                                        HStack {
                                            // Radio button cuadrado negro
                                            Image(systemName: classifiedsVM.selectedCategory?.uppercased() == category ? "checkmark.square.fill" : "square")
                                                .foregroundColor(.black)

                                            Text(category)
                                                .font(.subheadline)
                                                .bold()
                                                .onTapGesture {
                                                    withAnimation {
                                                        classifiedsVM.selectedCategory = category
                                                    }
                                                }
                                            Spacer()
                                        }
                                        .padding(.horizontal)
                                    }

                                    // Botones para limpiar filtro y cerrar filtro
                                    HStack {
                                        if classifiedsVM.selectedCategory != nil {
                                            Button("LIMPIAR FILTRO") {
                                                withAnimation {
                                                    classifiedsVM.selectedCategory = nil
                                                }
                                            }
                                            .foregroundColor(.blue)
                                            .bold()
                                        }

                                        Spacer()

                                        Button("CERRAR") {
                                            withAnimation {
                                                showCategories = false
                                            }
                                        }
                                        .bold()
                                    }
                                    .padding(.horizontal)
                                    .padding(.top, 10)
                                }
                                .padding(.vertical)
                                .background(Color(.systemBackground))
                                .padding(.horizontal)
                                .transition(.move(edge: .top))
                            }

                            if let errorMessage = classifiedsVM.errorMessage {
                                Text(errorMessage)
                                    .foregroundColor(.red)
                                    .padding()
                            }

                            Divider()
                        }
                    }
                }
                .onAppear {
                    if let userId = userManager.user?.id {
                        subVM.cargarSuscripcion(usuarioId: userId)
                    }
                    if !classifiedsVM.isNewspaperLoaded {
                        classifiedsVM.fetchClassifiedCategories()
                    }
                }
            }

            // Restricción por suscripción
            let estado = subVM.suscripcion?.suscripcionDigital.estado?.lowercased() ?? ""
            let isSubscriber = subVM.suscripcion?.suscriptor == true && estado == "activa"

            if !isLoggedIn || !isSubscriber {
                VStack(spacing: 16) {
                    Text("ESTE CONTENIDO ES SOLO PARA SUSCRIPTORES")
                        .font(.headline)
                        .multilineTextAlignment(.center)

                    subscriptionButton

                    Button("YA SOY SUSCRIPTOR") {
                        // Acción
                    }
                    .underline()
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

    // Botón de suscripción
    @ViewBuilder
    var subscriptionButton: some View {
        if !isLoggedIn {
            if let url = URL(string: "https://www.elsiglodetorreon.com.mx/suscripcion/") {
                Link("SUSCRÍBETE", destination: url)
                    .foregroundColor(.white)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.red)
                    .cornerRadius(8)
            }
        } else if (subVM.suscripcion?.suscripcionDigital.estado?.lowercased() ?? "") != "activa" {
            if let urlString = subVM.suscripcion?.urlSuscribirse,
               let url = URL(string: urlString) {
                Link("SUSCRÍBETE", destination: url)
                    .foregroundColor(.white)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.red)
                    .cornerRadius(8)
            }
        }
    }
}

