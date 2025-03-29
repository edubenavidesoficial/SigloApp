import SwiftUI

struct SavedView: View {
    @ObservedObject var articleViewModel: ArticleViewModel
    @AppStorage("isLoggedIn") var isLoggedIn: Bool = false
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                // Header fijo
                if isLoggedIn {
                    // Puedes mostrar info de usuario aquí si está logueado
                } else {
                    HomeHeaderView()
                }

                // Barra de pestañas
                HStack {
                    ForEach(TabType.allCases, id: \.self) { tab in
                        Text(tab.rawValue)
                            .fontWeight(articleViewModel.selectedTab == tab ? .bold : .regular)
                            .foregroundColor(articleViewModel.selectedTab == tab ? .red : .black)
                            .onTapGesture {
                                articleViewModel.selectedTab = tab
                            }
                        if tab != TabType.allCases.last {
                            Spacer()
                        }
                    }
                }
                .padding()
                .background(Color.white)
                
                Divider()
                // Mostrar los artículos según la pestaña seleccionada
                List(articleViewModel.articlesForCurrentTab(), id: \.title) { article in
                    NewsRow(article: article)
                }
                .listStyle(PlainListStyle()) // Estilo limpio para la lista
            }
            .background(Color.white)
        }
    }
}
