//
//  UINib+Extensions.swift
//  IPFSiOSWrapper
//
//  Created by Genek on 3/14/18.
//  Copyright © 2018 GlobalLogic. All rights reserved.
//

import Foundation
import UIKit

extension UINib {
    static func object<T: UIView>(
        ofClass cls: T.Type,
        fromBundle bundle: Bundle = .main,
        withOwner owner: Any? = nil,
        options: [AnyHashable : Any]? = nil) -> T?
    {
        return UINib
            .nib(forClass: cls, inBundle: bundle)
            .objects(withOwner: owner, options: options)
            .object(ofClass: cls)
    }
    
    static func nib<T: UIView>(forClass cls: T.Type, inBundle bundle: Bundle = .main) -> UINib {
        return UINib(nibName: toString(cls), bundle: bundle)
    }
    
    func objects(withOwner owner: Any? = nil, options: [AnyHashable : Any]? = nil) -> [Any] {
        return self.instantiate(withOwner: owner, options: options)
    }
}
