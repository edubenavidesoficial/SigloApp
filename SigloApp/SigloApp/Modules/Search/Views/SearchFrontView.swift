import SwiftUI

// Extensión para inicializar colores desde código hexadecimal
extension Color {
    init(hex: String) {
        let scanner = Scanner(string: hex)
        _ = scanner.scanString("#")

        var rgb: UInt64 = 0
        scanner.scanHexInt64(&rgb)

        let r = Double((rgb >> 16) & 0xFF) / 255
        let g = Double((rgb >> 8) & 0xFF) / 255
        let b = Double(rgb & 0xFF) / 255

        self.init(red: r, green: g, blue: b)
    }
}

struct SearchFrontView: View {
    @StateObject private var viewModel = SearchFrontViewModel()
    @StateObject private var searchViewModel = SearchViewModel()
    @State private var searchText: String = ""
    @State private var selectedTema: String = ""

    let temaColors = ["#FFEB99", "#CFB495", "#9AB5C1", "#CCC3D1", "#D2BAB7", "#6C567B", "#5D5B6A", "#6B7B8E", "#189DB9", "#696969"]
    let tendenciaColors = ["#ACDEAA", "#EEF3AD", "#F5C8BD", "#C5CABE", "#CADAB4", "#516091", "#F67280", "#758184", "#41A8CE", "#E33E85"]

    var body: some View {
        NavigationView {
            VStack(spacing: 16) {
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
                                Text("Buscar por temas")
                                    .font(.title2)
                                    .bold()
                                    .padding(.horizontal)

                                VStack(spacing: 8) {
                                    ForEach(0..<2) { fila in
                                        ScrollView(.horizontal, showsIndicators: false) {
                                            HStack(spacing: 12) {
                                                ForEach(Array(temas.contenido.enumerated()).filter { index, _ in
                                                    fila == 0 ? index < 5 : index >= 5
                                                }, id: \.1.id) { index, contenido in
                                                    Button(action: {
                                                        searchText = contenido.titulo
                                                        searchViewModel.buscarArticulos(query: contenido.titulo)
                                                    }) {
                                                        Text(contenido.titulo.uppercased())
                                                            .padding(.horizontal, 16)
                                                            .padding(.vertical, 8)
                                                            .background(Color(hex: temaColors[index]))
                                                            .foregroundColor(index < 5 ? .black : .white)
                                                            .cornerRadius(10)
                                                    }
                                                }
                                            }
                                            .padding(.horizontal)
                                        }
                                    }
                                }
                            }

                            if let tendencias = viewModel.articulos.first(where: { $0.titulo == "Tendencias" }) {
                                Text("Tendencias")
                                    .font(.title2)
                                    .bold()
                                    .padding(.horizontal)

                                VStack(spacing: 8) {
                                    ForEach(0..<2) { fila in
                                        ScrollView(.horizontal, showsIndicators: false) {
                                            HStack(spacing: 12) {
                                                ForEach(Array(tendencias.contenido.enumerated()).filter { index, _ in
                                                    fila == 0 ? index < 5 : index >= 5
                                                }, id: \.1.id) { index, contenido in
                                                    Button(action: {
                                                        searchText = contenido.titulo
                                                        searchViewModel.buscarArticulos(query: contenido.titulo)
                                                    }) {
                                                        Text(contenido.titulo.uppercased())
                                                            .padding(.horizontal, 16)
                                                            .padding(.vertical, 8)
                                                            .background(Color(hex: tendenciaColors[index]))
                                                            .foregroundColor(index < 5 ? .black : .white)
                                                            .cornerRadius(10)
                                                    }
                                                }
                                            }
                                            .padding(.horizontal)
                                        }
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
                                            Text(articulo.titulo)
                                                .font(.headline)
                                                .padding(.horizontal)

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

                                                                Text("12:00")
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
                                            Text("")
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
