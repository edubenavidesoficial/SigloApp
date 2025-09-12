import SwiftUI

struct SavedView: View {
    @EnvironmentObject var articleViewModel: ArticleViewModel
    @AppStorage("isLoggedIn") var isLoggedIn: Bool = false
    @State private var isMenuOpen: Bool = false
    @State private var selectedOption: MenuOption? = nil

    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                // Header
                HeaderView(
                    selectedOption: $selectedOption,
                    isMenuOpen: $isMenuOpen,
                    isLoggedIn: isLoggedIn
                )
                
                // Menú de opciones
                if let selected = selectedOption {
                    NotesView(title: selected.title, selectedOption: $selectedOption)
                        .transition(.move(edge: .trailing))
                } else {
                    // Pestañas horizontales
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 20) {
                            ForEach(TabType.allCases, id: \.self) { tab in
                                VStack(spacing: 4) {
                                    Text(tab.rawValue)
                                        .font(.system(size: 14))
                                        .lineLimit(1)
                                        .minimumScaleFactor(0.5)
                                        .fontWeight(articleViewModel.selectedTab == tab ? .bold : .regular)
                                        .foregroundColor(articleViewModel.selectedTab == tab ? .red : .primary)
                                        .onTapGesture {
                                            withAnimation {
                                                articleViewModel.selectedTab = tab
                                            }
                                        }
                                    
                                    Rectangle()
                                        .fill(articleViewModel.selectedTab == tab ? Color.red : Color.clear)
                                        .frame(height: 2)
                                }
                                .padding(.horizontal, 8)
                            }
                        }
                        .padding()
                        .background(Color(.systemBackground))
                    }
                    
                    Divider()
                    
                    // Artículos según la pestaña seleccionada
                    ScrollView {
                        VStack(spacing: 12) {
                            let articles = articleViewModel.articlesForCurrentTab()
                            
                            if articles.isEmpty {
                                Text("No hay artículos en esta categoría")
                                    .foregroundColor(.gray)
                                    .padding(.top, 40)
                            } else {
                                ForEach(articles) { article in
                                    NewsRow(article: article)
                                        .padding(.vertical, 4)
                                        .background(Color(.systemBackground))
                                        .cornerRadius(8)
                                        .shadow(color: Color.black.opacity(0.05), radius: 2, x: 0, y: 1)
                                }
                            }
                        }
                        .padding(.horizontal)
                        .padding(.top, 8)
                    }
                    .animation(.default, value: articleViewModel.selectedTab)
                    .onAppear {
                        print("🟢 Noticias en SavedView: \(articleViewModel.noticias.map { $0.title })")
                        print("🟢 Siglo TV: \(articleViewModel.sigloTV.map { $0.title })")
                        print("🟢 Clasificados: \(articleViewModel.clasificados.map { $0.title })")
                    }
                }
            }
            .navigationBarHidden(true)
        }
    }
}
