import SwiftUI

struct SigloTvView: View {
    let nota: Nota

    var body: some View {
        VStack(spacing: 0) {
            if let foto = nota.fotos.first {
                GeometryReader { geometry in
                    SigloTvVideoView(foto: foto)
                        .scaledToFill()
                        .clipped()
                }
                .frame(height: 255)
            }

            // Contenido textual debajo
            VStack(alignment: .leading, spacing: 8) {
                VStack(alignment: .leading, spacing: 4) {
                 
                    Text(nota.titulo)
                        .font(.headline)
                        .foregroundColor(.primary)
                        .shadow(radius: 1)

                }

                HStack {
                    Text("EL SIGLO DE TORREÓN")
                        .font(.caption)
                        .bold()
                        .foregroundColor(.gray)

                    Spacer()

                    HStack {
                        Image(systemName: "clock")
                            .foregroundColor(.gray)
                        Text("00:00")
                            .font(.caption)
                            .foregroundColor(.gray)
                    }
                }
                .padding(.top, 8)
                Spacer()
            }
            .padding()
        }
        .frame(width: 250)
        .background(Color.white)
        .cornerRadius(10)
        .shadow(radius: 3)
    }
}
