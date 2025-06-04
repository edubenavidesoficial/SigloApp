import SwiftUI
struct SearchView: View {
    @State private var searchText: String = ""
    @State private var selectedTema: String = ""
    @StateObject private var viewModel = SearchViewModel()
    var body: some View {
        VStack(spacing: 12) {
            // Buscador principal
            HStack {
                Image(systemName: "magnifyingglass")
                    .foregroundColor(.gray)
                TextField("Buscar", text: $searchText, onCommit: {
                    viewModel.buscarArticulos(query: searchText)
                })
                .submitLabel(.search)
            }
            .padding(8)
            .background(Color(.systemGray6))
            .cornerRadius(8)
            .padding(.horizontal)
            
                    // Tabs
                    TabsHeaderView()
                        .padding(.top, 8)
                    
                    Spacer()
               
                // Resultados de búsqueda
            if viewModel.isLoading {
                ProgressView("Buscando...")
                    .padding()
            } else if viewModel.errorMessage != nil {
                Text("Sin coincidencia de búsqueda")
                    .foregroundColor(.black)
                    .padding()
            } else if !viewModel.searchResults.isEmpty {
                List(viewModel.searchResults, id: \.id) { articulo in
                    HStack(alignment: .top) {
                        VStack(alignment: .leading) {
                            Text("Siglo").font(.caption).foregroundColor(.red)
                            Text(articulo.titulo).font(.headline).lineLimit(3)
                            HStack {
                                Text("Autor").font(.caption).foregroundColor(.gray)
                                Text("").font(.caption).foregroundColor(.gray)
                            }
                            Text(articulo.descripcion ?? "Sin descripción").font(.subheadline).foregroundColor(.secondary)
                        }
                        Spacer()
                        Image("LS")
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 90, height: 90)
                            .clipped()
                            .cornerRadius(8)
                    }
                    .padding(.vertical, 8)
                    .padding(.horizontal)
                }
            }

            Spacer()
        }
    }
}

// MARK: - ChipView
struct ChipView: View {
    let text: String
    let color: Color
    var isSelected: Bool = false

    var body: some View {
        Text(text)
            .fontWeight(.medium)
            .foregroundColor(.black)
            .padding(.horizontal, 12)
            .padding(.vertical, 8)
            .background(color)
            .cornerRadius(8)
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(isSelected ? Color.blue : Color.clear, lineWidth: 2)
            )
    }
}

// MARK: - ChipSectionView
struct ChipSectionView: View {
    let titulo: String
    let chips: [String]
    @Binding var selectedTema: String
    @Binding var searchText: String
    var colorFunction: (String) -> Color

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(titulo)
                .font(.headline)
                .foregroundColor(.black)
                .padding(.leading)

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 12) {
                    ForEach(chips, id: \.self) { chip in
                        ChipView(
                            text: chip,
                            color: colorFunction(chip),
                            isSelected: selectedTema == chip
                        )
                        .onTapGesture {
                            selectedTema = chip
                            searchText = chip
                            // Puedes llamar aquí viewModel.buscarArticulos si pasas el viewModel también por parámetro
                        }
                    }
                }
                .padding(.horizontal)
            }
        }
    }
}
