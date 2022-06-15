//
//  ApiManager.swift
//  cats_app
//
//  Created by Alejandra on 14/6/22.
//

import Foundation

class ApiManager {
    
    static let shared = ApiManager()
    
    private let session = URLSession.shared
    private let decoder = JSONDecoder()
    
    private init() {}
    
    func getDecodedData<D: Decodable>(from endpoint: ApiEndpoint) async throws -> D {
        let request = try createRequest(from: endpoint)
        let response: (data: Data, response: URLResponse) = try await session.data(for: request)
        return try decoder.decode(D.self, from: response.data)
    }
    
    func getData(from endpoint: ApiEndpoint) async throws -> Data {
        let request = try createRequest(from: endpoint)
        let response: (data: Data, response: URLResponse) = try await session.data(for: request)
        return response.data
    }
}

private extension ApiManager {
    
    func createRequest(from endpoint: ApiEndpoint) throws -> URLRequest {
        guard
            let urlPath = URL(string: ApiHelper.baseURL.appending(endpoint.path)),
            var urlComponents = URLComponents(string: urlPath.absoluteString)
        else {
            throw ApiError.invalidPath
        }
        
        if let parameters = endpoint.parameters {
            urlComponents.queryItems = parameters
        }
        
        var request = URLRequest(url: urlComponents.url ?? urlPath)
        request.httpMethod = endpoint.method.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.cachePolicy = .reloadIgnoringLocalCacheData
        return request
    }
}
