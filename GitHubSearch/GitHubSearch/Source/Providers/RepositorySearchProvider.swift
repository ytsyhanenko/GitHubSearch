//
//  RepositoriesProvider.swift
//  GitHubSearch
//
//  Created by Genek on 4/30/18.
//  Copyright © 2018 Yevhen Tsyhanenko. All rights reserved.
//

import Foundation

class RepositorySearchProvider {
    
    typealias JSON = [String : Any?]
    
    // MARK: - Private properties
    
    private var session: RepositorySearchSession?
    private var persistentStoreProvider: PersistentStoreProvider
    
    // MARK: - Initialization
    
    init(persistentStoreProvider: PersistentStoreProvider) {
        self.persistentStoreProvider = persistentStoreProvider
    }
    
    // MARK: - Public functions
    
    func search(
        _ searchText: String,
        page: Page,
        sortBy sorting: RepositorySortingType,
        orderBy order: RepositoryOrderType,
        onCompletion: @escaping (Result<[Repository]>) -> ())
    {
        self.session = RepositorySearchSession(searchText: searchText, page: page, sortBy: sorting, orderBy: order)
        self.session?.request { result in
            switch result {
            case .success(let data):
                self.parseRepositories(from: data, onCompletion: onCompletion)
            case .failure(let error):
                onCompletion(.failure(error))
            }
        }
    }
    
    func cancelSearch() {
        self.session?.cancel()
    }
    
    // MARK: - Private functions
    
    private func parseRepositories(from data: Data, onCompletion: (Result<[Repository]>) -> ()) {
        guard let object = try? JSONSerialization.jsonObject(with: data),
            let json = object as? [String : Any?] else {
                onCompletion(.failure(GSError.unspecified))

                return
        }
        
        let repositories = json[API.Keys.items] as! [[String : Any?]]
        let context = self.persistentStoreProvider.backgroundContext
        
        let result: [Repository] = repositories
            .flatMap { json in
                let name = json[API.Keys.name] as? String
                let trimmedName = name
                    .flatMap { $0.prefix(Constants.searchResultMaxLength) }
                    .flatMap { String($0) }
                
                let urlString = json[API.Keys.url] as? String
                let url = urlString.flatMap { URL(string: $0) }
                let starsCount = json[API.Keys.starsCount] as? Int
                
                return Repository.addRepository(name: trimmedName, url: url, stars: starsCount ?? 0, context: context)
            }

        onCompletion(.success(result))
    }
}
