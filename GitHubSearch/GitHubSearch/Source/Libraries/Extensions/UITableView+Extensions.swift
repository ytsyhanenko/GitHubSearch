//
//  UITableView+Extensions.swift
//  IPFSiOSWrapper
//
//  Created by Genek on 3/14/18.
//  Copyright © 2018 GlobalLogic. All rights reserved.
//

import Foundation
import UIKit

enum TableViewChangeType {
    case delete(indexPaths: [IndexPath])
    case insert(indexPaths: [IndexPath])
    case update(indexPaths: [IndexPath])
}

extension UITableView {
    func register<T: UITableViewCell>(cellClass cls: T.Type) {
        let cellNib = UINib.nib(forClass: cls)
        let reuseIdentifier = toString(cls)
        
        self.register(cellNib, forCellReuseIdentifier: reuseIdentifier)
    }
    
    // unless identifier is registered the application will crash with NSInternalInconsistencyException
    func reusableCell<T: UITableViewCell>(
        ofClass cls: T.Type,
        for indexPath: IndexPath,
        configure: ((T) -> ())? = nil) -> T
    {
        let reuseIdentifier = toString(cls)
        guard let cell = self.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as? T else {
            fatalError("Failed to dequeue cell with reuseIdentifier \"\(reuseIdentifier)\"")
        }
        
        configure?(cell)
        
        return cell
    }
    
    func applyChange(_ changeType: TableViewChangeType, with animation: UITableViewRowAnimation = .automatic) {
        func performUpdate(changeType: TableViewChangeType, animation: UITableViewRowAnimation) {
            switch changeType {
            case .delete(let indexPaths):
                self.deleteRows(at: indexPaths, with: animation)
            case .insert(let indexPaths):
                self.insertRows(at: indexPaths, with: animation)
            case .update(let indexPaths):
                self.reloadRows(at: indexPaths, with: animation)
            }
        }
        
        let update = { performUpdate(changeType: changeType, animation: animation) }
        
        self.performBatchUpdates(update, completion: nil)
    }
}
