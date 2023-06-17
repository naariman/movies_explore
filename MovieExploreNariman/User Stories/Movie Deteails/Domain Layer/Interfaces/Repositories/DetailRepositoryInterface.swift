//
//  DetailRepositoryInterface.swift
//  MovieExploreNariman
//
//  Created by Nariman on 15.06.2023.
//

import Foundation

protocol DetailRepositoryInterface: AnyObject {
    func getMovie(by id: Int, completion: @escaping (Result<DetailModel, Error>) -> Void)
}
