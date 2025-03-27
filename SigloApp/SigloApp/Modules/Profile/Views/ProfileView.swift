//
//  ProfileView.swift
//  SigloApp
//
//  Created by Macbook Pro 17 i5R on 3/12/25.
//

import SwiftUI

struct ProfileView: View {
    @State private var pushNotificationsEnabled = true
    @AppStorage("isLoggedIn") var isLoggedIn: Bool = false
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                // Header fijo
                if isLoggedIn {
                    // Puedes mostrar info de usuario aquí si está logueado
                } else {
                    HomeHeaderView()
                }

                ScrollView {
                    VStack(alignment: .leading, spacing: 30) {
                        
                        // Sección: Cuenta
                        VStack(alignment: .leading, spacing: 16) {
                            SectionHeader(title: "CUENTA")
                            NavigationRow(title: "Iniciar sesión", destination: LoginView())
                            NavigationRow<EmptyView>(title: "Crear cuenta")

                        }

                        // Sección: Preferencias
                        VStack(alignment: .leading, spacing: 16) {
                            SectionHeader(title: "PREFERENCIAS")

                            ToggleRow(
                                title: "Notificaciones Push",
                                description: "Configura si quieres recibir alerta de El Siglo de Torreón",
                                isOn: $pushNotificationsEnabled
                            )

                            NavigationRow<EmptyView>(
                                title: "Apariencia",
                                trailing: AnyView(Text("AUTOMÁTICO").foregroundColor(.gray))
                            )
                            NavigationRow<EmptyView>(title: "Menú superior")
                        }

                        // Sección: General
                        VStack(alignment: .leading, spacing: 16) {
                            SectionHeader(title: "GENERAL")
                            NavigationRow<EmptyView>(title: "Condiciones del Servicio")
                            NavigationRow<EmptyView>(title: "Política de Privacidad")
                            NavigationRow<EmptyView>(title: "Reportar un problema")
                            NavigationRow<EmptyView>(title: "Califica nuestra APP")
                        }

                        // Redes sociales
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
                            .foregroundColor(.gray)
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
    }

}

