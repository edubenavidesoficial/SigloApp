import SwiftUI

struct CustomTopBar: View {
    let onBack: () -> Void
    var nota: Nota
    @ObservedObject var articleActionHelper: ArticleActionHelper
    
    @State private var showSavedBadge = false

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
                ZStack(alignment: .bottom) {
                    Button(action: {
                        articleActionHelper.guardarNota(nota)
                        
                        // Mostrar badge temporal
                        withAnimation {
                            showSavedBadge = true
                        }
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                            withAnimation {
                                showSavedBadge = false
                            }
                        }
                    }) {
                        Image(systemName: "bookmark")
                            .foregroundColor(.white)
                    }

                    if showSavedBadge {
                        Text("¡Guardado!")
                            .font(.caption2)
                            .foregroundColor(.white)
                            .padding(6)
                            .background(Color.green)
                            .cornerRadius(8)
                            .transition(.scale.combined(with: .opacity))
                            .offset(y: 30) // <-- positivo para bajar
                    }
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
