import SwiftUI

struct SearchFrontView: View {
    @StateObject private var viewModel = SearchFrontViewModel()
    @StateObject private var searchViewModel = SearchViewModel()
    @State private var searchText: String = ""
    @State private var selectedTema: String = ""

    var body: some View {
        NavigationView {
            VStack(spacing: 16) {
                // Buscador principal
                HStack {
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(.gray)
                    TextField("Buscar", text: $searchText, onCommit: {
                        searchViewModel.buscarArticulos(query: searchText)
                    })
                    .submitLabel(.search)
                }
                .padding(8)
                .background(Color(.systemGray6))
                .cornerRadius(8)
                .padding(.horizontal)

                ScrollView {
                    VStack(alignment: .leading, spacing: 16) {
                        
                        if searchViewModel.searchResults.isEmpty {
                            if let temas = viewModel.articulos.first(where: { $0.titulo == "Buscar por temas" }) {
                                // BUSCAR POR TEMAS
                                if let temas = viewModel.articulos.first(where: { $0.titulo == "Buscar por temas" }) {
                                    Text("Buscar por temas")
                                        .font(.title2)
                                        .bold()
                                        .padding(.horizontal)

                                    ScrollView(.horizontal, showsIndicators: false) {
                                        HStack(spacing: 12) {
                                            ForEach(temas.contenido) { contenido in
                                                Button(action: {
                                                    searchText = contenido.titulo
                                                    searchViewModel.buscarArticulos(query: contenido.titulo)
                                                }) {
                                                    Text(contenido.titulo.uppercased())
                                                        .padding(.horizontal, 16)
                                                        .padding(.vertical, 8)
                                                        .background(Color(hue: Double.random(in: 0...1), saturation: 0.4, brightness: 0.9))
                                                        .foregroundColor(.white)
                                                        .cornerRadius(10)
                                                }
                                            }
                                        }
                                        .padding(.horizontal)
                                    }
                                }
                            }

                            if let tendencias = viewModel.articulos.first(where: { $0.titulo == "Tendencias" }) {
                                // TENDENCIAS EN SLIDER HORIZONTAL
                                if let tendencias = viewModel.articulos.first(where: { $0.titulo == "Tendencias" }) {
                                    Text("Tendencias")
                                        .font(.title2)
                                        .bold()
                                        .padding(.horizontal)

                                    ScrollView(.horizontal, showsIndicators: false) {
                                        HStack(spacing: 12) {
                                            ForEach(tendencias.contenido) { contenido in
                                                Button(action: {
                                                    searchText = contenido.titulo
                                                    searchViewModel.buscarArticulos(query: contenido.titulo)
                                                }) {
                                                    Text(contenido.titulo.uppercased())
                                                        .padding(.horizontal, 16)
                                                        .padding(.vertical, 8)
                                                        .background(Color(hue: Double.random(in: 0...1), saturation: 0.4, brightness: 0.9))
                                                        .foregroundColor(.white)
                                                        .cornerRadius(10)
                                                }
                                            }
                                        }
                                        .padding(.horizontal)
                                    }
                                }
                            }
                        } else {
                            TabsHeaderView()
                                .padding(.top, 8)
                        }
                        
                        if !viewModel.articulos.isEmpty && searchViewModel.searchResults.isEmpty {
                            let articulosFiltrados = viewModel.articulos
                                .filter { $0.titulo != "Tendencias" && $0.titulo != "Buscar por temas" }

                            ScrollView(.vertical, showsIndicators: false) {
                                VStack(alignment: .leading, spacing: 24) {
                                    ForEach(articulosFiltrados, id: \.id) { articulo in
                                        VStack(alignment: .leading, spacing: 8) {
                                            // Título del artículo
                                            Text(articulo.titulo)
                                                .font(.headline)
                                                .padding(.horizontal)

                                            // Scroll horizontal para los contenidos
                                            ScrollView(.horizontal, showsIndicators: false) {
                                                HStack(spacing: 16) {
                                                    ForEach(articulo.contenido) { contenido in
                                                        VStack(alignment: .leading, spacing: 8) {
                                                            Text(contenido.titulo)
                                                                .font(.subheadline)
                                                                .foregroundColor(.black)
                                                                .lineLimit(2)

                                                            if let balazo = contenido.balazo {
                                                                Text(balazo)
                                                                    .font(.caption)
                                                                    .foregroundColor(.gray)
                                                            }

                                                            Spacer()

                                                            HStack {
                                                                Text("Siglo")
                                                                    .font(.caption)
                                                                    .foregroundColor(.red)

                                                                Spacer()

                                                                Text("12:00") // Reemplaza si tienes contenido.hora
                                                                    .font(.caption)
                                                                    .foregroundColor(.red)
                                                            }
                                                        }
                                                        .padding(8)
                                                        .frame(width: 220, height: 140)
                                                        .background(Color.white)
                                                        .cornerRadius(4)
                                                        .shadow(radius: 4)
                                                    }
                                                }
                                                .padding(.horizontal)
                                            }
                                        }
                                    }
                                }
                                .padding(.vertical)
                            }
                        }



                        // RESULTADOS DE BÚSQUEDA
                        if viewModel.isLoading {
                            ProgressView("Cargando...")
                        } else if !searchViewModel.searchResults.isEmpty {
                            ForEach(searchViewModel.searchResults, id: \.id) { articulo in
                                HStack(alignment: .top) {
                                    VStack(alignment: .leading) {
                                        Text("Siglo")
                                            .font(.caption)
                                            .foregroundColor(.red)

                                        Text(articulo.titulo)
                                            .font(.headline)
                                            .lineLimit(3)

                                        HStack {
                                            Text("Autor")
                                                .font(.caption)
                                                .foregroundColor(.gray)
                                            Text("") // Aquí podrías poner autor si existe
                                        }

                                        Text(articulo.descripcion ?? "Sin descripción")
                                            .font(.subheadline)
                                            .foregroundColor(.secondary)
                                    }

                                    Spacer()

                                    Image("LS")
                                        .resizable()
                                        .aspectRatio(contentMode: .fill)
                                        .frame(width: 90, height: 90)
                                        .clipped()
                                        .cornerRadius(8)
                                }
                                .padding(.horizontal)
                            }
                        } else if let error = viewModel.errorMessage {
                            Text("Error: \(error)")
                                .foregroundColor(.red)
                                .padding()
                        }
                    }
                }
                .onAppear {
                    viewModel.cargarMenuBusqueda(query: "")
                }
            }
        }
    }
}




