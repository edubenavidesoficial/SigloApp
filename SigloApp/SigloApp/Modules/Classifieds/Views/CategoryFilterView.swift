import SwiftUI

struct CategoryFilterView: View {
    @ObservedObject var viewModel: ClassifiedsViewModel
    @State private var showCategories = false

    var body: some View {
        VStack(spacing: 0) {
            Button(action: {
                withAnimation {
                    showCategories.toggle()
                }
            }) {
                HStack {
                    Text("Categorías")
                        .font(.headline)
                    Spacer()
                    Image(systemName: showCategories ? "chevron.up" : "chevron.down")
                        .foregroundColor(.gray)
                }
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(8)
            }

            if showCategories {
                VStack(alignment: .leading, spacing: 12) {
                    ForEach(viewModel.categories, id: \.self) { category in
                        HStack {
                            Image(systemName: viewModel.selectedCategory == category ? "largecircle.fill.circle" : "circle")
                                .foregroundColor(.red)
                            Text(category)
                                .onTapGesture {
                                    withAnimation {
                                        viewModel.selectedCategory = category
                                        showCategories = false
                                    }
                                }
                        }
                    }

                    // Opción para limpiar selección
                    if viewModel.selectedCategory != nil {
                        Button("Limpiar filtro") {
                            withAnimation {
                                viewModel.selectedCategory = nil
                                showCategories = false
                            }
                        }
                        .foregroundColor(.blue)
                        .padding(.top)
                    }
                }
                .padding()
                .background(Color(.systemBackground))
                .cornerRadius(8)
                .transition(.move(edge: .top))
            }
        }
        .padding()
    }
}
