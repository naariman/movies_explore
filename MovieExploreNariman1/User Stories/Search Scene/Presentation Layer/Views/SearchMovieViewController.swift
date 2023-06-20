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
    private var searchText: String = ""
    
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
        bindViewModel()
        setupUI()
        setupCollectionView()
    }
    
    private func bindViewModel() {
        viewModel.didStateChange = { [weak self] in
            guard let self = self else { return }
            self.collectionView.reloadData()
        }
    }
    
    func setupUI() {
        setupNavigationBar()
    }
    
    func setupNavigationBar() {
        self.navigationController?.navigationBar.tintColor = .white
        navigationItem.searchController = searchController
        searchController.delegate = self
        searchController.searchBar.delegate = self
    }
    
    @objc
    private func getMovie() {
        viewModel.getMovies(query: searchText)
    }
                     
    private func search() {
        NSObject.cancelPreviousPerformRequests(withTarget: self, selector: #selector(getMovie), object: nil)
        self.perform(#selector(getMovie), with: nil, afterDelay: 0.5)
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
        collectionView.register(SeacrhMovieCollectionViewCell.self, forCellWithReuseIdentifier: SeacrhMovieCollectionViewCell.identifier)
        collectionView.register(MovieSkeletonCollectionViewCell.self, forCellWithReuseIdentifier: MovieSkeletonCollectionViewCell.identifier)

        collectionView.dataSource = self
        collectionView.delegate = self
    }

}

extension SearchMovieViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        guard searchText.count > 0 else {
            collectionView.reloadData()
            return
        }
        
        self.searchText = searchText
        search()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        collectionView.reloadData()
    }
}

extension SearchMovieViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        viewModel.getNumberOfItems
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch viewModel.state {
        case .loading:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MovieSkeletonCollectionViewCell.identifier, for: indexPath) as? MovieSkeletonCollectionViewCell else {fatalError()}
            return cell
        case .content:
            print("contentef")
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SeacrhMovieCollectionViewCell.identifier, for: indexPath) as! SeacrhMovieCollectionViewCell
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
    
//    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        let selectedMovie = viewModel.movies[indexPath.row]
//        let id = selectedMovie.id
//
//        let network = Network()
//        let dataSource = DetailsRemoteDataSource(network: network)
//        let repository = DetailRepository(dataSource: dataSource)
//        let viewModel = DetailViewModel(id: id, repository: repository)
//        let viewController = DetailViewController(viewModel: viewModel)
//
//        navigationController?.pushViewController(viewController, animated: true)
//    }
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

extension SearchMovieViewController: UISearchControllerDelegate {
    
}

