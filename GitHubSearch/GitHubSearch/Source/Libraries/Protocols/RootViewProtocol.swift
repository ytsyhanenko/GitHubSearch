//
//  RootViewProtocol.swift
//  List
//
//  Created by Genek on 2/22/17.
//  Copyright © 2017 Genek. All rights reserved.
//

import UIKit

extension RootViewProtocol where Self: UIViewController {
    var rootView: ViewType? {
        return self.viewIfLoaded as? ViewType
    }
}

protocol RootViewProtocol: class {
    associatedtype ViewType: UIView
    
    var rootView: ViewType? { get }
}
