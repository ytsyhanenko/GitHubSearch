//
//  RepositoryViewModel.swift
//  GitHubSearch
//
//  Created by Genek on 5/3/18.
//  Copyright © 2018 Yevhen Tsyhanenko. All rights reserved.
//

import Foundation

class RepositoryViewModel {
    
    // MARK: - Public properties
    
    let repository: Repository
    
    let repositoryName: String
    let repositoryURL: String
    
    // MARK: - Initialization
    
    init(repository: Repository) {
        self.repository = repository
        self.repositoryName = repository.name
        self.repositoryURL = repository.url.absoluteString
    }
}
