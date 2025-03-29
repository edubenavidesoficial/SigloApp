//
//  ArticleRow.swift
//  SigloApp
//
//  Created by Macbook Pro 17 i5R on 3/14/25.
//

import SwiftUI

struct SavedView: View {
    @StateObject var viewModel = ArticleViewModel()
    @AppStorage("isLoggedIn") var isLoggedIn: Bool = false
    
    var body: some View {
        VStack(spacing: 0) {
            // Header fijo
            if isLoggedIn {
                // Puedes mostrar info de usuario aquí si está logueado
            } else {
                HomeHeaderView()
            }
            HStack {
                ForEach(TabType.allCases, id: \.self) { tab in
                    Text(tab.rawValue)
                        .fontWeight(viewModel.selectedTab == tab ? .bold : .regular)
                        .foregroundColor(viewModel.selectedTab == tab ? .red : .black)
                        .onTapGesture {
                            viewModel.selectedTab = tab
                        }
                    if tab != TabType.allCases.last {
                        Spacer()
                    }
                }
            }
            .padding()
            .background(Color.white)
            
            Divider()

            ScrollView {
                VStack(spacing: 24) {
                    ForEach(viewModel.articlesForCurrentTab()) { article in
                        ArticleRow(article: article)
                    }
                }
                .padding(.horizontal)
                .padding(.top, 10)
            }
            .background(Color.white)
        }
        .navigationTitle("El Siglo de Torreón")
        .navigationBarTitleDisplayMode(.inline)
    }
}
