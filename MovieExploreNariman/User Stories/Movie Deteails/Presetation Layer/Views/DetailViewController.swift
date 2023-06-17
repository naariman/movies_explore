//
//  DetailViewController.swift
//  MovieExploreNariman
//
//  Created by Nariman on 15.06.2023.
//

import UIKit

class DetailViewController: UIViewController {
    private let viewModel: DetailViewModel
    private var  collectionView: UICollectionView!
    let width = UIScreen.main.bounds.width
    
    init(viewModel: DetailViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        viewModel.getMovie()
        bindViewModel()
    }
    
    private func setupUI() {
        setupCollectionView()
    }
    
    func bindViewModel() {
        viewModel.didStateChanged = { [weak self] in
            guard let self = self else { return }
            self.collectionView.reloadData()
            self.navigationItem.title = self.viewModel.movieDeatil?.title ?? ""
        }
    }
    
    private func setupCollectionView() {
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: generateLayout())
        view.addSubview(collectionView)
        collectionView.backgroundColor = .black
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
        collectionView.register(MoviePosterCollectionViewCell.self, forCellWithReuseIdentifier: MovieDetailBackgroundCollectionViewCell.identifier)
        collectionView.register(MovieSkeletonCollectionViewCell.self, forCellWithReuseIdentifier: MovieSkeletonCollectionViewCell.identifier)
       
        collectionView.register(MovieDetailCollectionViewCell.self, forCellWithReuseIdentifier: MovieDetailCollectionViewCell.identifier)
        collectionView.register(MovieDetailBackgroundCollectionViewCell.self, forCellWithReuseIdentifier: MovieDetailBackgroundCollectionViewCell.identifier)
        
        collectionView.register(OverviewCollectionViewCell.self, forCellWithReuseIdentifier: OverviewCollectionViewCell.identifier)
      
        collectionView.register(MovieSkeletonCollectionViewCell.self, forCellWithReuseIdentifier: MovieSkeletonCollectionViewCell.identifier)
        
        collectionView.register(MovieProductionCollectionViewCell.self, forCellWithReuseIdentifier: MovieProductionCollectionViewCell.identifier)

    

        collectionView.dataSource = self
        collectionView.delegate = self
        
    }
    
}

extension DetailViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        viewModel.numberOfItemsIn(section: section)
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        viewModel.numberOfSections
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch viewModel.state {
        case .loading:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MovieSkeletonCollectionViewCell.identifier, for: indexPath) as? MovieSkeletonCollectionViewCell else { fatalError() }
            
            return cell
        case .content:
            switch viewModel.sections[indexPath.section] {
            case .detail(let types):
                switch types[indexPath.row] {
                case .image:
                    guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MovieDetailBackgroundCollectionViewCell.identifier, for: indexPath) as? MovieDetailBackgroundCollectionViewCell else { fatalError() }
                    cell.configure(ImageURLPath: viewModel.movieDeatil?.imageURLPath ?? "")
                    
                    return cell
                case .info:
                    guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MovieDetailCollectionViewCell.identifier, for: indexPath) as? MovieDetailCollectionViewCell else { fatalError() }
                    if let movieDeatil = viewModel.movieDeatil {
                        cell.configure(movieDetail: movieDeatil)
                    }
                    
                    return cell
                case .overview:
                    guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: OverviewCollectionViewCell.identifier, for: indexPath) as? OverviewCollectionViewCell else { fatalError() }
                    
                    if let movieDeatil = viewModel.movieDeatil {
                        cell.configure(movieDetail: movieDeatil)
                    }
                    
                    return cell
                }
            case .production:
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MovieProductionCollectionViewCell.identifier, for: indexPath) as? MovieProductionCollectionViewCell else { fatalError() }
                if let movieDeatil = viewModel.movieDeatil {
                    cell.configure(productionCompany: movieDeatil.productionCompanies[indexPath.row])
                }
                
                return cell
            }
        }
    }
}

extension DetailViewController: UICollectionViewDelegate {
    
}

extension DetailViewController {
    private func generateLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout { [weak self] (sectionIndex: Int,
                                                                        layoutEnvironment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection? in
            guard let self = self else { return nil }
            switch self.viewModel.state {
            case .content:
                switch self.viewModel.sections[sectionIndex] {
                case .production:
                    return self.productionCellLayout()
                case .detail:
                    return self.detailCellLayout()
                }
            case .loading:
                return loadingCellLayout()
            }
            
        }

        return layout
    }

    private func detailCellLayout() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(220))
        
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(220))
        
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, repeatingSubitem: item, count: 1)
        
        let sectionSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(220))
        let section = NSCollectionLayoutSection(group: group)
        
        return section
    }
    
    private func productionCellLayout() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .absolute(68), heightDimension: .estimated(100))
        
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(100))
        
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        group.interItemSpacing = .fixed(16)
        
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .continuous
        
        return section
    }
    
    private func loadingCellLayout() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.5),
                                              heightDimension: .absolute(((width - 16) / 2) / 0.58))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)

        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                               heightDimension: .estimated(((width - 16) / 2) / 0.58))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, repeatingSubitem: item, count: 2)
        group.interItemSpacing = .fixed(16)

        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: 18, leading: 16, bottom: 6, trailing: 16)

        return section
    }
}

