//
//  MovieDetailBackgroundCollectionViewCell.swift
//  MovieExploreNariman
//
//  Created by Nariman on 16.06.2023.
//

import UIKit
import Kingfisher

class MovieDetailBackgroundCollectionViewCell: UICollectionViewCell {
    private let imageView: UIImageView = {
       let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleToFill
        return imageView
    }()
    
    func configure(ImageURLPath: String) {
        guard let url = URL(string: Constants.imageHost + ImageURLPath) else  { return }
        imageView.kf.setImage(with: url)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        contentView.addSubview(imageView)
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            imageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor, multiplier: 0.56)
        ])
    }
    
}
