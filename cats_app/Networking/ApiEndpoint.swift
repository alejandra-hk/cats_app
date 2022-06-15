//
//  ApiEndpoint.swift
//  cats_app
//
//  Created by Alejandra on 14/6/22.
//

import Foundation

enum ApiEndpoint {
    case getAllCats(limit: Int)
    case getCat(_ id: String)
    
    var path: String {
        switch self {
        case .getAllCats:
            return "api/cats"
        case .getCat:
            return "cat"
        }
    }
    
    var method: Method {
        switch self {
        case .getAllCats:
            return .GET
        case .getCat:
            return .GET
        }
    }
    
    var parameters: [URLQueryItem]? {
        switch self {
        case .getAllCats(let limit):
            return [URLQueryItem(name: "limit", value: "\(limit)")]
        case .getCat(let id):
            return [URLQueryItem(name: "id", value: id)]
        }
    }
    
    enum Method: String {
        case GET
        case POST
        case PUT
        case DELETE
    }
}
