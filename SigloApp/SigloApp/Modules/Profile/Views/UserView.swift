import SwiftUI

struct UserView: View {
    @AppStorage("isLoggedIn") private var isLoggedIn: Bool = false
    @State private var isMenuOpen: Bool = false
    @State private var selectedOption: MenuOption? = nil
    @EnvironmentObject var userManager: UserManager
    @StateObject private var viewModel = UserSubscriptionViewModel()

    private var lastConnectionDate: String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "es_ES")
        formatter.dateFormat = "EEEE d 'de' MMMM yyyy 'a las' h:mma"
        return formatter.string(from: Date()).capitalized
    }

    var body: some View {
        NavigationView {
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
                        perfilSection
                        Divider().padding(.vertical)
                        suscripcionSection
                        Divider().padding(.vertical)
                        accionesSection
                        socialFooter
                        Text("CÍA. EDITORA DE LA LAGUNA S.A. DE C.V")
                            .font(.caption)
                            .foregroundColor(.gray)
                            .padding(.top)
                    }
                }
            }
            .navigationBarHidden(true)
        }
        .onAppear {
            if let id = userManager.user?.id {
                viewModel.cargarSuscripcion(usuarioId: id)
            }
        }
    }

    // MARK: –– Subvistas

    private var perfilSection: some View {
        VStack(spacing: 8) {
            // Avatar y desconexión
            Image("user")
                .resizable()
                .frame(width: 80, height: 80)
                .foregroundColor(.gray)
                .onTapGesture {
                    isLoggedIn = false
                }

            // Nombre de usuario
            Text(userManager.user?.usuario.uppercased() ?? "USUARIO")
                .font(.headline)

            // Última conexión
            Text("Última conexión:")
                .font(.subheadline)
                .foregroundColor(.gray)
            Text(lastConnectionDate)
                .font(.subheadline)

            // Datos personales
            Text("Nombre:")
                .font(.headline)
            Text("\(userManager.user?.nombre ?? "") \(userManager.user?.apellidos ?? "")")
                .font(.subheadline)

            Text("Miembro desde hace () años")
                .font(.caption)
                .foregroundColor(.gray)
        }
        .multilineTextAlignment(.center)
        .padding(.top)
    }

    private var suscripcionSection: some View {
        Group {
            if viewModel.isLoading {
                ProgressView("Cargando suscripción...")
                    .padding()
            } else if viewModel.errorMessage != nil {
                Text("No tienes ninguna suscripción")
                    .foregroundColor(.blue)
                    .padding()
            } else if let s = viewModel.suscripcion {
                suscripcionDetalle(s)
            } else {
                Text("No hay información de suscripción.")
                    .foregroundColor(.gray)
                    .padding()
            }
        }
    }

    private func suscripcionDetalle(_ suscripcion: SuscripcionPayload) -> some View {
        HStack(alignment: .top, spacing: 16) {
            AsyncImage(url: URL(string: suscripcion.urlTarjetaImagen ?? "")) { phase in
                switch phase {
                case .empty:
                    ProgressView()
                        .frame(width: 140, height: 180)

                case .success(let img):
                    img
                        .resizable()
                        .scaledToFill()
                        .frame(width: 140, height: 180)
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                        .overlay(
                            VStack(spacing: 2) {
                                // Número sin puntos
                                Text("\(suscripcion.suscripcionDigital.tarjeta)")
                                    .font(.caption)
                                    .foregroundColor(.white)

                                // Texto debajo
                                Text("EL SIGLO DE TORREON")
                                    .font(.system(size: 8, weight: .regular))
                                    .foregroundColor(.white)
                            }
                            .padding(6)
                            .background(Color.black.opacity(0.6))
                            .clipShape(RoundedRectangle(cornerRadius: 4)),
                            alignment: .center
                        )
                        .shadow(radius: 4)

                case .failure:
                    Image("card")
                        .resizable()
                        .scaledToFill()
                        .frame(width: 140, height: 180)
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                        .overlay(
                            VStack(spacing: 2) {
                                Text("\(suscripcion.suscripcionDigital.tarjeta)")
                                    .font(.caption)
                                    .foregroundColor(.white)
                                Text("EL SIGLO DE TORREON")
                                    .font(.system(size: 8, weight: .regular))
                                    .foregroundColor(.white)
                            }
                            .padding(6)
                            .background(Color.black.opacity(0.6))
                            .clipShape(RoundedRectangle(cornerRadius: 4)),
                            alignment: .center
                        )
                        .shadow(radius: 4)

                @unknown default:
                    EmptyView()
                }
            }


            VStack(alignment: .leading, spacing: 6) {
                Text("Información de suscriptor:").fontWeight(.semibold)
                Text("Número de suscriptor:").foregroundColor(.black).fontWeight(.bold)
                Text("\(suscripcion.suscripcionDigital.numero)")
                    .foregroundColor(.red)
                    .fontWeight(.bold)
                Text("Tarifa:").foregroundColor(.black).fontWeight(.bold)
                HStack { Text(suscripcion.suscripcionDigital.periodo ?? "Suscripcion Desconocida") }
                HStack { Text("Vigencia:"); Text(suscripcion.suscripcionDigital.vigencia ?? "00/00/00") }
                HStack {
                    Text("Estado:")
                    let estado = suscripcion.suscripcionDigital.estado ?? "Desconocido"
                    Text(estado)
                        .foregroundColor(estado.lowercased() == "activa" ? .green : .red)
                }

                Link("Suscribirse", destination: URL(string: suscripcion.urlSuscribirse ?? "")!)
                    .foregroundColor(.blue).underline()

                Text("Archivo Digital").foregroundColor(.red).fontWeight(.bold)
                Text("Hemeroteca").foregroundColor(.red).fontWeight(.bold)
            }
            .font(.footnote)
        }
        .padding(.horizontal)
    }

    private var accionesSection: some View {
        VStack(spacing: 0) {
             NavigationLink(destination: Text("Actualizar datos")) {
                HStack {
                    Text("Actualizar datos")
                    Spacer()
                }
            }
            .padding()

            Divider()

            NavigationLink(destination: CommentsView()) {
                HStack {
                    Text("Mis comentarios")
                    Spacer()
                }
            }
            .padding()

            Divider()

            // Cerrar sesión sin negrita
            Button(action: {
                isLoggedIn = false
            }) {
                Button(action: {
                    isLoggedIn = false
                }) {
                    HStack {
                        Text("Cerrar Sesión")
                            .fontWeight(.regular)
                        Spacer()
                    }
                    .padding()
                }
            }
            .buttonStyle(PlainButtonStyle())
        }
        .background(Color.white)
        .cornerRadius(10)
        .padding(.horizontal)
        .foregroundColor(.black)
        .fontWeight(.bold)
    }


    private var socialFooter: some View {
        HStack(spacing: 20) {
            Image("logo.youtube").resizable().frame(width: 20, height: 20)
            Image("logo.facebook").resizable().frame(width: 20, height: 18)
            Image("logo.twitter").resizable().frame(width: 20, height: 20)
            Image("logo.instagram").resizable().frame(width: 20, height: 20)
            Image("logo.tiktok").resizable().frame(width: 20, height: 20)
        }
        .font(.title3)
        .padding(.top)
    }
}
