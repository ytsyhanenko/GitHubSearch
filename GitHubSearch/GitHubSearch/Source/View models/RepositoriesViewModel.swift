//
//  RepositoriesViewModel.swift
//  GitHubSearch
//
//  Created by Genek on 5/2/18.
//  Copyright © 2018 Yevhen Tsyhanenko. All rights reserved.
//

import Foundation
import CoreData

class RepositoriesViewModel {
    
    // MARK: - Private properties
    
    private var persistentStoreProvider: PersistentStoreProvider
    private var operationQueue: OperationQueue
    
    // MARK: - Initialization
    
    init(persistentStoreProvider: PersistentStoreProvider) {
        self.persistentStoreProvider = persistentStoreProvider
        self.operationQueue = OperationQueue()
    }
    
    // MARK: - Public functions
    
    func search(_ searchText: String, onCompletion: @escaping (Result<[Repository]>) -> ()) {
        let resultArray = ThreadSafeArray<Repository>()
        let operationQueue = self.operationQueue
        let persistentStoreProvider = self.persistentStoreProvider
        let pageCount = Constants.repositoriesPageCount
        let perPage = Constants.repositoriesPerPage
        
        Repository.deleteAll(inContext: self.persistentStoreProvider.backgroundContext)
        
        var operations = Array(1...pageCount)
            .map { (pageIndex: Int) -> (Page) in
                return Page(index: pageIndex, perPage: perPage)
            }
            .map { (page: Page) -> (Operation) in
                let searchProvider = RepositorySearchProvider(persistentStoreProvider: persistentStoreProvider)
                
                let operation = RepositorySearchOperation(searchText: searchText,
                                       page: page,
                                       searchProvider: searchProvider,
                                       sortBy: .stars,
                                       orderBy: .descending)
                { [weak resultArray] result in
                    switch result {
                    case .success(let repositories):
                        resultArray?.append(repositories)
                    case .failure(let error):
                        DispatchQueue.main.async {
                            onCompletion(.failure(error))
                        }
                    }
                }
                
                return operation
            }
        
        let resultOperation = BlockOperation {
            DispatchQueue.main.async {
                persistentStoreProvider.saveBackgroundContext()
            }
        }
        
        resultOperation.addDependencies(operations)
        operations.append(resultOperation)
        
        operationQueue.addOperations(operations, waitUntilFinished: false)
    }
    
    func cancelSearch() {
        self.operationQueue.cancelAllOperations()
    }
    
    func fetchedResultsController() -> NSFetchedResultsController<Repository> {
        return self.persistentStoreProvider.fetchedResultsController(forEntity: Repository.self, sortBy: Constants.starsCountKey)
    }
}
