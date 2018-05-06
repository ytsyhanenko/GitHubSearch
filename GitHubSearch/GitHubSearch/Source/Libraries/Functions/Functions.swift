//
//  Functions.swift
//  IPFSiOSWrapper
//
//  Created by Genek on 3/7/18.
//  Copyright © 2018 GlobalLogic. All rights reserved.
//

import Foundation

func toString<T>(_ cls: T.Type) -> String {
    return String(describing: cls)
}

func synchronized<Object, Result>(_ object: Object, action: () -> (Result)) -> Result {
    objc_sync_enter(object)
    
    defer { objc_sync_exit(object) }
    
    return action()
}
