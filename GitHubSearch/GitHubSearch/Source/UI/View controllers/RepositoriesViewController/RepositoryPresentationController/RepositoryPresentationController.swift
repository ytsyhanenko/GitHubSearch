//
//  RepositoryPresentationController.swift
//  GitHubSearch
//
//  Created by Genek on 5/4/18.
//  Copyright © 2018 Yevhen Tsyhanenko. All rights reserved.
//

import UIKit

class RepositoryPresentationController: UIPresentationController {
    
    // MARK: - Overridden properties
    
    override var frameOfPresentedViewInContainerView: CGRect {
        guard let containerView = self.containerView else { return .zero }
        let containerViewOrigin = containerView.frame.origin
        let containerViewBounds = containerView.bounds
        
        let frameRatio: CGFloat = 0.8
        let edgeIndentRatio = (1 - frameRatio) / 2
        
        let presentedViewOrigin = CGPoint(x: containerViewOrigin.x + containerViewBounds.width * edgeIndentRatio,
                                          y: containerViewOrigin.y + containerViewBounds.height * edgeIndentRatio)
        
        let presentedViewSize = CGSize(width: containerViewBounds.width * frameRatio,
                                       height: containerViewBounds.height * frameRatio)
        
        return CGRect(origin: presentedViewOrigin, size: presentedViewSize)
    }
}
