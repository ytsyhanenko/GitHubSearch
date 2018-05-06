//
//  Constants.swift
//  GitHubSearch
//
//  Created by Genek on 5/3/18.
//  Copyright © 2018 Yevhen Tsyhanenko. All rights reserved.
//

import Foundation

struct API {
    struct URL {
        static let host = "https://api.github.com/"
        static let searchRepositoriesPath = "search/repositories"
    }
    
    struct Keys {
        static let searchQuery = "q"
        static let order = "order"
        static let sort = "sort"
        static let stars = "stars"
        static let page = "page"
        static let perPage = "per_page"
        static let authorization = "Authorization"
        static let token = "token"
        static let items = "items"
        static let url = "html_url"
        static let starsCount = "stargazers_count"
        static let name = "name"
    }
    
    // Token is encrypted, decrypt for use
    static let authorizationToken = "4d3793h5i7i5dg<568399ff796:d7f85<7;d444i"
}

struct Constants {
    static let search = "Search"
    static let repositoriesPerPage = 15
    static let repositoriesPageCount = 2
    static let searchResultMaxLength = 30
    static let starsCountKey = "starsCount"
}
