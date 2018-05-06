//
//  RepositoriesViewController.swift
//  GitHubSearch
//
//  Created by Genek on 4/30/18.
//  Copyright © 2018 Yevhen Tsyhanenko. All rights reserved.
//

import UIKit
import CoreData

extension RepositoriesViewController: NSFetchedResultsControllerDelegate {
    func controller(
        _ controller: NSFetchedResultsController<NSFetchRequestResult>,
        didChange anObject: Any,
        at indexPath: IndexPath?,
        for type: NSFetchedResultsChangeType,
        newIndexPath: IndexPath?)
    {
            let tableView = self.rootView?.tableView
            
            switch type {
            case .insert:
                newIndexPath.map { tableView?.insertRows(at: [$0], with: .fade) }
            case .delete:
                indexPath.map { tableView?.deleteRows(at: [$0], with: .fade) }
            case .move:
                guard let sourceIndexPath = indexPath,
                    let destinationIndexPath = newIndexPath else { return }
                
                tableView?.moveRow(at: sourceIndexPath, to: destinationIndexPath)
            case .update:
                guard let indexPath = indexPath,
                    let cell = tableView?.cellForRow(at: indexPath) as? RepositoryCell else { return }
                
                self.configureCell(cell, at: indexPath)
            }
    }

    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        self.rootView?.tableView?.beginUpdates()
    }

    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        self.rootView?.tableView?.endUpdates()
    }
}

extension RepositoriesViewController: UISearchBarDelegate {
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        self.rootView?.searchBar?.setShowsCancelButton(true, animated: true)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let searchText = searchBar.text else { return }
        
        self.viewModel.search(searchText) { [weak self] result in
            switch result {
            case .failure(let error):
                let alert = UIAlertController.alert(message: error.localizedDescription)

                self?.present(alert, animated: true)
            case .success:
                break
            }
        }
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.viewModel.cancelSearch()
        
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
        return self.fetchedResultsController.sections?[section].numberOfObjects ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return tableView.reusableCell(ofClass: RepositoryCell.self, for: indexPath) { cell in
            self.configureCell(cell, at: indexPath)
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
    fileprivate var fetchedResultsController: NSFetchedResultsController<Repository>
    
    // MARK: - Initialization

    init(viewModel: RepositoriesViewModel) {
        let fetchedResultsController = viewModel.fetchedResultsController()
        
        self.viewModel = viewModel
        self.fetchedResultsController = fetchedResultsController
        
        super.init(nibName: toString(type(of: self)), bundle: .main)
        
        fetchedResultsController.delegate = self
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - View lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.setupNavigationBar()
        self.setupTableView()
        
        try? self.fetchedResultsController.performFetch()
    }
    
    // MARK: - Private functions
    
    private func setupNavigationBar() {
        self.title = Constants.search
        self.navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    private func setupTableView() {
        let tableView = self.rootView?.tableView
        
        tableView?.register(cellClass: RepositoryCell.self)
    }
    
    fileprivate func configureCell(_ cell: RepositoryCell, at indexPath: IndexPath) {
        let model = self.fetchedResultsController.object(at: indexPath)
        let cellModel = RepositoryCellModel(repository: model)
        
        cell.fill(with: cellModel)
    }
    
    fileprivate func showRepository(forCellAt indexPath: IndexPath, onCompletion: (() -> ())? = nil) {
        let repository = self.fetchedResultsController.object(at: indexPath)
        let viewModel = RepositoryViewModel(repository: repository)
        let repositoryViewController = RepositoryViewController(viewModel: viewModel)
        
        repositoryViewController.modalPresentationStyle = .custom
        repositoryViewController.transitioningDelegate = self
        
        self.present(repositoryViewController, animated: true, completion: onCompletion)
    }
}
