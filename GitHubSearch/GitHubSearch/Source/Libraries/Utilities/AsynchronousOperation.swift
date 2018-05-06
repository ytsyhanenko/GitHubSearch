//
//  AsynchronousOperation.swift
//  GitHubSearch
//
//  Created by Genek on 5/6/18.
//  Copyright © 2018 Yevhen Tsyhanenko. All rights reserved.
//

import Foundation

@objc enum AsynchronousOperationState: Int {
    case ready
    case executing
    case finished
}

class AsynchronousOperation: Operation {
    
    // MARK: - Constants
    
    private struct Keys {
        static let state = "state"
    }
    
    // MARK: - Private properties
    
    private let stateQueue = DispatchQueue(label: "ThreadSafeStateQueue", attributes: .concurrent)
    
    private var state: AsynchronousOperationState {
        get {
            return self.stateQueue.sync { self._state }
        }
        set {
            willChangeValue(forKey: Keys.state)
            
            self.stateQueue.sync(flags: .barrier) {
                _state = newValue
            }
            
            didChangeValue(forKey: Keys.state)
        }
    }
    
    @objc private dynamic var _state: AsynchronousOperationState = .ready
    
    @objc private dynamic class func keyPathsForValuesAffectingIsReady() -> Set<String> {
        return [Keys.state]
    }
    
    @objc private dynamic class func keyPathsForValuesAffectingIsExecuting() -> Set<String> {
        return [Keys.state]
    }
    
    @objc private dynamic class func keyPathsForValuesAffectingIsFinished() -> Set<String> {
        return [Keys.state]
    }
    
    // MARK: - Overridden properties
    
    override var isAsynchronous: Bool {
        return true
    }
    
    override var isReady: Bool {
        return self.state == .ready && super.isReady
    }
    
    override var isExecuting: Bool {
        return self.state == .executing
    }
    
    override var isFinished: Bool {
        return self.state == .finished
    }
    
    // MARK: - Overridden functions
    
    override func start() {
        super.start()
        
        if self.isCancelled {
            self.finish()
            
            return
        }
        
        self.state = .executing
        self.execute()
    }
    
    // MARK: - Public functions
    
    func finish() {
        if self.isExecuting {
            self.state = .finished
        }
    }
    
    func execute() {
        
    }
}
