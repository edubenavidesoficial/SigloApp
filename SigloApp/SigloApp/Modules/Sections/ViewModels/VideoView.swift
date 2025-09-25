//
//  VideoView.swift
//  SigloApp
//
//  Created by Macbook Pro 17 i5R on 25/9/25.
//


import SwiftUI

struct VideoView: View {
    let video: SectionVideo
    let allVideos: [SectionVideo]  // Lista completa para pasar a VideoListPlayerView
    @State private var showPlayer = false

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            if let cover = video.cover,
               let url = URL(string: cover) {

                ZStack {
                    AsyncImage(url: url) { image in
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                    } placeholder: {
                        Color.gray.opacity(0.3)
                    }
                    .frame(height: 200)
                    .clipped()
                    .cornerRadius(12)

                    Button(action: {
                        showPlayer = true
                    }) {
                        Circle()
                            .fill(Color.black.opacity(0.4))
                            .frame(width: 60, height: 60)
                            .overlay(
                                Image(systemName: "play.fill")
                                    .foregroundColor(.white)
                                    .font(.system(size: 28, weight: .bold))
                            )
                            .shadow(radius: 5)
                    }
                }
                .background(
                    NavigationLink(
                        destination: VideoListPlayerView(videos: allVideos, currentVideo: video),
                        isActive: $showPlayer
                    ) {
                        EmptyView()
                    }
                    .hidden()
                )
            }

            Text(video.titulo ?? "Sin título")
                .font(.headline)

            if let contenido = video.contenido {
                Text(contenido)
                    .font(.subheadline)
                    .lineLimit(3)
            }

            Divider()
        }
        .padding()
    }
}
