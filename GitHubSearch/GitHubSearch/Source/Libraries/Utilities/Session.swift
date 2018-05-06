//
//  Session.swift
//  GitHubSearch
//
//  Created by Genek on 5/6/18.
//  Copyright © 2018 Yevhen Tsyhanenko. All rights reserved.
//

import Foundation

enum HTTPMethod: String {
    case head = "HEAD"
    case get = "GET"
    case post = "POST"
    case patch = "PATCH"
    case put = "PUT"
    case delete = "DELETE"
}

protocol SessionRequestHeadersProtocol {
    var headers: [String : String] { get }
}

protocol SessionRequestParametersProtocol {
    var parameters: [String : String] { get }
}

extension SessionRequestHeadersProtocol where Self: Session {
    var headers: [String : String] {
        return [API.Keys.authorization : "\(API.Keys.token) \(API.authorizationToken.decrypted())"]
    }
}

protocol SessionURL {
    var url: String { get }
    var host: String { get }
    var urlPath: String { get }
}

extension SessionURL {
    var url: String {
        return self.host + self.urlPath
    }
}

class Session: SessionURL {
    
    // MARK: - SessionURL
    
    var host: String = API.URL.host
    var urlPath: String { return "" }
    
    // MARK: - Public properties
    
    var httpMethod: HTTPMethod
    var validStatusCodes: [Int] = []
    
    // MARK: - Initialization
    
    init(httpMethod: HTTPMethod, validStatusCodes: [Int], host: String = API.URL.host) {
        self.httpMethod = httpMethod
        self.validStatusCodes = validStatusCodes
        self.host = host
    }
}
