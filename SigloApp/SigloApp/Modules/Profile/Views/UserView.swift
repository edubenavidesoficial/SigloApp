//
//  UserView.swift
//  SigloApp
//
//  Created by Macbook Pro 17 i5R on 3/14/25.
//

import SwiftUI

struct UserView: View {
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    
                    // Encabezado
                    VStack(spacing: 8) {
                        Image("user")
                            .resizable()
                            .frame(width: 80, height: 80)
                            .foregroundColor(.gray)
                        
                        Text("USUARIO 28")
                            .font(.headline)
                        
                        Text("Última conexión:")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                        Text("Viernes 18 de octubre 2024 a las 12:15PM")
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
                        
                        Text("El Siglo de Torreón")
                            .font(.subheadline)
                        
                        Text("Miembro desde hace 3 Años.")
                            .font(.caption)
                            .foregroundColor(.gray)
                    }
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)

                    // Tarjeta e información de suscripción
                    HStack(alignment: .top, spacing: 16) {
                        Image("card_mock") // Asegúrate de tener esta imagen en tus Assets
                            .resizable()
                            .frame(width: 140, height: 90)
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
                              //  Image(systemName: "chevron.right")
                            }
                            .padding()
                        }
                        Divider()
                        NavigationLink(destination: Text("Mis comentarios")) {
                            HStack {
                                Text("Mis comentarios")
                                Spacer()
                               // Image(systemName: "chevron.right")
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
                        Image(systemName: "play.rectangle") // YouTube
                        Image(systemName: "f.square") // Facebook
                        Image(systemName: "bird") // Twitter/X
                        Image(systemName: "camera") // Instagram
                        Image(systemName: "music.note") // TikTok
                    }
                    .font(.title3)
                    .padding(.top)

                    // Pie de página
                    Text("CÍA. EDITORA DE LA LAGUNA S.A. DE C.V")
                        .font(.caption)
                        .foregroundColor(.gray)
                        .padding(.bottom, 30)
                }
                .padding(.top)
            }
        }
    }
}
