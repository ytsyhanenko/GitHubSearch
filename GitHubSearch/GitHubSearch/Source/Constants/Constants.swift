//
//  Constants.swift
//  GitHubSearch
//
//  Created by Genek on 5/3/18.
//  Copyright © 2018 Yevhen Tsyhanenko. All rights reserved.
//

import Foundation

struct APIConstants {
    static let authToken = "b86464a317b510b7c6e3bffecb599c040ff4b876"
    static let url = "https://api.github.com/graphql"
    
    static let queryKey = "query"
    static let dataKey = "data"
    static let searchKey = "search"
    static let edgesKey = "edges"
    static let nodeKey = "node"
    
    static let authorizationHeader = "Authorization"
    
    static let defaultRepositorySearchLimit = 15
    
    static func repositorySearchQuery(searchText: String, searchLimit: Int) -> String {
        return """
            query {
                search(first: \(searchLimit), query: \(searchText), type: REPOSITORY) {
                    edges {
                        node {
                            ... on Repository {
                                name,
                                stargazers {
                                    totalCount
                                },
                                url
                            }
                        }
                    }
                }
            }
        """
    }
}
