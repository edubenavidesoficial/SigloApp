import SwiftUI

struct LoginView: View {
    @MainActor
    @AppStorage("isLoggedIn") var isLoggedIn: Bool = false
    @AppStorage("lastUsername") var lastUsername: String = ""
    @EnvironmentObject var userManager: UserManager
    @State private var username: String = "desarrollo01@elsiglo.mx"
    @State private var password: String = "Desiglo01"
    @State private var showPassword: Bool = false
    @State private var showAlert: Bool = false
    @State private var alertMessage: String = "Alerta!"
    @State private var isLoading: Bool = false

    @FocusState private var focusedField: Field?

    enum Field {
        case username
        case password
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {

            ScrollView(.vertical, showsIndicators: false) {
                HStack {
                    Image("logo")
                        .resizable()
                        .frame(width: 80, height: 80)
                    Spacer()
                }

                (
                    Text("¿Aún no tienes cuenta? ")
                        .font(.custom("FiraSansCondensed-Regular", size: 15))
                        .foregroundColor(.gray)
                    +
                    Text("Regístrate aquí")
                        .font(.subheadline)
                        .fontWeight(.bold)
                        .foregroundColor(.black)
                )
                .multilineTextAlignment(.leading)

                VStack(spacing: 10) {
                    TextField("Usuario", text: $username)
                        .focused($focusedField, equals: .username)
                        .submitLabel(.next)
                        .onSubmit {
                            focusedField = .password
                        }
                        .foregroundColor(.black)
                        .padding()
                        .background(Color.clear)
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color.black, lineWidth: 0.5)
                        )
                        .autocapitalization(.none)

                    ZStack(alignment: .trailing) {
                        Group {
                            if showPassword {
                                TextField("Contraseña", text: $password)
                            } else {
                                SecureField("Contraseña", text: $password)
                            }
                        }
                        .focused($focusedField, equals: .password)
                        .submitLabel(.done)
                        .onSubmit {
                            login()
                        }

                        Button(action: {
                            showPassword.toggle()
                        }) {
                            Image(systemName: showPassword ? "eye.slash.fill" : "eye.fill")
                                .foregroundColor(.gray)
                        }
                    }
                    .foregroundColor(.black)
                    .padding()
                    .background(Color.clear)
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color.black, lineWidth: 0.5)
                    )
                }

                if isLoading {
                    ProgressView()
                        .padding()
                }

                Button(action: {
                    login()
                }) {
                    Text("INGRESAR")
                        .fontWeight(.bold)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.black)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }

                Text("¿Olvidaste tu contraseña?")
                    .foregroundColor(.red)
                    .font(.custom("FiraSansCondensed-Regular", size: 15))
                    .padding(.top, 4)

                Divider()

                Button(action: {}) {
                    HStack {
                        Image(systemName: "apple.logo")
                        Text("Continuar con Apple")
                    }
                    .foregroundColor(.black)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.clear)
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color.black, lineWidth: 0.5)
                    )
                    .cornerRadius(10)
                    .padding(.top, 20)
                }

                Button(action: {}) {
                    HStack {
                        Image(systemName: "globe")
                        Text("Continuar con Google")
                    }
                    .foregroundColor(.black)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.clear)
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color.black, lineWidth: 0.5)
                    )
                    .cornerRadius(10)
                }
                .padding(.top, 10)
                Text("Si continúas, aceptas nuestras Condiciones del Servicio y la Política de Privacidad.")
                    .font(.custom("FiraSansCondensed-Regular", size: 15))
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)

                HStack(spacing: 20) {
                    Image("logo.youtube").resizable().frame(width: 20, height: 20)
                    Image("logo.facebook").resizable().frame(width: 20, height: 20)
                    Image("logo.twitter").resizable().frame(width: 20, height: 20)
                    Image("logo.instagram").resizable().frame(width: 20, height: 20)
                    Image("logo.tiktok").resizable().frame(width: 20, height: 20)
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 8)

                Text("CÍA. EDITORA DE LA LAGUNA S.A. DE C.V.")
                    .font(.caption2)
                    .foregroundColor(.gray)
                    .frame(maxWidth: .infinity)
                    .multilineTextAlignment(.center)
                    .padding(.bottom, 10)
            }
            .navigationBarHidden(true)
            .navigationBarBackButtonHidden(true) 
            .padding()
        }
        .background(Color.white)
        .ignoresSafeArea(.keyboard, edges: .bottom)
        .alert(isPresented: $showAlert) {
            Alert(title: Text("Login"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
        }
    }
    @MainActor
    func login() {
        guard !username.isEmpty, !password.isEmpty else {
            alertMessage = "Por favor completa usuario y contraseña."
            showAlert = true
            return
        }

        isLoading = true

        Task {
            do {
                // Llamas al servicio async para login, devuelve UserPayload
                let userPayload = try await LoginService.login(username: username, password: password)
                
                // Guardas usuario en UserManager
                userManager.user = userPayload
                
                // Guardas usuario serializado en UserDefaults
                userManager.saveUserToDefaults()
                
                // Guardas el último usuario en AppStorage para mostrarlo luego si quieres
                lastUsername = username
                
                // Cambias estado de login para que la app navegue a la siguiente pantalla
                isLoggedIn = true
                
                alertMessage = "Inicio de sesión exitoso"
            } catch {
                alertMessage = "Error: \(error.localizedDescription)"
            }

            isLoading = false
            showAlert = true
        }
    }

}
