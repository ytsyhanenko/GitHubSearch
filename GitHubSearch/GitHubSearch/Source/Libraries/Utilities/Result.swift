//
//  Result.swift
//  GitHubSearch
//
//  Created by Genek on 5/5/18.
//  Copyright © 2018 Yevhen Tsyhanenko. All rights reserved.
//

import Foundation

enum Result<T> {
    case success(T)
    case failure(Error)
}
