import Combine

class UserSubscriptionViewModel: ObservableObject {
    @Published var suscripcion: SuscripcionPayload?
    @Published var errorMessage: String?
    @Published var isLoading = false

    func cargarSuscripcion(usuarioId: Int) {
        print("📥 Intentando cargar suscripción para usuarioId: \(usuarioId)") // 👈 debug
        isLoading = true
        SubscriptionsService.shared.obtenerSuscripcion(usuarioId: usuarioId) { [weak self] result in
            guard let self = self else { return }
            self.isLoading = false
            switch result {
            case .success(let payload):
                print("✅ Suscripción recibida para ID: \(usuarioId)")
                self.suscripcion = payload
            case .failure(let error):
                print("❌ Error para ID: \(usuarioId) - \(error.localizedDescription)")
                self.errorMessage = error.localizedDescription
            }
        }
    }
}
