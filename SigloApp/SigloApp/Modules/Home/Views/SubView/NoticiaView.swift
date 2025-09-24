import SwiftUI

struct NoticiaView: View {
    let nota: Nota
    let articleActionHelper: ArticleActionHelper
    
    @EnvironmentObject var articleViewModel: ArticleViewModel

    var body: some View {
        NavigationLink(destination: NewsDetailView(idNoticia: nota.id, articleViewModel: articleViewModel)) {
            ZStack(alignment: .bottomLeading) {
                
                // Imagen de fondo
                if let foto = nota.fotos.first {
                    GeometryReader { geometry in
                        FotoView(foto: foto)
                            .scaledToFill()
                            .frame(width: geometry.size.width, height: geometry.size.height)
                            .clipped()
                            .overlay(
                                LinearGradient(
                                    gradient: Gradient(colors: [Color.black.opacity(10), Color.clear]),
                                    startPoint: .bottom,
                                    endPoint: .center
                                )
                            )
                    }
                    .edgesIgnoringSafeArea(.all)
                }
                
                // Contenido principal
                VStack {
                    Spacer()
                    
                    VStack(alignment: .leading, spacing: 8) {
                        // Localizador + Menú
                        HStack {
                            Rectangle()
                                .fill(Color.white)
                                .frame(width: 4, height: 14)
                            
                            Text(nota.localizador)
                                .font(.system(size: 14))
                                .foregroundColor(.white)
                            
                            Spacer()
                            
                            // Menu de acciones
                            Menu {
                                Button {
                                    articleActionHelper.compartirNota(nota)
                                } label: {
                                    Label("Compartir", systemImage: "square.and.arrow.up")
                                }
                                
                                Button {
                                    articleActionHelper.guardarNota(nota)
                                } label: {
                                    Label("Guardar", systemImage: "bookmark")
                                }
                            } label: {
                                Image(systemName: "ellipsis")
                                    .foregroundColor(.white)
                                    .padding(10)
                                    .background(Color.black.opacity(0.3))
                                    .clipShape(Circle())
                                    .font(.system(size: 24))
                                    .contentShape(Rectangle()) // Garantiza clicabilidad completa
                            }
                        }
                        .padding(.bottom, 2)
                        
                        // Título
                        Text(nota.titulo)
                            .font(.custom("NotoSerif-Bold", size: 22))
                            .foregroundColor(.white)
                            .shadow(radius: 2)
                        
                        if !nota.contenido.isEmpty {
                            HStack(alignment: .top) {
                                Rectangle()
                                    .fill(Color.white)
                                    .frame(width: 4, height: 50)
                                
                                Text(nota.contenido[0]) // primer string del array
                                    .font(.custom("NotoSerif", size: 15))
                                    .foregroundColor(.white.opacity(0.8))
                                    .shadow(radius: 1)
                            }
                        }
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding()
                    
                    // Bloque inferior: fuente y hora
                    HStack {
                        Text("EL SIGLO DE TORREÓN")
                            .font(.caption)
                            .bold()
                            .foregroundColor(.white)
                            .shadow(radius: 2)
                            .padding(.leading)
                        
                        Spacer()
                        
                        HStack(spacing: 4) {
                            Image(systemName: "clock")
                                .font(.system(size: 12))
                                .foregroundColor(.white.opacity(0.8))
                            
                            Text("\(nota.fecha_formato ?? "") hrs")
                                .font(.caption)
                                .foregroundColor(.white.opacity(0.8))
                        }
                        .padding(.trailing)
                    }
                    .padding(.bottom, 15)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            }
            .frame(height: 520) // Ajusta altura fija para TabView o scroll
        }
        .buttonStyle(PlainButtonStyle()) // Evita interferencia con NavigationLink
    }
}
