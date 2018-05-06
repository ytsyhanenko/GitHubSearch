//
//  UIAlertController+Extensions.swift
//  GitHubSearch
//
//  Created by Genek on 5/6/18.
//  Copyright © 2018 Yevhen Tsyhanenko. All rights reserved.
//

import Foundation
import UIKit

extension UIAlertController {
    static func alert(
        style: UIAlertControllerStyle = .alert,
        title: String? = nil,
        message: String? = nil,
        actionTitle: String? = "OK",
        actionHandler: ((UIAlertAction) -> ())? = nil,
        onCompletion completionHandler: (() -> ())? = nil)
        -> UIAlertController
    {
        let alert = UIAlertController(title: title, message: message, preferredStyle: style)
        let action = UIAlertAction(title: actionTitle, style: .default, handler: actionHandler)
            
        alert.addAction(action)
        
        return alert
    }
}
