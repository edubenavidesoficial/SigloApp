import SwiftUI

struct SuplementsView: View {
    @StateObject var viewModel = SuplementsViewModel()
    
    var body: some View {
        ScrollView {
            VStack(spacing: 0) {
                Divider()
                
                SuplementsCarouselView(viewModel: viewModel)
                
                if let errorMessage = viewModel.errorMessage {
                    Text(errorMessage)
                        .foregroundColor(.red)
                        .padding()
                }

                Divider()
            }
        }
        .onAppear {
            viewModel.fetchSuplementos()
        }
    }
}
