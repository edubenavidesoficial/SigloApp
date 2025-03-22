//
//  PrintModel.swift
//  SigloApp
//
//  Created by Macbook Pro 17 i5R on 3/21/25.
//

import Foundation

struct PrintModel: Identifiable {
    let id = UUID()
    let title: String
    let imageName: String // Nombre de imagen local o URL
    let date: String
}
