//
//  SavedArticle.swift
//  SigloApp
//
//  Created by Macbook Pro 17 i5R on 3/14/25.
//

import Foundation

struct SavedArticle: Identifiable {
    var id = UUID()
    var category: String
    var title: String
    var author: String
    var location: String
    var time: String
    var imageName: String
    var description: String?
}
