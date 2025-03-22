//
//  HomeViewModel.swift
//  SigloApp
//
//  Created by Macbook Pro 17 i5R on 3/13/25.
//

import Foundation

class HomeViewModel: ObservableObject {
    @Published var secciones: [SeccionPortada] = []
    @Published var isLoading = false
    @Published var errorMessage: String?

    func fetchItems() {
        isLoading = true
        errorMessage = nil

        PortadaService.shared.obtenerPortada { [weak self] result in
            guard let self = self else { return }

            self.isLoading = false

            switch result {
            case .success(let secciones):
                self.secciones = secciones
                print("✅ Secciones cargadas: \(secciones.count)")
            case .failure(let error):
                self.errorMessage = error.localizedDescription
                print("❌ Error al cargar secciones: \(error)")
            }
        }
    }
}
