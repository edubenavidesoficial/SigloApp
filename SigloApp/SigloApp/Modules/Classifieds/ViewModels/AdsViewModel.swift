import Foundation
import Combine

class AdsViewModel: ObservableObject {
    @Published var ads: [ClassifiedAd] = []
    @Published var errorMessage: String?
    @Published var isLoading = false

    func loadAds() {
        isLoading = true
        AdsService.shared.fetchAds { [weak self] result in
            DispatchQueue.main.async {
                self?.isLoading = false
                switch result {
                case .success(let ads):
                    self?.ads = ads
                case .failure(let error):
                    self?.errorMessage = error.localizedDescription
                }
            }
        }
    }
}
