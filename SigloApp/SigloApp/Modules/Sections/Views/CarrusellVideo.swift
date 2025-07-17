import SwiftUI

struct CarrusellVideo: View {
    let videos: [SectionVideo]

    // Filtrar videos con imagen (cover) y tomar del 2° al 6°
    private var filteredVideos: [SectionVideo] {
        videos.filter { $0.cover != nil }
              .dropFirst() // desde el segundo
              .prefix(5)    // hasta el sexto
              .map { $0 }
    }

    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 16) {
                ForEach(filteredVideos, id: \.id) { video in
                    VideoCard(video: video)
                }
            }
            .padding(.horizontal)
        }
    }
}
