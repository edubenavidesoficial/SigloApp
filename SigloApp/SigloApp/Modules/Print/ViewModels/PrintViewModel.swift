import Foundation
import SwiftUI

enum TabTypetwo: String, CaseIterable {
    case hemeroteca = "HEMEROTECA EL SIGLO DE TORREÓN"
    case suplementos = "SUPLEMENTOS"
}

class PrintViewModel: ObservableObject {
    @Published var selectedTab: TabTypetwo = .hemeroteca
    @Published var hemeroteca: [PrintModel] = []
    @Published var suplementos: [PrintModel] = [
        PrintModel(title: "Especial deportivo semanal", imageName: "hemeroteca_071024", date: "06/10/2024"),
        PrintModel(title: "Cultura y arte en La Laguna", imageName: "hemeroteca_071024", date: "06/10/2024")
    ]
    @Published var errorMessage: String?

    private let printService = PrintService.shared  // Instancia compartida

    init() {
        fetchNewspaper() // Llamada automática al inicializar el ViewModel
    }

    /// Función para obtener los datos del periódico
    func fetchNewspaper() {
        printService.obtenerPortada { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let payloads):
                    //print("✅ Respuesta de la API: \(payloads)") // Depuración

                    self?.hemeroteca = payloads.first?.portadas.map { portada in
                        PrintModel(
                            title: portada.titulo,
                            imageName: portada.cover,  // Aquí es donde debes asegurarte de que 'cover' sea una URL válida o una cadena que pueda usarse para cargar la imagen.
                            date: payloads.first?.fecha ?? "Desconocido"
                        )
                    } ?? []
                    

                case .failure(let error):
                    print("❌ Error: \(error.localizedDescription)")
                    self?.errorMessage = "Error al obtener datos: \(error.localizedDescription)"
                }
            }
        }
    }

    /// Obtiene los artículos según la pestaña seleccionada
    func articlesForCurrentTab() -> [PrintModel] {
        switch selectedTab {
        case .hemeroteca:
            return hemeroteca
        case .suplementos:
            return suplementos
        }
    }
}
