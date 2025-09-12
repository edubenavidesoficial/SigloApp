import SwiftUI

struct CustomTopBar: View {
    let onBack: () -> Void
    var nota: Nota
    @ObservedObject var articleActionHelper: ArticleActionHelper

    var body: some View {
        HStack {
            // Botón de volver
            Button(action: {
                onBack()
            }) {
                Image(systemName: "chevron.left")
                    .foregroundColor(.white)
                    .font(.system(size: 18, weight: .medium))
            }

            Text("NACIONAL")
                .foregroundColor(.white)
                .font(.system(size: 16, weight: .semibold))
                .padding(.leading, 4)

            Spacer()

            // Botones de acción
            HStack(spacing: 24) {
                Button(action: {}) {
                    Image(systemName: "headphones")
                        .foregroundColor(.white)
                }
                // Compartir
                Button(action: {
                    articleActionHelper.compartirNota(nota)
                }) {
                    Image(systemName: "square.and.arrow.up")
                        .foregroundColor(.white)
                }

                // Guardar
                Button(action: {
                    articleActionHelper.guardarNota(nota)
                }) {
                    Image(systemName: "bookmark")
                        .foregroundColor(.white)
                }
            }
        }
        .padding(.horizontal)
        .padding(.vertical, 12)
        .background(Color.black)
        .safeAreaInset(edge: .top) {
            GeometryReader { geometry in
                Color.black
                    .frame(height: geometry.safeAreaInsets.top)
                    .edgesIgnoringSafeArea(.top)
            }
            .frame(height: 0)
        }
    }
}
