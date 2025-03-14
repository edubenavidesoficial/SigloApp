//
//  NewsModel.swift
//  SigloApp
//
//  Created by Macbook Pro 17 i5R on 3/13/25.
//
import Foundation

struct NewsModel: Identifiable {
    let id = UUID()
    let category: String
    let title: String
    let author: String
    let time: String
    let imageName: String
}

let secondaryNewsData = [
    NewsModel(category: "CLUB SANTOS LAGUNA", title: "Club Santos Laguna: Los Guerreros se preparan para el choque contra San Luis", author: "HUMBERTO VÁZQUEZ", time: "08:31 hrs", imageName: "santos")
]

