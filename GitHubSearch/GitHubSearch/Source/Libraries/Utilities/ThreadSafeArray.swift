//
//  ThreadSafeArray.swift
//  GitHubSearch
//
//  Created by Genek on 5/6/18.
//  Copyright © 2018 Yevhen Tsyhanenko. All rights reserved.
//

import Foundation

class ThreadSafeArray<Element: Hashable> {
    
    // MARK: - Public properties
    
    var elements: [Element] {
        return queue.sync {
            _elements
        }
    }
    
    // MARK: - Private properties
    
    private var _elements: [Element]
    
    private let queue: DispatchQueue
    
    // MARK: - Initialization
    
    init() {
        self._elements = []
        self.queue = DispatchQueue(label: "ThreadSafeArrayQueue", attributes: .concurrent)
    }
    
    // MARK: - Public functions
    
    func append(_ element: Element) {
        self.queue.sync {
            self._elements.append(element)
        }
    }
    
    func append(_ elements: [Element]) {
        self.queue.sync(flags: .barrier) {
            self._elements.append(contentsOf: elements)
        }
    }
}
