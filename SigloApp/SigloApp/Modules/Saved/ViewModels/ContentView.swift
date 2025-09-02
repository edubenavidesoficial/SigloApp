import SwiftUI

struct ContentView: View {
    @AppStorage("isLoggedIn") var isLoggedIn: Bool = false
    @StateObject var viewModel = ArticleViewModel()

    var body: some View {
        if isLoggedIn {
            // Vista principal si está logueado
            VStack {
                Picker("Selecciona pestaña", selection: $viewModel.selectedTab) {
                    ForEach(TabType.allCases, id: \.self) { tab in
                        Text(tab.rawValue).tag(tab)
                    }
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding()

                List(viewModel.articlesForCurrentTab()) { article in
                    switch viewModel.selectedTab {
                    case .noticias, .clasificados:
                        NewsRow(article: article)
                    case .sigloTV:
                        SigloTVRow(video: article)
                    }
                }
            }
        } else {
            // Mostrar login si no está logueado
            LoginView()
        }
        NavigationView {
            PrintCarouselView(viewModel: PrintViewModel())
        }
    }
}
