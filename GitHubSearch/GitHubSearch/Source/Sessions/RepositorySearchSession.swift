//
//  Session.swift
//  GitHubSearch
//
//  Created by Genek on 5/6/18.
//  Copyright © 2018 Yevhen Tsyhanenko. All rights reserved.
//

import Foundation

enum RepositorySortingType: String {
    case stars = "stars"
    case forks = "forks"
    case updated = "updated"
}

enum RepositoryOrderType: String {
    case ascending = "asc"
    case descending = "desc"
}

extension RepositorySearchSession: SessionRequestParametersProtocol {
    var parameters: [String : String] {
        let page = self.page
        
        return [API.Keys.searchQuery    :   self.searchText,
                API.Keys.page           :   "\(page.index)",
                API.Keys.perPage        :   "\(page.perPage)",
                API.Keys.order          :   self.order.rawValue,
                API.Keys.sort           :   self.sorting.rawValue]
    }
}

class RepositorySearchSession: Session, SessionRequestHeadersProtocol {
    
    // MARK: - Defaults
    
    private struct Defaults {
        static let urlPath = API.URL.searchRepositoriesPath
    }
    
    // MARK: - SessionURL
    
    override var urlPath: String {
        return Defaults.urlPath
    }
    
    // MARK: - Private properties
    
    fileprivate var searchText: String
    fileprivate var page: Page
    fileprivate var sorting: RepositorySortingType
    fileprivate var order: RepositoryOrderType
    private var task: URLSessionDataTask?
    
    // MARK: - Initialization
    
    init(searchText: String, page: Page, sortBy: RepositorySortingType, orderBy: RepositoryOrderType) {
        self.searchText = searchText
        self.page = page
        self.sorting = sortBy
        self.order = orderBy
        
        super.init(httpMethod: .get, validStatusCodes: [200])
    }
    
    // MARK: - Public functions
    
    func request(onCompletion: @escaping (Result<Data>) -> ()) {
        guard let request = self.urlRequest() else {
            onCompletion(.failure(GSError.unspecified))
            
            return
        }
        
        self.task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard error == nil else {
                onCompletion(.failure(error!))
                
                return
            }
            
            guard let data = data,
                let response = response as? HTTPURLResponse,
                self.validStatusCodes.contains(response.statusCode) else {
                    onCompletion(.failure(GSError.unspecified))
                
                    return
                }
            
            onCompletion(.success(data))
        }
        
        self.task?.resume()
    }
    
    func cancel() {
        self.task?.cancel()
    }
    
    // MARK: - Private functions
    
    private func urlRequest() -> URLRequest? {
        guard var urlComponents = URLComponents(string: self.url) else { return nil }
        
        urlComponents.queryItems = self.parameters
            .map { URLQueryItem(name: $0.key, value: $0.value) }
        
        var request = urlComponents.url.flatMap { URLRequest(url: $0) }
        
        self.headers.forEach { request?.setValue($0.value, forHTTPHeaderField: $0.key) }
        
        return request
    }
}
