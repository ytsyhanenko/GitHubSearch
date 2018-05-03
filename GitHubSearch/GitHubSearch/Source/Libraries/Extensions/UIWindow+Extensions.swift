//
//  UIWindow+Extensions.swift
//  GitHubSearch
//
//  Created by Genek on 5/1/18.
//  Copyright © 2018 Yevhen Tsyhanenko. All rights reserved.
//

import Foundation
import UIKit

extension UIWindow {
    static func window(configure: (UIWindow) -> ()) -> UIWindow {
        let window = UIWindow(frame: UIScreen.main.bounds)
        
        configure(window)
        
        return window
    }
}
