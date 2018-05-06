//
//  Operation+Extensions.swift
//  GitHubSearch
//
//  Created by Genek on 5/6/18.
//  Copyright © 2018 Yevhen Tsyhanenko. All rights reserved.
//

import Foundation

extension Operation {
    func addDependencies(_ operations: [Operation]) {
        operations.forEach { self.addDependency($0) }
    }
}
