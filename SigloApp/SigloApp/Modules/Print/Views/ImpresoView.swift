import SwiftUI

struct ImpresoView: View {
    @StateObject var viewModel = PrintViewModel()
    @State private var pushNotificationsEnabled = true
    @AppStorage("isLoggedIn") var isLoggedIn: Bool = false

    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                HeaderView(isLoggedIn: isLoggedIn)

                Picker("Selecciona una pestaña", selection: $viewModel.selectedTab) {
                    ForEach(TabTypetwo.allCases, id: \.self) { tab in
                        Text(tab.rawValue).tag(tab)
                    }
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding()

                PrintCarouselView(viewModel: viewModel)
                
                if let errorMessage = viewModel.errorMessage {
                    Text(errorMessage).foregroundColor(.red)
                }

                ScrollView { }

                Divider()
            }
        }
    }
}
