//
//  SecondaryNewsCardView.swift
//  SigloApp
//
//  Created by Macbook Pro 17 i5R on 3/13/25.
//
import SwiftUI

struct SecondaryNewsCardView: View {
    var news: NewsModel

    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            VStack(alignment: .leading, spacing: 6) {
                Text(news.category)
                    .font(.caption)
                    .foregroundColor(.red)

                Text(news.title)
                    .font(.headline)
                    .foregroundColor(.primary)
                    .lineLimit(2)

                Text(news.author)
                    .font(.caption)
                    .foregroundColor(.gray)

                HStack {
                    Label(news.time, systemImage: "clock")
                        .font(.caption2)
                        .foregroundColor(.gray)
                }
            }

            Spacer()

            Image(news.imageName)
                .resizable()
                .frame(width: 80, height: 60)
                .cornerRadius(6)
        }
    }
}
