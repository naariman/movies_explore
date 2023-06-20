//
//  PogenationModel.swift
//  MovieExploreNariman
//
//  Created by Nariman on 10.06.2023.
//

import Foundation

struct PaginationModel<T: Decodable>: Decodable {
    let page: Int
    let totalPages: Int
    let totalResults: Int
    let results: [T]
    
    enum CodingKeys: String, CodingKey {
        case page
        case totalPages = "total_pages"
        case totalResults = "total_results"
        case results
    }
}
