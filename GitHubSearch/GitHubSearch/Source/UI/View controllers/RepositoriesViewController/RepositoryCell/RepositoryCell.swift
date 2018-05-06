//
//  RepositoryCell.swift
//  GitHubSearch
//
//  Created by Genek on 4/30/18.
//  Copyright © 2018 Yevhen Tsyhanenko. All rights reserved.
//

import UIKit

class RepositoryCell: UITableViewCell {
    
    // MARK: - IBOutlet
    
    @IBOutlet var nameLabel: UILabel?
    @IBOutlet var urlLabel: UILabel?
    @IBOutlet var starsLabel: UILabel?
    
    // MARK: - Public functions
    
    func fill(with cellModel: RepositoryCellModel) {
        self.nameLabel?.text = cellModel.repositoryName
        self.urlLabel?.text = cellModel.repositoryURL
        self.starsLabel?.text = cellModel.stars
    }
}
