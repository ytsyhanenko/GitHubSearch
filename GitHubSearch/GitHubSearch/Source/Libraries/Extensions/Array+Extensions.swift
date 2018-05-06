//
//  Array+Extensions.swift
//  IPFSiOSWrapper
//
//  Created by Genek on 3/14/18.
//  Copyright © 2018 GlobalLogic. All rights reserved.
//

import Foundation

extension Array {
    func object<T>(ofClass cls: T.Type) -> T? {
        return self
            .filter { $0 is T }
            .first
            .flatMap { $0 as? T }
    }
    
    static func array<T>(withCount count: Int, factoryBlock block: () -> (T)) -> [T] {
        var result: [T] = []

        for _ in 0..<count {
            result.append(block())
        }

        return result
    }
}
