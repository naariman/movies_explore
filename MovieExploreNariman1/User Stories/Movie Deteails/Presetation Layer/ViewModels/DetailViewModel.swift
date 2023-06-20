//
//  DetailViewModel.swift
//  MovieExploreNariman
//
//  Created by Nariman on 15.06.2023.
//

import Foundation

class DetailViewModel {
    private let id: Int
    private let repository: DetailRepositoryInterface
    private(set) var state: State = .loading {
        didSet {
            DispatchQueue.main.async {
                self.didStateChanged?()
            }
        }
    }
    private(set) var movieDeatil: DetailModel?
    var sections: [Section] = []
    
    var didStateChanged: (() -> Void)?
    
    enum DetailSectionType {
        case  image
        case  info
        case  overview
    }
    
    enum State {
        case loading
        case content
    }
    
    enum Section {
        case detail(types: [DetailSectionType])
        case production
    }
    
    init(id: Int, repository: DetailRepositoryInterface) {
        self.id = id
        self.repository = repository
    }
    
    func getMovie() {
        state = .loading
        
        repository.getMovie(by: id) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let movieDetail):
                self.movieDeatil = movieDetail
                let types: [DetailSectionType] = [.image, .info, .overview]
                self.sections = [.detail(types: types), .production]
                self.state = .content
                                
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    var numberOfSections: Int {
        switch state {
        case .loading:
            return 1
        case .content:
            return self.sections.count
        }
    }
    
    func numberOfItemsIn(section: Int) -> Int {
        switch state {
        case .loading:
            return 1
        case .content:
            switch sections[section] {
            case .detail(let types):
                return types.count
            case .production:
                return 1
            }
        }
    }
        
}
 
