import Foundation
import SwiftUI

enum TabTypetwo: String, CaseIterable {
    case hemeroteca = "HEMEROTECA EL SIGLO DE TORREÓN"
    case suplementos = "SUPLEMENTOS"
}

class PrintViewModel: ObservableObject {
    @Published var selectedTab: TabTypetwo = .hemeroteca

    // Simulamos artículos para cada categoría
    @Published var hemeroteca: [PrintModel] = [
        PrintModel(title: "Exige INE no frenar elecciones", imageName: "hemeroteca_071024", date: "07/10/2024"),
        PrintModel(title: "Israel cumple un año en guerra", imageName: "hemeroteca_071024", date: "07/10/2024")
    ]

    @Published var suplementos: [PrintModel] = [
        PrintModel(title: "Especial deportivo semanal", imageName: "hemeroteca_071024", date: "06/10/2024"),
        PrintModel(title: "Cultura y arte en La Laguna", imageName: "hemeroteca_071024", date: "06/10/2024")
    ]

    func articlesForCurrentTab() -> [PrintModel] {
        switch selectedTab {
        case .hemeroteca:
            return hemeroteca
        case .suplementos:
            return suplementos
        }
    }
}

