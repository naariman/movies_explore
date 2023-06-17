//
//  SearchMoviesRepository.swift
//  MovieExploreNariman
//
//  Created by Nariman on 16.06.2023.
//

import Foundation

class SearchMoviesRepository {
    private let remoteDataSource: SearchMoviesDataRemoteSource
    private var currentPage: Int = 1
    private var totalPages: Int = 1
    private var query: String?
    
    init(remoteDataSource: SearchMoviesDataRemoteSource) {
        self.remoteDataSource = remoteDataSource
    }
}

extension SearchMoviesRepository: SearchMoviesRepositryInterface {
    func getMovies(query: String, completion: @escaping (Result<[MoviePosterModel], Error>) -> Void) {
        currentPage = 1
        self.query = query
        
        remoteDataSource.getMovies(query: query, page: currentPage) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let paginationModel):
                self.totalPages = paginationModel.totalPages
                self.currentPage = paginationModel.page
                
                completion(.success(paginationModel.results))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func getMoreMovies(completion: @escaping (Result<[MoviePosterModel], Error>) -> Void) {
        if currentPage > totalPages {
            completion(.success([]))
            return
        }
        
        
        remoteDataSource.getMovies(query: query ?? "A", page: currentPage + 1) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let paginationModel):
                self.totalPages = paginationModel.totalPages
                self.currentPage = paginationModel.page
                
                completion(.success(paginationModel.results))
            case .failure(let error):
                completion(.failure(error))
            }
            
        }
    }
    
    
}
