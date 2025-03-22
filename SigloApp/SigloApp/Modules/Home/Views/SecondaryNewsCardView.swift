//
//  SecondaryNewsCardView.swift
//  SigloApp
//
//  Created by Macbook Pro 17 i5R on 3/13/25.
//
import SwiftUI

struct SecondaryNewsCardView: View {
    var news: Nota

    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            VStack(alignment: .leading, spacing: 6) {
                Text(news.seccion)
                    .font(.caption)
                    .foregroundColor(.red)

                Text(news.titulo)
                    .font(.headline)
                    .foregroundColor(.primary)
                    .lineLimit(2)

                if let autor = news.autor {
                    Text(autor)
                        .font(.caption)
                        .foregroundColor(.gray)
                }

                if let ciudad = news.ciudad {
                    Label(ciudad, systemImage: "clock")
                        .font(.caption2)
                        .foregroundColor(.gray)
                }
            }

            Spacer()

            if let imageName = news.fotos?.first {
                AsyncImage(url: URL(string: imageName)) { image in
                    image
                        .resizable()
                        .scaledToFill()
                } placeholder: {
                    Color.gray.opacity(0.2)
                }
                .frame(width: 80, height: 60)
                .cornerRadius(6)
                .clipped()
            }
        }
    }
}
