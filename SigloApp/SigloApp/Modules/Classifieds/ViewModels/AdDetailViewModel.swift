import Foundation

class AdDetailViewModel: ObservableObject {
    @Published var adDetail: ClassifiedAd?
    @Published var isLoading = false
    @Published var errorMessage: String?

    func loadAdDetail(id: String) {
        isLoading = true
        errorMessage = nil

        AdDetailService.shared.fetchAdDetail(id: id) { [weak self] result in
            DispatchQueue.main.async {
                self?.isLoading = false
                switch result {
                case .success(let ad):
                    self?.adDetail = ad
                case .failure(let error):
                    self?.errorMessage = error.localizedDescription
                }
            }
        }
    }
}
