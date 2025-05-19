import SwiftUI

struct SearchView: View {
    @State private var searchText: String = ""

    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Image(systemName: "magnifyingglass")
                    .foregroundColor(.gray)
                TextField("Buscar", text: $searchText)
            }
            .padding(8)
            .background(Color(.systemGray6))
            .cornerRadius(8)
            .padding(.horizontal)

            ScrollView(.horizontal, showsIndicators: false) {
                HStack {
                    Text("Buscar por tema")
                        .font(.headline)
                        .foregroundColor(.secondary)
                        .padding(.leading)

                    ChipView(text: "SEGURIDAD", color: Color(red: 245/255, green: 222/255, blue: 179/255))
                    ChipView(text: "ACCIDENTES VIALES", color: Color(red: 205/255, green: 92/255, blue: 92/255))
                    ChipView(text: "SELECCIÓN MEXICANA", color: Color(red: 128/255, green: 0/255, blue: 128/255))
                    ChipView(text: "OBRAS PÚBLICAS", color: Color(red: 139/255, green: 69/255, blue: 19/255))
                    // Add more "Buscar por tema" chips as needed
                }
                .padding(.vertical)
            }

            VStack(alignment: .leading) {
                Text("Tendencia")
                    .font(.headline)
                    .foregroundColor(.secondary)
                    .padding(.horizontal)

                ScrollView(.horizontal, showsIndicators: false) {
                    HStack {
                        ChipView(text: "ACCIDENTES VIALES", color: Color(red: 144/255, green: 238/255, blue: 144/255))
                        ChipView(text: "FAMOSOS", color: Color(red: 255/255, green: 160/255, blue: 122/255))
                        ChipView(text: "EVENTOS", color: Color(red: 70/255, green: 130/255, blue: 180/255))
                        ChipView(text: "SOCIALES", color: Color(red: 255/255, green: 105/255, blue: 180/255))
                        // Add more "Tendencia" chips as needed
                    }
                    .padding(.horizontal)
                }
            }
            .padding(.vertical)

            Spacer() // Push content to the top
        }
    }
}

struct ChipView: View {
    let text: String
    let color: Color

    var body: some View {
        Text(text)
            .padding(.horizontal, 12)
            .padding(.vertical, 8)
            .background(color)
            .foregroundColor(.white)
            .cornerRadius(20)
    }
}
