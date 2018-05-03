//
//  RepositoryPresentationController.swift
//  GitHubSearch
//
//  Created by Gene on 5/4/18.
//  Copyright © 2018 YevhenTsyhanenko. All rights reserved.
//

import UIKit

class RepositoryPresentationController: UIPresentationController {
    
    // MARK: - Overridden properties
    
    override var frameOfPresentedViewInContainerView: CGRect {
        guard let containerView = self.containerView else { return .zero }
        let containerViewOrigin = containerView.frame.origin
        let containerViewBounds = containerView.bounds
        
        let presentedViewOrigin = CGPoint(x: containerViewOrigin.x + containerViewBounds.width * 0.1,
                                          y: containerViewOrigin.y + containerViewBounds.height * 0.1)
        
        let presentedViewSize = CGSize(width: containerViewBounds.width * 0.8,
                                       height: containerViewBounds.height * 0.8)
        
        return CGRect(origin: presentedViewOrigin, size: presentedViewSize)
    }
}
