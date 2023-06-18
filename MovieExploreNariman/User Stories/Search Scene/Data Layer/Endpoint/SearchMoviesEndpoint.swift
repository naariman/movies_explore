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
            guard let url = URL(string: Constants.apiHost + "/search/movie") else { fatalError() }
            var components = URLComponents(url: url, resolvingAgainstBaseURL: true)
            var queryItems: [URLQueryItem] = []
            queryItems.append(URLQueryItem(name: "query", value: query))
            queryItems.append(URLQueryItem(name: "page", value: "\(page)"))
            queryItems.append(URLQueryItem(name: "language", value: "en-US"))
            queryItems.append(.init(name: "include_adult", value: "true"))
            components?.queryItems = queryItems
            guard let componentsURL = components?.url else { fatalError() }

            let urlRequest = URLRequest(url: componentsURL)
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


