//
//  RepositoryViewController.swift
//  GitHubSearch
//
//  Created by Genek on 5/1/18.
//  Copyright © 2018 Yevhen Tsyhanenko. All rights reserved.
//

import UIKit

class RepositoryViewController: UIViewController, RootViewProtocol {
    
    // MARK: - RootViewProtocol
    
    typealias ViewType = RepositoryView
    
    // MARK: - IBAction
    
    @IBAction func onClose(_ sender: UIButton) {
        self.dismiss(animated: true)
    }
    
    // MARK: - Private properties
    
    private var viewModel: RepositoryViewModel
    
    // MARK: - Initialization
    
    init(viewModel: RepositoryViewModel) {
        self.viewModel = viewModel
        
        super.init(nibName: toString(type(of: self)), bundle: .main)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - View lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.loadPage()
    }
    
    // MARK: - Private functions
    
    private func loadPage() {
        _ = URL(string: self.viewModel.repositoryURL)
            .map { URLRequest(url: $0) }
            .map { self.rootView?.webView?.load($0) }
    }
}
