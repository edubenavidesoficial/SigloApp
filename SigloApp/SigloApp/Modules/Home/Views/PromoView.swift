import SwiftUI
import GoogleMobileAds

struct PromoView: View {
    @Binding var navigateToHome: Bool
    @StateObject private var adManager = InterstitialAdManager()

    var body: some View {
        // Vista vacía que ocupa toda la pantalla
        Color.clear
            .ignoresSafeArea()
            .onAppear {
                // Cargar y mostrar el interstitial ad
                adManager.loadAd(withAdUnitID: "ca-app-pub-3940256099942544/4411468910") // ID de prueba oficial

                // Opcional: navegar a Home después de 4 segundos
                Task {
                    try? await Task.sleep(nanoseconds: 4_000_000_000)
                    navigateToHome = true
                }
            }
    }
}

// MARK: - Interstitial Ad Manager
class InterstitialAdManager: NSObject, FullScreenContentDelegate, ObservableObject {
    var interstitial: InterstitialAd?

    func loadAd(withAdUnitID adUnitID: String) {
        let request = Request()
        InterstitialAd.load(with: adUnitID, request: request) { ad, error in
            if let error = error {
                print("Failed to load interstitial ad: \(error)")
                return
            }
            self.interstitial = ad
            self.interstitial?.fullScreenContentDelegate = self

            // Mostrar el ad inmediatamente si está listo
            DispatchQueue.main.async {
                if let root = UIApplication.shared.connectedScenes
                    .compactMap({ ($0 as? UIWindowScene)?.keyWindow })
                    .first?.rootViewController {
                    self.showAd(from: root)
                }
            }
        }
    }

    func showAd(from root: UIViewController) {
        if let ad = interstitial {
            ad.present(from: root)
        }
    }

    func adDidDismissFullScreenContent(_ ad: Any) {
        print("Interstitial ad dismissed")
    }
}
