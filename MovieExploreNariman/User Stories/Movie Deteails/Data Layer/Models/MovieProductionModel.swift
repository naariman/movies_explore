//
//  MovieProductionModel.swift
//  MovieExploreNariman
//
//  Created by Nariman on 15.06.2023.
//

import Foundation

struct MovieProductionModel: Decodable {
    let id: Int
    let logoURLPath: String?
    let name: String
    let originCounrty: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case logoURLPath = "logo_path"
        case name
        case originCounrty = "origin_country"
    }
}
