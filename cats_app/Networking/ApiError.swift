//
//  ApiError.swift
//  cats_app
//
//  Created by Alejandra on 14/6/22.
//

import Foundation

enum ApiError: Error {
    case invalidPath
}

extension ApiError {
    
    var description: String {
        switch self {
        case .invalidPath:
            return "Invalid Path"
        }
    }
}
