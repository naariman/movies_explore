//
//  MoviesCetegory.swift
//  MovieExploreNariman
//
//  Created by Nariman on 10.06.2023.
//

import Foundation

enum MoviesCatagory: String, CaseIterable {
    case nowPlaying = "now_playing"
    case popular
    case topRated = "top_rated"
    case upcoming
    
    var title: String {
        switch self {
        case .nowPlaying:
            return "Now Playing"
        case .popular:
            return "Popular"
        case .topRated:
            return "Top Rated"
        case .upcoming:
            return "Upcoming"
        }
    }
}
