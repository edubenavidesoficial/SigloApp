import SwiftUI

struct LoginView: View {
    @State private var username: String = "clientesactivos4@gmail.com"
    @State private var password: String = "@‌PRUEBAMARIO2024%$"
    @State private var showPassword: Bool = false
    @State private var showAlert: Bool = false
    @State private var alertMessage: String = "Alerta!"

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            HeaderView()

            ScrollView(.vertical, showsIndicators: false) {
                HStack {
                    Image("logo")
                        .resizable()
                        .frame(width: 80, height: 80)
                    Spacer()
                }

                (
                    Text("¿Aún no tienes cuenta? ")
                        .font(.subheadline)
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
                        .foregroundColor(.black)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.clear)
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color.black, lineWidth: 0.5)
                        )
                        .cornerRadius(10)
                        .autocapitalization(.none)

                    ZStack(alignment: .trailing) {
                        if showPassword {
                            TextField("Contraseña", text: $password)
                        } else {
                            SecureField("Contraseña", text: $password)
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
                    .frame(maxWidth: .infinity)
                    .background(Color.clear)
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color.black, lineWidth: 0.5)
                    )
                    .cornerRadius(10)
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
                    .font(.footnote)
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

                Text("Si continúas, aceptas nuestras Condiciones del Servicio y la Política de Privacidad.")
                    .font(.footnote)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)

                HStack(spacing: 20) {
                    Image("logo.youtube")
                        .resizable()
                        .frame(width: 20, height: 20)
                    Image("logo.facebook")
                        .resizable()
                        .frame(width: 20, height: 20)
                    Image("logo.twitter")
                        .resizable()
                        .frame(width: 20, height: 20)
                    Image("logo.instagram")
                        .resizable()
                        .frame(width: 20, height: 20)
                    Image("logo.tiktok")
                        .resizable()
                        .frame(width: 20, height: 20)
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 8)
                .multilineTextAlignment(.center)

                Text("CÍA. EDITORA DE LA LAGUNA S.A. DE C.V.")
                    .font(.caption2)
                    .foregroundColor(.gray)
                    .frame(maxWidth: .infinity)
                    .multilineTextAlignment(.center)
                    .padding(.bottom, 10)
            }
            .padding()
        }
        .background(Color.white)
        .ignoresSafeArea(.keyboard, edges: .bottom)
        .alert(isPresented: $showAlert) {
            Alert(title: Text("Login"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
        }
    }

    func login() {
        guard !username.isEmpty, !password.isEmpty else {
            alertMessage = "Por favor completa usuario y contraseña."
            showAlert = true
            return
        }

        LoginService.login(correo: username, password: password) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let data):
                    if let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                        print("✅ Login exitoso: \(json)")
                        UserDefaults.standard.set(true, forKey: "isLoggedIn")
                        alertMessage = "Inicio de sesión exitoso"
                    } else {
                        alertMessage = "Error al procesar respuesta del servidor."
                    }
                    showAlert = true
                case .failure(let error):
                    alertMessage = "Error de conexión: \(error.localizedDescription)"
                    showAlert = true
                }
            }
        }
    }
}
