//
//  DetailRepository.swift
//  MovieExploreNariman
//
//  Created by Nariman on 15.06.2023.
//

import Foundation

class DetailRepository {
    private let dataSource: DetailsDataSource
    
    init(dataSource: DetailsDataSource) {
        self.dataSource = dataSource
    }
}

extension DetailRepository: DetailRepositoryInterface {
    func getMovie(by id: Int, completion: @escaping (Result<DetailModel, Error>) -> Void) {
        dataSource.getMovieDeatils(by: id, completion: completion)
    }
    
}
 
