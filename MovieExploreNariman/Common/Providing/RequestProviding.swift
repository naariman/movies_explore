//
//  RequestProviding.swift
//  MovieExploreNariman
//
//  Created by Nariman on 11.06.2023.
//

import Foundation

protocol RequestProviding {
    var shouldAddAuthorizationToken: Bool { get }
    var urlRequest: URLRequest { get }
}
