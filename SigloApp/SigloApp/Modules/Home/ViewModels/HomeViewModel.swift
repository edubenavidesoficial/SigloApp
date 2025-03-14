//
//  HomeViewModel.swift
//  SigloApp
//
//  Created by Macbook Pro 17 i5R on 3/13/25.
//

import Foundation

final class HomeViewModel: ObservableObject {
    @Published var items: [Noticia] = []

    func fetchItems() {
        // Simula una llamada a red
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.items = [
                Noticia(id: 1, title: "Título 1", description: "Descripción de la noticia 1"),
                Noticia(id: 2, title: "Título 2", description: "Descripción de la noticia 2"),
                Noticia(id: 3, title: "Título 3", description: "Descripción de la noticia 3")
            ]
        }
    }
}
