//
//  TabsLayoutView.swift
//  SigloApp
//
//  Created by Macbook Pro 17 i5R on 3/11/25.
//
import SwiftUI

struct TabsLayoutView: View {
    @Environment(\.presentationMode) var presentationMode
    var body: some View {
        VStack {
            HeaderView() {
                presentationMode.wrappedValue.dismiss()
            }

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

                UserView()
                    .tabItem {
                        Image("ico_user")
                        Text("PERFIL")
                    }
            }
            .accentColor(.brown)
        }
    }
}
