//
//  URL + ext.swift
//  MovieExploreNariman
//
//  Created by Nariman on 11.06.2023.
//

import Foundation

extension URLRequest {
    mutating func addAuthorizationToken() {
        allHTTPHeaderFields = ["Authorization": "Bearer \(Constants.apiToken)"]
    }
}
