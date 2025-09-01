import SwiftUI
import GoogleMobileAds

struct BannerAdView: UIViewRepresentable {
    let adUnitID: String

    func makeUIView(context: Context) -> BannerView {
        let banner = BannerView() // Inicializador sin argumentos
        banner.adUnitID = adUnitID

        // Asignar tamaño adaptativo
        let screenWidth = UIScreen.main.bounds.width
        banner.adSize = AdSize(size: CGSize(width: screenWidth, height: 50), flags: 0) // Banner estándar

        // Asignar rootViewController
        if let rootViewController = UIApplication.shared
            .connectedScenes
            .compactMap({ $0 as? UIWindowScene })
            .first?.windows
            .first(where: { $0.isKeyWindow })?
            .rootViewController {
            banner.rootViewController = rootViewController
        }

        banner.load(Request())
        return banner
    }

    func updateUIView(_ uiView: BannerView, context: Context) {
        // No necesita actualizarse
    }
}

