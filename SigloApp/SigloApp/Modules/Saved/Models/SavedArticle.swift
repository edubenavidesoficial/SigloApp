//
//  SavedArticle.swift
//  SigloApp
//
//  Created by Macbook Pro 17 i5R on 3/14/25.
//

import Foundation

struct SavedArticle: Identifiable {
    let id = UUID()
    let category: String
    let title: String
    let author: String
    let location: String
    let time: String
    let imageName: String
    let description: String? // Usado para SigloTV
}

