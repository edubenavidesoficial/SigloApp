//
//  TabsLayoutView.swift
//  SigloApp
//
//  Created by Macbook Pro 17 i5R on 3/11/25.
//
import SwiftUI

struct TabsHomeLayoutView: View {
    @Environment(\.presentationMode) var presentationMode
    var body: some View {
        VStack {

            TabView {
                HomeView()
                    .tabItem {
                        Image("ico_siglo")
                        Text("PORTADA")
                    }

                ImpresoView()
                    .tabItem {
                        Image("ico_print")
                        Text("IMPRESO")
                    }

                SavedView()
                    .tabItem {
                        Image("ico_save")
                        Text("GUARDADO")
                    }

                ProfileView()
                    .tabItem {
                        Image("ico_user")
                        Text("PERFIL")
                    }
            }
            .accentColor(.brown)
        }
    }
}
