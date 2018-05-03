//
//  RepositoriesViewModel.swift
//  GitHubSearch
//
//  Created by Genek on 5/2/18.
//  Copyright © 2018 Yevhen Tsyhanenko. All rights reserved.
//

import Foundation

class SearchOperation: Operation {
    
    // MARK: - Overridden properties
    
    override var isAsynchronous: Bool {
        return true
    }
    
    // MARK: - Private properties
    
    private var searchProvider: RepositorySearchProvider
    private var searchText: String
    private var completionHandler: (Result<[Repository]>) -> () = { _ in }
    
    // MARK: - Initialization
    
    init(searchProvider: RepositorySearchProvider,
         searchText: String,
         onCompletion: @escaping (Result<[Repository]>) -> ())
    {
        self.searchProvider = searchProvider
        self.searchText = searchText
        self.completionHandler = onCompletion
    }
    
    // MARK: - Overridden functions
    
    override func main() {
        guard !self.isCancelled else { return }
        
        self.searchProvider.request(self.searchText, onCompletion: self.completionHandler)
    }
}

class RepositoriesViewModel {
    
    // MARK: - Public properties
    
    var cellModels: [RepositoryCellModel] = []
    
    // MARK: - Private properties
    
    private var searchProvider: RepositorySearchProvider
    private var operationQueue: OperationQueue
    
    // MARK: - Initialization
    
    init(searchProvider: RepositorySearchProvider) {
        self.searchProvider = searchProvider
        self.operationQueue = OperationQueue()
    }
    
    // MARK: - Public functions
    
    func search(
        _ searchText: String,
        onStart: (TableViewChangeType) -> (),
        onCompletion: @escaping (TableViewChangeType) -> ())
    {
        let indexPaths = (0..<self.cellModels.count)
            .map { IndexPath(row: $0, section: 0) }
        
        self.cellModels.removeAll()
        onStart(.delete(indexPaths: indexPaths))
        
        let operationCompletion: (Result<[Repository]>) -> () = { [weak self] result in
            guard let `self` = self else { return }
            
            switch result {
            case .success(let repositories):
                let cellModels = repositories.map { RepositoryCellModel(repository: $0) }
                let startIndex = `self`.cellModels.count
                
                let indexPaths = (startIndex..<startIndex + cellModels.count)
                    .map { IndexPath(row: $0, section: 0) }
                
                `self`.cellModels.append(contentsOf: cellModels)
                
                DispatchQueue.main.async {
                    onCompletion(.insert(indexPaths: indexPaths))
                }
            case .failure(let error):
                break
            }
        }
        
        let firstOperation = SearchOperation(searchProvider: self.searchProvider,
                                             searchText: searchText,
                                             onCompletion: operationCompletion)
        
        let secondOperation = SearchOperation(searchProvider: self.searchProvider,
                                              searchText: searchText,
                                              onCompletion: operationCompletion)

        secondOperation.addDependency(firstOperation)
        
        let operationQueue = self.operationQueue
        
        operationQueue.addOperations([firstOperation, secondOperation], waitUntilFinished: false)
    }
    
    func cancelSearch() {
        self.operationQueue.cancelAllOperations()
    }
}
