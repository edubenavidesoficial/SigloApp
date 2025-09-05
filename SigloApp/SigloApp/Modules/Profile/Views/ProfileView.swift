import SwiftUI
import FirebaseMessaging

struct ProfileView: View {
    @AppStorage("pushNotificationsEnabled") private var pushNotificationsEnabled = true
    @AppStorage("isLoggedIn") var isLoggedIn: Bool = false
    @State private var showRatingSheet = false
    @State private var rating: Int = 0
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
                                
                                Toggle("Notificaciones Push", isOn: $pushNotificationsEnabled)
                                    .onChange(of: pushNotificationsEnabled) { newValue in
                                        Task {
                                            // Obtener token FCM actual
                                            if let fcmToken = Messaging.messaging().fcmToken,
                                               let authToken = TokenService.shared.getStoredToken() {
                                                let base64Token = fcmToken.data(using: .utf8)?.base64EncodedString() ?? ""
                                                await PushToggleService.setPush(
                                                    enabled: newValue,
                                                    tokenBase64: base64Token,
                                                    authToken: authToken
                                                )
                                            } else {
                                                print("❌ No hay FCM token o authToken disponible")
                                            }
                                        }
                                    }
                                NavigationRow(title: "Apariencia", destination: ThemeView())
                                NavigationRow(title: "Menú superior", destination: MenuTopView())
                                NavigationRow(title: "Tamano de letra", destination: FontSizeView())
                            }
                            
                            // Sección: General
                            VStack(alignment: .leading, spacing: 16) {
                                SectionHeader(title: "GENERAL")
                                
                                NavigationRow(title: "Condiciones del Servicio", destination:
                                    WebView(url: URL(string: "https://www.elsiglodetorreon.com.mx/archivos/terminos/")!)
                                        .navigationTitle("Condiciones del Servicio")
                                        .navigationBarTitleDisplayMode(.inline)
                                )
                                
                                NavigationRow(title: "Política de Privacidad", destination:
                                    WebView(url: URL(string: "https://www.elsiglodetorreon.com.mx/archivos/privacidad/")!)
                                        .navigationTitle("Política de Privacidad")
                                        .navigationBarTitleDisplayMode(.inline)
                                )
                                
                                NavigationRow(title: "Reportar un problema", destination:
                                    WebView(url: URL(string: "https://www.elsiglodetorreon.com.mx/contacto/")!)
                                        .navigationTitle("Reportar un problema")
                                        .navigationBarTitleDisplayMode(.inline)
                                )
                                
                                NavigationRow(title: "Califica nuestra APP", destination:
                                    WebView(url: URL(string: "https://apps.apple.com/")!)
                                        .navigationTitle("Califica nuestra APP")
                                        .navigationBarTitleDisplayMode(.inline)
                                )

                            }

                            .sheet(isPresented: $showRatingSheet) {
                                VStack(spacing: 20) {
                                    Text("Califica nuestra APP")
                                        .font(.headline)

                                    // Mostrar estrellas
                                    HStack {
                                        ForEach(1...5, id: \.self) { index in
                                            Image(systemName: index <= rating ? "star.fill" : "star")
                                                .resizable()
                                                .frame(width: 30, height: 30)
                                                .foregroundColor(.yellow)
                                                .onTapGesture {
                                                    rating = index
                                                }
                                        }
                                    }

                                    HStack(spacing: 30) {
                                        Button("Cancelar") {
                                            showRatingSheet = false
                                        }
                                        .foregroundColor(.red)

                                        Button("Enviar") {
                                            // Aquí podrías enviar la calificación al servidor
                                            print("Rating enviado: \(rating) estrellas")
                                            showRatingSheet = false
                                        }
                                        .foregroundColor(.blue)
                                    }
                                }
                                .padding()
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
