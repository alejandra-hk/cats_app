//
//  Cat.swift
//  cats_app
//
//  Created by Alejandra on 14/6/22.
//

import UIKit

struct Cat: Decodable {
    let id: String
    let created_at: String
    let tags: [String]
}
