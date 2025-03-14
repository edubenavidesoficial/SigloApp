//
//  ArticleRow.swift
//  SigloApp
//
//  Created by Macbook Pro 17 i5R on 3/14/25.
//

import SwiftUI

struct ArticleRow: View {
    let article: SavedArticle

    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            Image(article.imageName)
                .resizable()
                .scaledToFill()
                .frame(width: 120, height: 80)
                .clipped()
                .cornerRadius(8)

            VStack(alignment: .leading, spacing: 6) {
                Text(article.category.uppercased())
                    .font(.caption)
                    .foregroundColor(.gray)

                Text(article.title)
                    .font(.headline)
                    .lineLimit(2)

                HStack {
                    Text(article.author)
                    Text("· \(article.location)")
                    Text("· \(article.time)")
                }
                .font(.caption)
                .foregroundColor(.secondary)
            }
        }
    }
}

