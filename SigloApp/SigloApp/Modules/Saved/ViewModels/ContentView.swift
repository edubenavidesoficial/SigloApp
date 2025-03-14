//
//  CONTE.swift
//  SigloApp
//
//  Created by Macbook Pro 17 i5R on 3/14/25.
//

import SwiftUI

struct ContentView: View {
    @StateObject var viewModel = ArticleViewModel()

    var body: some View {
        VStack {
            // Tab selector
            Picker("Selecciona pestaña", selection: $viewModel.selectedTab) {
                ForEach(TabType.allCases, id: \.self) { tab in
                    Text(tab.rawValue).tag(tab)
                }
            }
            .pickerStyle(SegmentedPickerStyle())
            .padding()

            // Lista de artículos según el tab
            List(viewModel.articlesForCurrentTab()) { article in
                switch viewModel.selectedTab {
                case .noticias, .clasificados:
                    NewsRow(article: article)
                case .sigloTV:
                    SigloTVRow(video: article)
                }
            }
        }
    }
}
