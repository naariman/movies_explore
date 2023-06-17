//
//  SearchMovieViewController.swift
//  MovieExploreNariman
//
//  Created by Nariman on 16.06.2023.
//

import UIKit

class SearchMovieViewController: UIViewController {
    private let viewModel: SearchMovieViewModel
    private var collectionView: UICollectionView!
    var width = UIScreen.main.bounds.width
    
    init(viewModel: SearchMovieViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil , bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private var searchController: UISearchController = {
        let viewController = UISearchController(searchResultsController: nil)
        
        return viewController
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupCollectionView()
    }
    
    func setupUI() {
        setupNavigationBar()
    }
    
    func setupNavigationBar() {
        self.navigationController?.navigationBar.tintColor = .white
        navigationItem.searchController = searchController
        searchController.searchBar.delegate = self
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
        collectionView.register(MoviePosterCollectionViewCell.self, forCellWithReuseIdentifier: MoviePosterCollectionViewCell.identifier)
        collectionView.register(MovieSkeletonCollectionViewCell.self, forCellWithReuseIdentifier: MovieSkeletonCollectionViewCell.identifier)

        collectionView.dataSource = self
        collectionView.delegate = self

    }

}

extension SearchMovieViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        viewModel.filteredMovies = viewModel.movies.filter { movie in
            
            return movie.title.lowercased().contains(searchText.lowercased())
        }
        
        collectionView.reloadData()
    }
}

extension SearchMovieViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        viewModel.getNumberOfItems()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        switch viewModel.state {
        case .loading:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MovieSkeletonCollectionViewCell.identifier, for: indexPath) as? MovieSkeletonCollectionViewCell else {fatalError()}
            return cell
        case .content:

            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MoviePosterCollectionViewCell.identifier, for: indexPath) as? MoviePosterCollectionViewCell else { fatalError() }
            cell.configure(movie: viewModel.movies[indexPath.row])
            return cell
        }
    }
    
}

extension SearchMovieViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        guard indexPath.row == viewModel.movies.count - 4 else { return }
        
        viewModel.getMoreMovies()
        collectionView.reloadData()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedMovie = viewModel.movies[indexPath.row]
        let id = selectedMovie.id
        
        let network = Network()
        let dataSource = DetailsRemoteDataSource(network: network)
        let repository = DetailRepository(dataSource: dataSource)
        let viewModel = DetailViewModel(id: id, repository: repository)
        let viewController = DetailViewController(viewModel: viewModel)
        
        navigationController?.pushViewController(viewController, animated: true)
    }
}


extension SearchMovieViewController {
    private func generateLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout { [weak self] (sectionIndex: Int,
                                                                        layoutEnvironment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection? in
            guard let self = self else { return nil }
            return self.cellLayout()
        }

        return layout
    }

    private func cellLayout() -> NSCollectionLayoutSection {
        
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



