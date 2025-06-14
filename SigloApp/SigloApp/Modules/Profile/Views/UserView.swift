import SwiftUI

struct UserView: View {
    @AppStorage("isLoggedIn") private var isLoggedIn: Bool = false
    @AppStorage("lastUsername") private var lastUsername: String = "Usuario"
    @State private var isMenuOpen: Bool = false
    @State private var selectedOption: MenuOption? = nil
    @EnvironmentObject var userManager: UserManager
    
    private var lastConnectionDate: String {
        "Viernes 11 de abril 2025 a las 12:15PM"
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
                    }
                    else {
                        VStack(spacing: 0) {
                            Image("user")
                                .resizable()
                                .frame(width: 80, height: 80)
                                .foregroundColor(.gray)
                            
                            Text(userManager.user?.usuario ?? "USUARIO")
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
                        
                        // Información del usuario
                        VStack(spacing: 4) {
                            Text("Nombre:")
                                .font(.subheadline)
                                .fontWeight(.semibold)
                            
                            Text("\(userManager.user?.nombre ?? "") \(userManager.user?.apellidos ?? "")")
                                .font(.subheadline)
                            
                            Text("Miembro desde hace 3 Años.")
                                .font(.caption)
                                .foregroundColor(.gray)
                        }
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)
                        
                        // Tarjeta e información de suscripción
                        HStack(alignment: .top, spacing: 16) {
                            Image("card")
                                .resizable()
                                .frame(width: 140, height: 180)
                                .cornerRadius(8)
                            
                            VStack(alignment: .leading, spacing: 4) {
                                Text("Información de suscriptor:")
                                    .fontWeight(.semibold)
                                
                                Text("Número de suscriptor:")
                                Text("4951")
                                    .foregroundColor(.red)
                                    .fontWeight(.bold)
                                
                                Text("Tarifa:")
                                Text("Suscripción Anual")
                                Text("Periodo: 15/01/2024 - 14/01/2025")
                                
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
                        
                        // Opciones adicionales
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
                        
                        // Redes sociales
                        HStack(spacing: 20) {
                            Image("logo.youtube").resizable().frame(width: 20, height: 20)
                            Image("logo.facebook").resizable().frame(width: 20, height: 18)
                            Image("logo.twitter").resizable().frame(width: 20, height: 20)
                            Image("logo.instagram").resizable().frame(width: 20, height: 20)
                            Image("logo.tiktok").resizable().frame(width: 20, height: 20)
                        }
                        .font(.title3)
                        .padding(.top)
                        
                        // Pie de página
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
            print("User en UserView al aparecer: \(String(describing: userManager.user))")
        }

    }
}


