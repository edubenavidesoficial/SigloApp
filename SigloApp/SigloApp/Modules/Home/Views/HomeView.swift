//
//  HomeView.swift
//  SigloApp
//
//  Created by Macbook Pro 17 i5R on 3/12/25.
//
import SwiftUI

struct HomeView: View {
    @StateObject private var viewModel = HomeViewModel()
    @AppStorage("isLoggedIn") var isLoggedIn: Bool = false
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                // Header fijo
                if isLoggedIn {} else {
                    HomeHeaderView()
                }

                // Contenido desplazable
                ScrollView {
                    VStack(spacing: 16) {
                        // Noticia principal
                        MainNewsCardView()
                        
                        // Noticias secundarias
                        VStack(spacing: 12) {
                            ForEach(secondaryNewsData) { news in
                                SecondaryNewsCardView(news: news)
                            }
                        }
                        .padding(.horizontal)
                    }
                    .padding(.top)
                }
            }
            .onAppear {
                viewModel.fetchItems()
            }
            .navigationBarHidden(true)
        }
    }
}
