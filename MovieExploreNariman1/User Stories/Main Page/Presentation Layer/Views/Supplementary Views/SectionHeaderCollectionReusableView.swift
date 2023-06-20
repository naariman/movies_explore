//
//  SectionHeaderCollectionReusableView.swift
//  MovieExploreNariman
//
//  Created by Nariman on 11.06.2023.
//

import UIKit

protocol SectionHeaderCollectionReusableViewDelegate: AnyObject {
    func didSeeAllButtonTapped(moviesCategory: MoviesCatagory)
}

class SectionHeaderCollectionReusableView: UICollectionReusableView {
    weak var delegate: SectionHeaderCollectionReusableViewDelegate?
    
    private var moviesCategory: MoviesCatagory?
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 20, weight: .bold)
        label.textColor = .white
        label.numberOfLines = 0
        return label
    }()
    
    private let seeAllButton: UIButton = {
        let button = UIButton()
        button.setTitleColor(.systemGray3, for: .normal)  // Исправленная строка
        button.titleLabel?.font = .systemFont(ofSize: 12, weight: .regular)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("See all", for: .normal)
        return button
    }()
    
    func configure(title: String, movieCategory: MoviesCatagory) {
        self.moviesCategory = movieCategory
        titleLabel.text = title
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    private func setupUI() {
        addSubview(titleLabel)
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 10),
        ])
        
        addSubview(seeAllButton)
        NSLayoutConstraint.activate([
            seeAllButton.trailingAnchor.constraint(equalTo: trailingAnchor),
            seeAllButton.centerYAnchor.constraint(equalTo: titleLabel.centerYAnchor),
            seeAllButton.leadingAnchor.constraint(equalTo: titleLabel.trailingAnchor, constant: 16),
            seeAllButton.widthAnchor.constraint(equalToConstant: 66),
            seeAllButton.heightAnchor.constraint(equalToConstant: 28)
        ])
        
        seeAllButton.addTarget(self, action: #selector(seeAll), for: .touchUpInside)
        
    }
    
    @objc
    private func seeAll() {
        guard let moviesCategory = moviesCategory else { return }
        delegate?.didSeeAllButtonTapped(moviesCategory: moviesCategory)
    }
}
