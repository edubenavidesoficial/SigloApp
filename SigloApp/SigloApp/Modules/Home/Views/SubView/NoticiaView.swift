import SwiftUI

struct NoticiaView: View {
    let nota: Nota

    var body: some View {
        NavigationLink(destination: NewsDetailView(idNoticia: nota.id)) {
            ZStack(alignment: .bottomLeading) {
                if let foto = nota.fotos.first {
                    GeometryReader { geometry in
                        FotoView(foto: foto)
                            .scaledToFill()
                            .frame(width: geometry.size.width, height: geometry.size.height)
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
                        
                        HStack {
                            Rectangle()
                                .fill(Color.white)
                                .frame(width: 4, height: 14)
                            
                            Text(nota.localizador)
                                .font(.caption)
                                .foregroundColor(.white)
                        }
                        
                        Text(nota.titulo)
                            .font(.headline)
                            .foregroundColor(.white)
                            .shadow(radius: 2)
                        HStack {
                            Rectangle()
                                .fill(Color.white)
                                .frame(width: 4, height: 50)
                            Text(nota.titulo)
                                .font(.subheadline)
                                .foregroundColor(.white.opacity(0.8))
                                .shadow(radius: 1)
                        }
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
                            Image(systemName: "clock")
                                .foregroundColor(.white.opacity(0.8))
                            Text(nota.fecha_formato)
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
}
