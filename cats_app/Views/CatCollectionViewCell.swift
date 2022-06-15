//
//  CatCollectionViewCell.swift
//  cats_app
//
//  Created by Alejandra on 14/6/22.
//

import UIKit

class CatCollectionViewCell: UICollectionViewCell {
    
    // MARK: - Properties
    private lazy var imageView = UIImageView()
    
    static let cellIdentifier = "CatCell"
    
    var image: UIImage? {
        didSet {
            imageView.image = image
        }
    }
    
    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        setupInitialState()
    }
}

// MARK: - Setup
private extension CatCollectionViewCell {
    func setup() {
        setupViews()
        setupUI()
    }
    
    func setupViews() {
        contentView.addSubview(imageView)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        setupLayout()
    }
    
    func setupLayout() {
        imageView.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        imageView.leftAnchor.constraint(equalTo: contentView.leftAnchor).isActive = true
        imageView.rightAnchor.constraint(equalTo: contentView.rightAnchor).isActive = true
        imageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
    }
    
    func setupUI() {
        contentView.roundCorners(.allCorners, radius: 5)
        imageView.contentMode = .scaleAspectFill
    }
    
    func setupInitialState() {
        imageView.image = nil
    }
}
