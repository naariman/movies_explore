//
//  DetailsDataSource.swift
//  MovieExploreNariman
//
//  Created by Nariman on 15.06.2023.
//

import Foundation

protocol DetailsDataSource: AnyObject {
    func getMovieDeatils(by id: Int, completion: @escaping (Result<DetailModel, Error>) -> Void)
}
 
class DetailsRemoteDataSource {
    private let network: Network
    
    init(network: Network) {
        self.network = network
    }
}

extension DetailsRemoteDataSource: DetailsDataSource {
    func getMovieDeatils(by id: Int, completion: @escaping (Result<DetailModel, Error>) -> Void) {
        network.execute(DetailsEndpoint.getDetails(movieId: id), completion: completion)
    }
}

/*
 
 class MoviesByCatagoryRemoteDataSource {
     private let network: Network
     
     init(network: Network) {
         self.network = network
     }
 }

 extension MoviesByCatagoryRemoteDataSource: MoviesByCategoryDataSource {
     func getMovies(by category: String, page: Int, completion: @escaping (Result<PagenationModel<MoviePosterModel>, Error>) -> Void) {
         network.execute(MoviesCategoriesEndpoint.getMovies(category: category, page: page), completion: completion)
     }
 }

 
 */
