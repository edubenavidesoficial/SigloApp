import SwiftUI

struct TabsHomeLayoutView: View {
    @ObservedObject var articleViewModel: ArticleViewModel

    var body: some View {
        TabView {
            HomeView(articleViewModel: articleViewModel)
                .tabItem {
                    Image("ico_siglo")
                    Text("PORTADA")
                }
            
            ImpresoView()
                .tabItem {
                    Image("ico_print")
                    Text("IMPRESO")
                }
            
            SavedView()
                .tabItem {
                    Image("ico_save")
                    Text("GUARDADO")
                }
                .environmentObject(articleViewModel)
            
            ProfileView()
                .tabItem {
                    Image("ico_user")
                    Text("PERFIL")
                }
        }
        .accentColor(.brown)
    }
}
