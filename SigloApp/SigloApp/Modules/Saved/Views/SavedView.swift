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
                    HeaderView(
                        selectedOption: $selectedOption,
                        isMenuOpen: $isMenuOpen,
                        isLoggedIn: isLoggedIn
                    )
                    if let selected = selectedOption {
                        NotesView(title: selected.title, selectedOption: $selectedOption)
                            .transition(.move(edge: .trailing))
                    }
                    else {
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
                        
                        // Mostrar los artículos según la pestaña seleccionada
                        List(articleViewModel.articlesForCurrentTab(), id: \.title) { article in
                            NewsRow(article: article)
                        }
                        .onAppear {
                            print("🟢 Noticias en SavedView: \(articleViewModel.noticias.map { $0.title })")
                        }
                        .listStyle(PlainListStyle())
                    }
                }
            }
        }
    }
}
