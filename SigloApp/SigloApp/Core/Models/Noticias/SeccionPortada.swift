//
//  Seccion.swift
//  SigloApp
//
//  Created by Macbook Pro 17 i5R on 3/14/25.
//

import Foundation

struct SeccionPortada: Identifiable {
    var id: String { seccion }
    let seccion: String
    let notas: [Nota]
}

