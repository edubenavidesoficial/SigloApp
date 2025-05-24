
import SwiftUI

// MARK: - SearchView
struct SearchView: View {
    @State private var searchText: String = ""
    @State private var selectedTema: String = ""
    @StateObject private var viewModel = SearchViewModel()

    let temas = ["SEGURIDAD", "ACCIDENTES VIALES", "SELECCIÓN MEXICANA", "OBRAS PÚBLICAS"]
    let tendencias = ["ACCIDENTES VIALES", "FAMOSOS", "EVENTOS", "SOCIALES"]

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

            // Chips de temas
            VStack(alignment: .leading, spacing: 8) {
                Text("Buscar por tema")
                    .font(.headline)
                    .foregroundColor(.black)
                    .padding(.leading)

                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 12) {
                        ForEach(temas, id: \.self) { tema in
                            ChipView(
                                text: tema,
                                color: colorParaTema(tema),
                                isSelected: selectedTema == tema
                            )
                            .onTapGesture {
                                selectedTema = tema
                                searchText = tema
                                viewModel.buscarArticulos(query: tema)
                            }
                        }
                    }
                    .padding(.horizontal)
                }
            }

            // Chips de tendencia
            VStack(alignment: .leading, spacing: 8) {
                Text("Tendencia")
                    .font(.headline)
                    .foregroundColor(.black)
                    .padding(.leading)

                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 12) {
                        ForEach(tendencias, id: \.self) { tendencia in
                            ChipView(
                                text: tendencia,
                                color: colorParaTendencia(tendencia),
                                isSelected: selectedTema == tendencia
                            )
                            .onTapGesture {
                                selectedTema = tendencia
                                searchText = tendencia
                                viewModel.buscarArticulos(query: tendencia)
                            }
                        }
                    }
                    .padding(.horizontal)
                }
            }

            // Resultados de búsqueda
            if viewModel.isLoading {
                ProgressView("Buscando...")
                    .padding()
            } else if let error = viewModel.errorMessage {
                Text("❌ Error: \(error)")
                    .foregroundColor(.red)
                    .padding()
            } else if !viewModel.searchResults.isEmpty {
                List(viewModel.searchResults, id: \.id) { articulo in
                        HStack(alignment: .top) { // Use HStack for the article content and image
                            VStack(alignment: .leading) {
                                Text("Siglo")
                                    .font(.caption)
                                    .foregroundColor(.red) // Mimicking the red category text

                                Text(articulo.titulo)
                                    .font(.headline)
                                    .lineLimit(3) // Limit lines for title
                                    .padding(.bottom, 1)

                                HStack {
                                    Text("Autor")
                                        .font(.caption)
                                        .foregroundColor(.gray)
                                    Text("")
                                        .font(.caption)
                                        .foregroundColor(.gray)
                                }
                                .padding(.bottom, 1)

                                Text(articulo.descripcion ?? "Sin descripción")
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                            }
                            
                            Spacer() // Pushes content to the left and image to the right

                            Image("logo") // Placeholder for the article image
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 90, height: 90) // Adjust size as needed
                                .clipped()
                                .cornerRadius(8) // Slightly rounded corners for the image
                        }
                        .padding(.vertical, 8)
                        .padding(.horizontal) // Add some horizontal padding to the whole article row
                    }

                }
            }

            Spacer()
        }
    }

    // MARK: - Colores para temas
    func colorParaTema(_ tema: String) -> Color {
        switch tema {
        case "SEGURIDAD":
            return Color.yellow.opacity(0.6)
        case "ACCIDENTES VIALES":
            return Color.brown.opacity(0.6)
        case "SELECCIÓN MEXICANA":
            return Color.purple.opacity(0.6)
        case "OBRAS PÚBLICAS":
            return Color.gray.opacity(0.6)
        default:
            return Color.secondary.opacity(0.3)
        }
    }

    // MARK: - Colores para tendencias
    func colorParaTendencia(_ tema: String) -> Color {
        switch tema {
        case "ACCIDENTES VIALES":
            return Color.green.opacity(0.5)
        case "FAMOSOS":
            return Color.yellow.opacity(0.4)
        case "EVENTOS":
            return Color.blue.opacity(0.7)
        case "SOCIALES":
            return Color.red.opacity(0.6)
        default:
            return Color.gray
        }
    }

// MARK: - ChipView personalizado
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

