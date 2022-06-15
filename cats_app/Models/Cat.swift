//
//  Cat.swift
//  cats_app
//
//  Created by Alejandra on 14/6/22.
//

import UIKit

struct Cat: Decodable {
    let id: String
    let createdAt: String
    let tags: [String]
    
    enum CodingKeys: String, CodingKey {
        case id
        case createdAt = "created_at"
        case tags
    }
}
