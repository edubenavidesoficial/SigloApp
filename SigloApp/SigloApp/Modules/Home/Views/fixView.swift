import SwiftUI

struct ContentView: View {
    @State private var navigateToPromo = false
    @State private var navigateToHome = false
    @AppStorage("authToken") private var authToken: String = ""

    var body: some View {
        NavigationStack {
            ZStack {
                if navigateToHome {
                    HomeView()
                } else if navigateToPromo {
                    PromoView(navigateToHome: $navigateToHome)
                } else {
                    WelcomeView(navigateToPromo: $navigateToPromo, authToken: $authToken)
                }
            }
        }
    }
}
