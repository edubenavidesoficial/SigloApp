//
//  SigloTVRow.swift
//  SigloApp
//
//  Created by Macbook Pro 17 i5R on 3/14/25.
//

import SwiftUI

struct SigloTVRow: View {
    let video: SavedArticle

    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            // Video thumbnail con ícono de reproducción y hora
            ZStack(alignment: .bottomLeading) {
                Image(video.imageName)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 140, height: 100)
                    .clipped()
                    .cornerRadius(8)

                // Ícono de play
                Image(systemName: "play.circle.fill")
                    .font(.system(size: 32))
                    .foregroundColor(.white)
                    .padding(8)

                // Hora
                Text(video.time)
                    .font(.caption2)
                    .foregroundColor(.white)
                    .padding(6)
                    .background(Color.black.opacity(0.7))
                    .cornerRadius(4)
                    .padding([.leading, .bottom], 6)
            }

            VStack(alignment: .leading, spacing: 6) {
                // Título
                Text(video.title)
                    .font(.headline)
                    .foregroundColor(.primary)
                    .lineLimit(2)

                // Descripción breve
                Text(video.description ?? "")
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .lineLimit(2)

                // Categoría roja al final
                Text(video.category.uppercased())
                    .font(.caption)
                    .foregroundColor(.red)
            }

            // Bookmark a la derecha
            Spacer()
            Image(systemName: "bookmark")
                .foregroundColor(.black)
                .padding(.top, 6)
        }
    }
}

