//
//  SearchMoviesRepositryInterface.swift
//  MovieExploreNariman
//
//  Created by Nariman on 16.06.2023.
//

import Foundation

protocol SearchMoviesRepositryInterface: AnyObject {
    func getMovies(query: String, completion: @escaping (Result<[MoviePosterModel], Error>) -> Void)
    func getMoreMovies(completion: @escaping (Result<[MoviePosterModel], Error>) -> Void)
}
