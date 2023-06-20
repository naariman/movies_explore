//
//  DetailModel.swift
//  MovieExploreNariman
//
//  Created by Nariman on 15.06.2023.
//

import Foundation

struct DetailModel: Decodable {
    let id: Int
    let title: String
    let imageURLPath: String
    let releaseDate: String
    let duration: Int
    var voteAverage: Double?
    var popularity: Double?
    let overview: String
    var productionCompanies: [MovieProductionModel]
    
    enum CodingKeys: String, CodingKey {
        case id
        case title
        case imageURLPath = "backdrop_path"
        case releaseDate = "release_date"
        case duration = "runtime"
        case voteAverage = "vote_average"
        case popularity
        case overview
        case productionCompanies = "production_companies"
    }
}
