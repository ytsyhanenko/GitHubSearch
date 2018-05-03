//
//  Repository.swift
//  GitHubSearch
//
//  Created by Genek on 4/30/18.
//  Copyright © 2018 Yevhen Tsyhanenko. All rights reserved.
//

import Foundation

struct Repository: Decodable {
    
    // MARK: - Public properties
    
    let name: String
    let url: URL
}
