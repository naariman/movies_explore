//
//  MoviesByCategoryRepository.swift
//  MovieExploreNariman
//
//  Created by Nariman on 10.06.2023.
//

import Foundation

class MoviesByCategoryRepository {
    private let remoteDataSource: MoviesByCatagoryRemoteDataSource
    private var currentPage: Int = 1
    private var totalPages: Int = 1
    private var category: MoviesCatagory?
    
    init(remoteDataSource: MoviesByCatagoryRemoteDataSource) {
        self.remoteDataSource = remoteDataSource
    }
    
}

extension MoviesByCategoryRepository: MoviesByCatogoryRepositoriesInterface{
    
    func getMovies(by category: MoviesCatagory, completion: @escaping (Result<[MoviePosterModel], Error>) -> Void) {
        currentPage = 1
        self.category = category
        remoteDataSource.getMovies(by: category.rawValue, page: currentPage) { [weak self] result in
            guard let self = self else {return}
            switch result {
            case .success(let paginationModel):
                self.totalPages = paginationModel.totalPages
                
                if totalPages > currentPage {
                    self.currentPage = paginationModel.page + 1
                }
                
                completion(.success(paginationModel.results))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func getMoreMovies(completion: @escaping (Result<[MoviePosterModel], Error>) -> Void) {
        if currentPage > totalPages {
            completion(.success([]))
        }
        
        guard let category = category else {
            completion(.failure(NSError(domain: "no categories", code: 0)))
            return
        }
        
        remoteDataSource.getMovies(by: category.rawValue, page: currentPage + 1) { [weak self] result in
            guard let self = self else {return}
            switch result {
            case .success(let paginationModel):
                self.totalPages = paginationModel.totalPages
                
                if totalPages > currentPage {
                    self.currentPage = paginationModel.page + 1
                }
                
                completion(.success(paginationModel.results))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
