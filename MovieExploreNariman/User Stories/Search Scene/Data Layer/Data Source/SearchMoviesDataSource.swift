//
//  SearchMoviesDataSource.swift
//  MovieExploreNariman
//
//  Created by Nariman on 16.06.2023.
//

import Foundation

protocol SearchMoviesDataSource: AnyObject {
    func getMovies(query: String, page: Int, completion: @escaping (Result<PaginationModel<MoviePosterModel>, Error>) -> Void)
}

class SearchMoviesDataRemoteSource {
    private let network: Network
    
    init(network: Network) {
        self.network = network
    }
}

extension SearchMoviesDataRemoteSource: SearchMoviesDataSource {
    func getMovies(query: String, page: Int, completion: @escaping (Result<PaginationModel<MoviePosterModel>, Error>) -> Void) {
        network.execute(SearchMoviesEndpoint.getMovies(query: query, page: page), completion: completion)
    }
}
