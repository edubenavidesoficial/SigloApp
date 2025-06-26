import SwiftUI


struct UserView: View {
    @AppStorage("isLoggedIn") private var isLoggedIn: Bool = false
    @AppStorage("lastUsername") private var lastUsername: String = "Usuario"
    @State private var isMenuOpen: Bool = false
    @State private var selectedOption: MenuOption? = nil
    @EnvironmentObject var userManager: UserManager
    
    @StateObject private var viewModel = UserSubscriptionViewModel()
    
    private var lastConnectionDate: String {
        let date = Date()
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "es_ES")
        formatter.dateFormat = "EEEE d 'de' MMMM yyyy 'a las' h:mma"
        return formatter.string(from: date).capitalized
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
                        VStack(spacing: 0) {
                            Image("user")
                                .resizable()
                                .frame(width: 80, height: 80)
                                .foregroundColor(.gray)
                                .onTapGesture {
                                    UserDefaults.standard.set(false, forKey: "isLoggedIn")
                                    print("🔴 Sesión cerrada desde UserView")
                                    isLoggedIn = false
                                }
                            
                            Text(userManager.user?.usuario.uppercased() ?? "USUARIO")
                                .font(.headline)
                            
                            Text("Última conexión:")
                                .font(.subheadline)
                                .foregroundColor(.gray)
                            Text(lastConnectionDate)
                                .font(.subheadline)
                        }
                        .multilineTextAlignment(.center)
                        .padding(.top)
                        
                        Divider()
                        
                        VStack(spacing: 4) {
                            Text("Nombre:")
                                .font(.subheadline)
                                .fontWeight(.semibold)
                            Text("\(userManager.user?.nombre ?? "") \(userManager.user?.apellidos ?? "")")
                                .font(.subheadline)
                            Text("Miembro desde hace [] Años.")
                                .font(.caption)
                                .foregroundColor(.gray)
                        }
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)
                        
                        Divider()
                            .padding(.vertical)
                        
                        // Aquí mostramos la info de suscripción con el ViewModel
                        if viewModel.isLoading {
                            ProgressView("Cargando suscripción...")
                                .padding()
                        } else if let error = viewModel.errorMessage {
                            Text("Error al cargar suscripción: \(error)")
                                .foregroundColor(.blue)
                                .padding()
                        } else if let suscripcion = viewModel.suscripcion {
                            HStack(alignment: .top, spacing: 16) {
                                // Imagen tarjeta real (async)
                                if let url = URL(string: suscripcion.urlTarjetaImagen) {
                                    AsyncImage(url: url) { phase in
                                        switch phase {
                                        case .empty:
                                            ProgressView()
                                        case .success(let image):
                                            image
                                                .resizable()
                                                .scaledToFit()
                                                .frame(width: 140, height: 180)
                                                .cornerRadius(8)
                                        case .failure:
                                            Image("card")
                                                .resizable()
                                                .frame(width: 140, height: 180)
                                                .cornerRadius(8)
                                        @unknown default:
                                            EmptyView()
                                        }
                                    }
                                } else {
                                    Image("card")
                                        .resizable()
                                        .frame(width: 140, height: 180)
                                        .cornerRadius(8)
                                }
                                
                                VStack(alignment: .leading, spacing: 6) {
                                    Text("Información de suscriptor:")
                                        .fontWeight(.semibold)
                                    
                                    Text("Número de suscriptor:")
                                    Text("\(suscripcion.id)")
                                        .foregroundColor(.red)
                                        .fontWeight(.bold)
                                    
                                    Text("Tarifa:")
                                    Text(suscripcion.suscripcionImpresa.periodo)
                                    
                                    Text("Periodo:")
                                    Text("Vigencia: \(suscripcion.suscripcionImpresa.vigencia)")
                                    
                                    Text("Estado:")
                                    Text(suscripcion.suscripcionImpresa.estado)
                                        .foregroundColor(suscripcion.suscripcionImpresa.estado.lowercased() == "activa" ? .green : .red)
                                    
                                    Link("Suscribirse", destination: URL(string: suscripcion.urlSuscribirse)!)
                                        .foregroundColor(.blue)
                                        .underline()
                                    
                                    Text("Archivo Digital")
                                        .foregroundColor(.red)
                                        .fontWeight(.bold)
                                    Text("Hemeroteca")
                                        .foregroundColor(.red)
                                        .fontWeight(.bold)
                                }
                                .font(.footnote)
                            }
                            .padding(.horizontal)
                        } else {
                            Text("No hay información de suscripción.")
                                .foregroundColor(.gray)
                                .padding()
                        }
                        
                        Divider()
                            .padding(.vertical)
                        
                        VStack(spacing: 0) {
                            NavigationLink(destination: Text("Actualizar datos")) {
                                HStack {
                                    Text("Actualizar datos")
                                    Spacer()
                                }
                                .padding()
                            }
                            Divider()
                           
                            NavigationLink(destination: CommentsView()) {
                                HStack {
                                    Text("Mis comentarios")
                                    Spacer()
                                }
                                .padding()
                            }
                        }
                        .background(Color.white)
                        .cornerRadius(10)
                        .padding(.horizontal)
                        .foregroundColor(.black)
                        .fontWeight(.bold)
                        
                        HStack(spacing: 20) {
                            Image("logo.youtube").resizable().frame(width: 20, height: 20)
                            Image("logo.facebook").resizable().frame(width: 20, height: 18)
                            Image("logo.twitter").resizable().frame(width: 20, height: 20)
                            Image("logo.instagram").resizable().frame(width: 20, height: 20)
                            Image("logo.tiktok").resizable().frame(width: 20, height: 20)
                        }
                        .font(.title3)
                        .padding(.top)
                        
                        Text("CÍA. EDITORA DE LA LAGUNA S.A. DE C.V")
                            .font(.caption)
                            .foregroundColor(.gray)
                            .padding(.bottom, 30)
                    }
                }
            }
            .navigationBarHidden(true)
        }
        .onAppear {
            print("👤 userManager.user: \(String(describing: userManager.user))")
            
            if let id = userManager.user?.id {
                print("🔑 Usuario ID obtenido desde UserManager: \(id)")
                viewModel.cargarSuscripcion(usuarioId: id)
            } else {
                print("⚠️ No se encontró el ID del usuario.")
            }
        }

    }
}
