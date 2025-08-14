import SwiftUI
let label = UILabel()

struct SeccionesHomeView: View {
    @ObservedObject var viewModel: HomeViewModel
    @ObservedObject var articleViewModel: ArticleViewModel
    @StateObject var articleActionHelper: ArticleActionHelper
    
    init(viewModel: HomeViewModel, articleViewModel: ArticleViewModel) {
        self.viewModel = viewModel
        self.articleViewModel = articleViewModel
        _articleActionHelper = StateObject(wrappedValue: ArticleActionHelper(articleViewModel: articleViewModel))
    }
    
    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                if let portada = viewModel.secciones.first(where: { $0.seccion == "Portada" }) {
                    let notas = Array((portada.notas ?? []).dropFirst().prefix(4))
                    
                    ForEach(notas, id: \.id) { nota in
                        NotaRow(nota: nota, seccion: "Portada", articleActionHelper: articleActionHelper)
                    }
                } else {
                    Text("No hay notas disponibles en la Portada.")
                        .foregroundColor(.gray)
                        .padding()
                }
            }
            
            VStack(spacing: 16) {
                if let sinSeccion = viewModel.secciones.first(where: { $0.seccion == nil }),
                   let notaRandom = sinSeccion.notas?.shuffled().first {
                    NotaDestacadaView(nota: notaRandom)
                }
                
                if let foquitos = viewModel.secciones.first(where: { $0.seccion == "Foquitos" }) {
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 16) {
                            ForEach(foquitos.notas ?? [], id: \.id) { nota in
                                NotaCarruselCard(nota: nota)
                            }
                        }
                        .padding(.horizontal)
                    }
                    .padding(.bottom)
                }
                
                if let soft = viewModel.secciones.first(where: { $0.seccion == "Portada Soft" }) {
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 16) {
                            ForEach(soft.notas ?? [], id: \.id) { nota in
                                SoftCarruselCard(nota: nota, articleActionHelper: articleActionHelper)
                            }
                        }
                        .padding(.horizontal)
                    }
                    .padding(.bottom)
                }
                
                if let tv = viewModel.secciones.first(where: { $0.seccion == "Siglo TV" }) {
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 16) {
                            ForEach(tv.notas ?? [], id: \.id) { nota in
                                TVCarruselCard(nota: nota, articleActionHelper: articleActionHelper)
                            }
                        }
                        .padding(.horizontal)
                    }
                    .padding(.bottom)
                }else {
                    Text("No hay notas disponibles en la Siglo TV.")
                        .foregroundColor(.gray)
                        .padding()
                }
                
                if let data = viewModel.secciones.first(where: { $0.seccion == "Siglo Data" }) {
                    if let nota = data.notas?.randomElement() {
                        NewsBigImageRow(nota: nota, articleActionHelper: articleActionHelper)
                            .shadow(color: Color.black.opacity(0.05), radius: 4, x: 0, y: 2)
                    }
                    
                    // Mostrar las 4 siguientes notas pequeñas
                    ForEach(data.notas?.prefix(4) ?? [], id: \.id) { nota in
                        NewsRelaRow(nota: nota, articleActionHelper: articleActionHelper)
                    }
                }

                 else {
                    Text("No hay notas disponibles en la Siglo Data.")
                        .foregroundColor(.gray)
                        .padding()
                }

                    
                }
            }
             .sheet(isPresented: $articleActionHelper.showShareSheet) {
                ActivityView(activityItems: articleActionHelper.shareContent)
            }
        }
    }
