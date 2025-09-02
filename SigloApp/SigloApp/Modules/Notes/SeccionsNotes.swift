import SwiftUI

struct SeccionsNotesView: View {
    @ObservedObject var viewModel: HomeViewModel
    @ObservedObject var articleViewModel: ArticleViewModel
    @ObservedObject var articleActionHelper: ArticleActionHelper
    var title: String

    var body: some View {
        VStack {
            ForEach(viewModel.secciones.filter { $0.seccion == title }, id: \.seccion) { seccion in
                let notas = seccion.notas ?? []

                TabView {
                    ForEach(notas, id: \.id) { nota in
                        HStack(alignment: .top, spacing: 12) {
                            VStack(alignment: .leading, spacing: 6) {
                                HStack {
                                    Rectangle()
                                        .fill(Color.red)
                                        .frame(width: 4, height: 14)

                                    Text(nota.localizador)
                                        .font(.caption)
                                        .foregroundColor(.red)

                                    Spacer()

                                    Menu {
                                        Button(action: {
                                            compartirNota(nota)
                                        }) {
                                            Label("Compartir", systemImage: "square.and.arrow.up")
                                        }

                                    } label: {
                                        Image(systemName: "ellipsis")
                                            .foregroundColor(.gray)
                                            .padding(.trailing, 8)
                                    }
                                }

                                Text(nota.titulo)
                                    .font(.headline)
                                    .foregroundColor(.primary)
                                    .lineLimit(2)

                                Text(nota.autor)
                                    .font(.caption)
                                    .foregroundColor(.gray)

                                HStack(spacing: 8) {
                                    Text(seccion.seccion ?? "Siglo")
                                        .foregroundColor(.red)
                                        .font(.caption)
                                }
                            }

                            Spacer()

                            ZStack(alignment: .bottomTrailing) {
                                if let foto = nota.fotos.first {
                                    FotoView(foto: foto)
                                        .scaledToFill()
                                        .frame(width: 100, height: 100)
                                        .clipped()
                                        .cornerRadius(8)
                                }
                            }
                        }
                        .padding()
                    }
                }
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .always))
                .frame(height: 180)
            }
        }
        // 👇 Este .sheet está directamente sobre el body (fuera del VStack)
        .background(
            EmptyView()
                .sheet(isPresented: $articleActionHelper.showShareSheet) {
                    ActivityView(activityItems: articleActionHelper.shareContent)
                }
                .onChange(of: articleActionHelper.showShareSheet) { newValue in
                    print("showShareSheet cambió a: \(newValue)")
                }

        )
    }

    func compartirNota(_ nota: Nota) {
        articleActionHelper.compartirNota(nota)
    }
}
