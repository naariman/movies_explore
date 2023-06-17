//
//  MovieCategoryEndpoint.swift
//  MovieExploreNariman
//
//  Created by Nariman on 10.06.2023.
//

import Foundation

enum MoviesCategoriesEndpoint {
    case getMovies(category: String, page: Int)
}

extension MoviesCategoriesEndpoint: RequestProviding {
    var urlRequest: URLRequest {
        switch self {
        case .getMovies(let category, let page):
            guard let url = URL(string: Constants.apiHost + "/movie/\(category)?language=en-US&page=\(page)") else { fatalError() }
            var urlRequest = URLRequest(url: url)
            urlRequest.httpMethod = "GET"
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
