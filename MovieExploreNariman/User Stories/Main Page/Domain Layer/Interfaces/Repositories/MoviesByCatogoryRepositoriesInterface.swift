//
//  MoviesByCatogoryRepositoriesInterface.swift
//  MovieExploreNariman
//
//  Created by Nariman on 10.06.2023.
//

import Foundation

protocol MoviesByCatogoryRepositoriesInterface: AnyObject {
    func getMovies(by category: MoviesCatagory, completion: @escaping (Result<[MoviePosterModel], Error>) -> Void)
    func getMoreMovies(completion: @escaping (Result<[MoviePosterModel], Error>) -> Void)
}
