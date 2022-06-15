//
//  UILabel+Factory.swift
//  cats_app
//
//  Created by Alejandra on 14/6/22.
//

import UIKit

extension UILabel {
    static func newHeaderLabel() -> UILabel {
        let headerLabel = UILabel()
        headerLabel.textColor = .black
        headerLabel.font = .systemFont(ofSize: 24, weight: .bold)
        return headerLabel
    }
}
