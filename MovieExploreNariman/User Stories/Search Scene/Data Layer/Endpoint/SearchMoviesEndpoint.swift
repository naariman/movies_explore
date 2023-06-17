//
//  SearchEndpoint.swift
//  MovieExploreNariman
//
//  Created by Nariman on 16.06.2023.
//

import Foundation

enum SearchMoviesEndpoint {
    case getMovies(query: String, page: Int)
}

extension SearchMoviesEndpoint: RequestProviding {
    
    var urlRequest: URLRequest {
        switch self {
        case .getMovies(let query, let page):
            guard let url = URL(string: Constants.apiHost + "/search/movie?querymovie?query=\(query)&include_adult=false&language=en-US&page=\(page)") else { fatalError() }
            let urlRequest = URLRequest(url: url)
            return urlRequest
        }
    }
    
    var shouldAddAuthorizationToken: Bool {
        switch self {
        case .getMovies:
            return true
        }
    }
}


