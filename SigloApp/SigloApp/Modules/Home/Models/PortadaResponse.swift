//
//  PortadaResponse.swift
//  SigloApp
//
//  Created by Macbook Pro 17 i5R on 3/14/25.
//

import Foundation

struct PortadaResponse: Codable {
    let result: ResultData
}

struct ResultData: Codable {
    let pageContext: PageContext
}

struct PageContext: Codable {
    let portada: [String]
}
