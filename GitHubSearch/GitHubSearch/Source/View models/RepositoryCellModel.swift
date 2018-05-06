//
//  RepositoryCellModel.swift
//  GitHubSearch
//
//  Created by Genek on 4/30/18.
//  Copyright © 2018 Yevhen Tsyhanenko. All rights reserved.
//

import Foundation

struct RepositoryCellModel {
    
    // MARK: - Public properties
    
    let repository: Repository
    
    let repositoryName: String?
    let repositoryURL: String?
    let stars: String
    
    // MARK: - Initialization
    
    init(repository: Repository) {
        self.repository = repository
        self.repositoryName = repository.name
        self.repositoryURL = repository.url?.absoluteString
        self.stars = "\(repository.stars)"
    }
}
