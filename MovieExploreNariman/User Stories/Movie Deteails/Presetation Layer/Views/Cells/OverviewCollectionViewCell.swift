//
//  OverviewCollectionViewCell.swift
//  MovieExploreNariman
//
//  Created by Nariman on 16.06.2023.
//

import UIKit

class OverviewCollectionViewCell: UICollectionViewCell {
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 20, weight: .medium)
        label.textColor = .white
        label.text = "Overview"
        
        return label
    }()
    
    private let discriptionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 16, weight: .regular)
        label.textColor = .white
        label.numberOfLines = 0
        
        return label
    }()
    
    func configure(movieDetail: DetailModel) {
        discriptionLabel.text = movieDetail.overview
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    private func setupUI() {
        contentView.backgroundColor = .black
        contentView.addSubview(titleLabel)
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16)
        ])
        
        contentView.addSubview(discriptionLabel)
        NSLayoutConstraint.activate([
            discriptionLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 16),
            discriptionLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            discriptionLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16)
            
        ])
    }
    
}
