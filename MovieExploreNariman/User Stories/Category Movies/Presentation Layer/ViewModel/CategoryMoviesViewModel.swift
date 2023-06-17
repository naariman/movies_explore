//
//  CategoryMovies.swift
//  MovieExploreNariman
//
//  Created by Nariman on 15.06.2023.

import UIKit

class CategoryMoviesViewModel {
    private let repository: MoviesByCatogoryRepositoriesInterface
    private let moviesCategory: MoviesCatagory
    private(set) var movies: [MoviePosterModel] = []
    
    private(set) var state: State = .loading {
        didSet {
            DispatchQueue.main.async {
                self.didStateChange?()
            }
        }
    }
    
    var navigationTitle: String {
        moviesCategory.title
    }
    
    var didStateChange: (() -> Void)?
    var didGetError: ((String) -> Void)?
    
    enum State {
        case loading
        case content
    }
    
    init(moviesCategory: MoviesCatagory, repository: MoviesByCatogoryRepositoriesInterface) {
        self.moviesCategory = moviesCategory
        self.repository = repository
    }
    
    func getMovies() {
        state = .loading
        
        repository.getMovies(by: moviesCategory ) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let movies):
                self.movies = movies
                self.state = .content
            case .failure(let error):
                DispatchQueue.main.async {
                    self.didGetError?(error.localizedDescription)
                }
            }
        }
    }
    func getNumberOfItemsIn(section: Int) -> Int {
        switch state {
        case .content:
            return movies.count
        case .loading:
            return 6
        }
    }
    
    func getMoreMovies() {
        repository.getMoreMovies { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let movies):
                self.movies += movies
                self.state = .content
            case .failure(let error):
                DispatchQueue.main.async {
                    self.didGetError?(error.localizedDescription)
                }
            }
        }
    }
    
}

    
