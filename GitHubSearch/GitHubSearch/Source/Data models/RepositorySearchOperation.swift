//
//  SearchOperation.swift
//  GitHubSearch
//
//  Created by Genek on 5/5/18.
//  Copyright © 2018 Yevhen Tsyhanenko. All rights reserved.
//

import Foundation

class RepositorySearchOperation: AsynchronousOperation {
    
    // MARK: - Private properties
    
    private var searchProvider: RepositorySearchProvider
    private var searchText: String
    private var page: Page
    private var sorting: RepositorySortingType
    private var order: RepositoryOrderType
    private var completionHandler: (Result<[Repository]>) -> () = { _ in }
    
    // MARK: - Initialization
    
    init(searchText: String,
         page: Page,
         searchProvider: RepositorySearchProvider,
         sortBy: RepositorySortingType,
         orderBy: RepositoryOrderType,
         completion: @escaping (Result<[Repository]>) -> ())
    {
        self.searchText = searchText
        self.page = page
        self.searchProvider = searchProvider
        self.sorting = sortBy
        self.order = orderBy
        self.completionHandler = completion
    }
    
    // MARK: - Overridden functions
    
    override func execute() {
        self.searchProvider.search(
            self.searchText,
            page: self.page,
            sortBy: self.sorting,
            orderBy: self.order,
            onCompletion: {
                self.completionHandler($0)
                self.finish()
            })
    }
    
    override func cancel() {
        self.searchProvider.cancelSearch()
    }
}
