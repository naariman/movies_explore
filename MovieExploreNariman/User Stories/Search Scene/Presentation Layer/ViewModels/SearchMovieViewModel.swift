//
//  SearchMovieViewModel.swift
//  MovieExploreNariman
//
//  Created by Nariman on 16.06.2023.
//

import Foundation

class SearchMovieViewModel {
    private let repository: SearchMoviesRepositryInterface
    private(set) var movies: [MoviePosterModel] = []
    
    private(set) var state: State = .loading {
        didSet {
            DispatchQueue.main.async {
                self.didStateChange?()
            }
        }
    }
    
    var didStateChange: (() -> Void)?
    var didGetError: ((String) -> Void)?
    
    enum State {
        case loading
        case content
    }
    
    
    init(repository: SearchMoviesRepositryInterface) {
        self.repository = repository
    }
    
    func getMovies(query: String) {
        state = .loading
        movies = []

        repository.getMovies(query: query) { [weak self] result in
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
    
    var getNumberOfItems: Int {
        switch state {
        case .content:
            return movies.count
        case .loading:
            return 0
        }
    }

}
