import SwiftUI

struct SectionDetailView: View {
    let payload: SectionPayload

    var body: some View {
        List {
            if let notas = payload.notas {
                Section("Noticias") {
                    ForEach(notas, id: \.id) { nota in
                        Text(nota.titulo)
                    }
                }
            }

            if let videos = payload.videos {
                Section("Videos") {
                    ForEach(videos, id: \.id) { video in
                        Text(video.titulo)
                    }
                }
            }
        }
    }
}
