import SwiftUI

struct SavedView: View {
    @EnvironmentObject var articleViewModel: ArticleViewModel
    @AppStorage("isLoggedIn") var isLoggedIn: Bool = false
    @State private var isMenuOpen: Bool = false
    @State private var selectedOption: MenuOption? = nil

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 0) {
                    // Header
                    HeaderView(
                        selectedOption: $selectedOption,
                        isMenuOpen: $isMenuOpen,
                        isLoggedIn: isLoggedIn
                    )
                    
                    // Si hay una opción de menú seleccionada
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
                                            .foregroundColor(.primary)
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
                        VStack(spacing: 8) {
                            ForEach(articleViewModel.articlesForCurrentTab()) { article in
                                NewsRow(article: article)
                            }
                        }
                        .padding(.horizontal)
                        .onAppear {
                            print("🟢 Noticias en SavedView: \(articleViewModel.noticias.map { $0.title })")
                            print("🟢 Siglo TV: \(articleViewModel.sigloTV.map { $0.title })")
                            print("🟢 Clasificados: \(articleViewModel.clasificados.map { $0.title })")
                        }
                    }
                }
            }
            .navigationBarHidden(true)
        }
    }
}
