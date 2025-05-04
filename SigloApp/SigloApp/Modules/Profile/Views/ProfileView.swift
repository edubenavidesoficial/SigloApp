import SwiftUI

struct ProfileView: View {
    @State private var pushNotificationsEnabled = true
    @AppStorage("isLoggedIn") var isLoggedIn: Bool = false
    @State private var isMenuOpen: Bool = false
    @State private var selectedOption: MenuOption? = nil
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                ScrollView {
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
                        VStack(alignment: .leading, spacing: 30) {
                            
                            // Sección: Cuenta
                            VStack(alignment: .leading, spacing: 16) {
                                SectionHeader(title: "CUENTA")
                                NavigationRow(title: "Iniciar sesión", destination: LoginView())
                                NavigationRow(title: "Crear cuenta", destination:
                                    WebView(url: URL(string: "https://www.elsiglodetorreon.com.mx/login/")!)
                                        .navigationTitle("Crear cuenta")
                                        .navigationBarTitleDisplayMode(.inline)
                                )
                            }
                            
                            // Sección: Preferencias
                            VStack(alignment: .leading, spacing: 16) {
                                SectionHeader(title: "PREFERENCIAS")
                                
                                ToggleRow(
                                    title: "Notificaciones Push",
                                    description: "Configura si quieres recibir alerta de El Siglo de Torreón",
                                    isOn: $pushNotificationsEnabled
                                )
                                NavigationRow(title: "Apariencia", destination: ThemeView())
                                NavigationRow(title: "Menú superior", destination: MenuTopView())
                            }
                            
                            // Sección: General
                            VStack(alignment: .leading, spacing: 16) {
                                SectionHeader(title: "GENERAL")
                                NavigationRow<EmptyView>(title: "Condiciones del Servicio")
                                NavigationRow<EmptyView>(title: "Política de Privacidad")
                                NavigationRow<EmptyView>(title: "Reportar un problema")
                                NavigationRow<EmptyView>(title: "Califica nuestra APP")
                            }
                            
                            // Redes sociales.
                            HStack(spacing: 20) {
                                Image("logo.youtube").resizable().frame(width: 20, height: 20)
                                Image("logo.facebook").resizable().frame(width: 20, height: 18)
                                Image("logo.twitter").resizable().frame(width: 20, height: 20)
                                Image("logo.instagram").resizable().frame(width: 20, height: 20)
                                Image("logo.tiktok").resizable().frame(width: 20, height: 20)
                            }
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 8)
                            .multilineTextAlignment(.center)
                            
                            Text("CÍA. EDITORA DE LA LAGUNA S.A. DE C.V.")
                                .font(.caption2)
                                .foregroundColor(.secondary) // Cambia de color con el tema
                                .frame(maxWidth: .infinity)
                                .multilineTextAlignment(.center)
                                .padding(.bottom, 10)
                        }
                        .padding(.horizontal)
                        .padding(.top, 16)
                    }
                    
                    Divider()
                }
                .navigationBarHidden(true)
            }
            .background(Color(.systemBackground)) // Fondo que cambia según el tema
        }
    }
}
