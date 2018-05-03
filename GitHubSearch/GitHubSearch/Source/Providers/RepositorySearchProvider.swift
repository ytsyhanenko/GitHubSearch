//
//  RepositoriesProvider.swift
//  GitHubSearch
//
//  Created by Genek on 4/30/18.
//  Copyright © 2018 Yevhen Tsyhanenko. All rights reserved.
//

import Foundation

class RepositorySearchProvider {
    
    // MARK: - Private properties
    
    private var session: RepositorySearchSession?
    
    // MARK: - Public functions
    
    func request(
        _ searchText: String,
        searchLimit: Int = APIConstants.defaultRepositorySearchLimit,
        onCompletion: @escaping (Result<[Repository]>) -> ())
    {
        self.session = RepositorySearchSession(searchText: searchText, searchLimit: searchLimit)
        self.session?.request { result in
            switch result {
            case .success(let data):
                let repositories = self.parse(data: data)
                
                onCompletion(.success(repositories))
            case .failure(let error):
                onCompletion(.failure(error))
            }
        }
    }
    
    // MARK: - Private functions
    
    private func parse(data: Data) -> [Repository] {
        let jsonType = [String : [String : [String : [[String : Repository]]]]].self
        let json = try? JSONDecoder().decode(jsonType, from: data)
        
        return json?[APIConstants.dataKey]
            .flatMap { $0[APIConstants.searchKey] }
            .flatMap { $0[APIConstants.edgesKey] }?
            .flatMap { $0[APIConstants.nodeKey] } ?? []
    }
}
