//
//  Errors.swift
//  SigloApp
//
//  Created by Macbook Pro 17 i5R on 3/22/25.
//

import Foundation

enum LoginServiceError: Error {
    case invalidURL
    case emptyData
    case custom(String)
    case decodingError(Error)
}
