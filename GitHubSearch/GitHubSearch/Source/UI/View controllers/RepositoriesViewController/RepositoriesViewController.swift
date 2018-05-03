//
//  RepositoriesViewController.swift
//  GitHubSearch
//
//  Created by Genek on 4/30/18.
//  Copyright © 2018 Yevhen Tsyhanenko. All rights reserved.
//

import UIKit

extension RepositoriesViewController: UISearchBarDelegate {
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        self.rootView?.searchBar?.setShowsCancelButton(true, animated: true)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let searchText = searchBar.text else { return }
        let tableView = self.rootView?.tableView
        
        self.viewModel.performSearch(
            searchText,
            onStart: { changeType in
                tableView?.applyChange(changeType)
            },
            onCompletion: { [weak tableView] changeType in
                tableView?.applyChange(changeType)
            })
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.setShowsCancelButton(false, animated: true)
        searchBar.endEditing(true)
    }
}

extension RepositoriesViewController: UIViewControllerTransitioningDelegate {
    func presentationController(
        forPresented presented: UIViewController,
        presenting: UIViewController?,
        source: UIViewController) -> UIPresentationController?
    {
        return RepositoryPresentationController(presentedViewController: presented, presenting: presenting)
    }
}

extension RepositoriesViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewModel.cellModels.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return tableView.reusableCell(ofClass: RepositoryCell.self, for: indexPath) { cell in
            cell.fill(with: self.viewModel.cellModels[indexPath.row])
        }
    }
}

extension RepositoriesViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.showRepository(forCellAt: indexPath) { [weak tableView] in
            tableView?.deselectRow(at: indexPath, animated: true)
        }
    }
}

class RepositoriesViewController: UIViewController, RootViewProtocol {
    
    // MARK: - RootViewProtocol
    
    typealias ViewType = RepositoriesView
    
    // MARK: - Private properties
    
    fileprivate var viewModel: RepositoriesViewModel
    
    // MARK: - Initialization

    init(viewModel: RepositoriesViewModel) {
        self.viewModel = viewModel
        
        super.init(nibName: toString(type(of: self)), bundle: .main)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - View lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.setupNavigationBar()
        self.setupTableView()
    }
    
    // MARK: - Private functions
    
    private func setupNavigationBar() {
        self.title = "Search"
        self.navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    private func setupTableView() {
        let tableView = self.rootView?.tableView
        
        tableView?.register(cellClass: RepositoryCell.self)
    }
    
    fileprivate func showRepository(forCellAt indexPath: IndexPath, onCompletion: (() -> ())? = nil) {
        let cellModel = self.viewModel.cellModels[indexPath.row]
        let viewModel = RepositoryViewModel(repository: cellModel.repository)
        let repositoryViewController = RepositoryViewController(viewModel: viewModel)
        
        repositoryViewController.modalPresentationStyle = .custom
        repositoryViewController.transitioningDelegate = self
        
        self.present(repositoryViewController, animated: true, completion: onCompletion)
    }
}
