//
//  PortadaViewModel.swift
//  SigloApp
//
//  Created by Macbook Pro 17 i5R on 3/14/25.
//

import Foundation

class PortadaViewModel: ObservableObject {
    @Published var secciones: [SeccionPortada] = []
    @Published var errorMessage: String?

    func obtenerPortada() {
        PortadaService.shared.obtenerPortada { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let secciones):
                    self.secciones = secciones
                case .failure(let error):
                    self.errorMessage = error.localizedDescription
                }
            }
        }
    }
}


