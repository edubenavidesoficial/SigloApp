import SwiftUI

struct NoticiaView: View {
    let nota: Nota

    var body: some View {
        ZStack(alignment: .bottomLeading) {
            if let foto = nota.fotos.first {
                GeometryReader { geometry in
                    FotoView(foto: foto)
                        .scaledToFill() // Hace que la imagen llene el contenedor
                        .frame(width: geometry.size.width, height: geometry.size.height) // Rellena todo el espacio
                        .clipped()
                        .overlay(
                            LinearGradient(
                                gradient: Gradient(colors: [Color.black.opacity(0.9), Color.clear]),
                                startPoint: .bottom,
                                endPoint: .center
                            )
                        )
                }
                .edgesIgnoringSafeArea(.all)
            }

            VStack {
                Spacer()

                VStack(alignment: .leading, spacing: 4) {
                    Text(nota.titulo)
                        .font(.headline)
                        .foregroundColor(.white)
                        .shadow(radius: 2)

                    Text(nota.titulo)
                        .font(.subheadline)
                        .foregroundColor(.white.opacity(0.8))
                        .shadow(radius: 1)
                }
                .padding()

                HStack {
                    Text("EL SIGLO DE TORREÓN")
                        .font(.caption)
                        .bold()
                        .foregroundColor(.white)
                        .shadow(radius: 2)
                        .padding(.leading)

                    Spacer()

                    HStack {
                        Image(systemName: "clock") // Icono de reloj
                            .foregroundColor(.white.opacity(0.8))
                        Text("00:00")
                            .font(.caption)
                            .foregroundColor(.white.opacity(0.8))
                    }
                    .padding(.trailing)
                }
                .padding(.bottom, 15)
            }
        }
    }
}
