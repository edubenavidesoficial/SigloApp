//
//  PrintCa.swift
//  SigloApp
//
//  Created by Macbook Pro 17 i5R on 3/21/25.
//

import SwiftUI

struct PrintCarouselView: View {
    @ObservedObject var viewModel: PrintViewModel

    var body: some View {
        TabView {
            ForEach(viewModel.articlesForCurrentTab()) { article in
                VStack {
                    Image(article.imageName)
                        .resizable()
                        .scaledToFit()
                        .cornerRadius(12)
                        

                    HStack() {
                        Text(article.date)
                            .font(.caption)
                            .foregroundColor(.gray)

                        Image(systemName: "arrow.down.circle.fill") // Ícono de descarga
                            .foregroundColor(.black)
                            .font(.caption)
                    }
                    .padding(.top, 4)
                }

            }
        }
        .tabViewStyle(PageTabViewStyle(indexDisplayMode: .automatic))
        .frame(height: 470)
    }
}
