//
//  RepositoriesSession.swift
//  GitHubSearch
//
//  Created by Genek on 4/30/18.
//  Copyright © 2018 Yevhen Tsyhanenko. All rights reserved.
//

import Foundation

enum SessionError: Error {
    case unspecified
}

enum Result<T> {
    case success(T)
    case failure(Error)
}

enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
    case patch = "PATCH"
    case delete = "DELETE"
}

class APISession {
    
    // MARK: - Public properties
    
    var url: URL?
    var httpMethod: HTTPMethod
    
    // MARK: - Initialization
    
    init(url: String, httpMethod: HTTPMethod) {
        self.url = URL(string: url)
        self.httpMethod = httpMethod
    }
}

class GraphQLSession: APISession {
    
    // MARK: - Public properties
    
    var query: String
    
    // MARK: - Initialization
    
    init(query: String, url: String, httpMethod: HTTPMethod) {
        self.query = query
        
        super.init(url: url, httpMethod: httpMethod)
    }
}

class GitHubAPISession: GraphQLSession {
    
    // MARK: - Public properties
    
    let token = APIConstants.authToken
}

class RepositorySearchSession: GitHubAPISession {
    
    // MARK: - Initialization
    
    init(searchText: String, searchLimit: Int) {
        super.init(query: APIConstants.repositorySearchQuery(searchText: searchText, searchLimit: searchLimit),
                   url: APIConstants.url,
                   httpMethod: .post)
    }
    
    // MARK: - Public functions
    
    func request(onCompletion: @escaping (Result<Data>) -> ()) {
        guard let url = self.url else {
            onCompletion(.failure(SessionError.unspecified))
            
            return
        }
        
        var request = URLRequest(url: url)
        let body = [APIConstants.queryKey : self.query]
        
        request.httpMethod = self.httpMethod.rawValue
        request.addValue("bearer \(self.token)", forHTTPHeaderField: APIConstants.authorizationHeader)
        request.httpBody = try? JSONSerialization.data(withJSONObject: body, options: [])
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard error == nil else {
                onCompletion(.failure(error!))
                
                return
            }
            
            guard let data = data else {
                onCompletion(.failure(SessionError.unspecified))
                
                return
            }
            
            onCompletion(.success(data))
        }
        
        task.resume()
    }
}
