import SwiftUI

struct SuplementsView: View {
    @StateObject var viewModel = SuplementsViewModel()
    
    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                Divider()
                
                ForEach(uniqueTitles(), id: \.self) { ruta in
                    let hasValidItems = viewModel.suplementsFiltered(by: ruta)
                        .contains { !$0.imageName.trimmingCharacters(in: .whitespaces).isEmpty }

                    if hasValidItems {
                        VStack(alignment: .leading, spacing: 8) {
                            Text(ruta.uppercased()) // En mayúsculas
                                .font(.headline)
                                .padding(.horizontal)

                            SuplementsCarouselView(viewModel: viewModel, filterTitle: ruta)
                        }
                    }
                }

                
                if let errorMessage = viewModel.errorMessage {
                    Text(errorMessage)
                        .foregroundColor(.red)
                        .padding()
                }
            }
        }
        .onAppear {
            viewModel.fetchSuplementos()
        }
    }
    
    private func uniqueTitles() -> [String] {
        let allTitles = viewModel.suplementos.map { $0.ruta }
        let unique = Array(Set(allTitles)).sorted()
        return unique
    }
}
