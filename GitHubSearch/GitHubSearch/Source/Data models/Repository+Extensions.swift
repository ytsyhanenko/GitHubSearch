//
//  Repository.swift
//  GitHubSearch
//
//  Created by Genek on 4/30/18.
//  Copyright © 2018 Yevhen Tsyhanenko. All rights reserved.
//

import Foundation
import CoreData

extension Repository {
    static func addRepository(
        name: String?,
        url: URL?,
        stars: Int,
        context: NSManagedObjectContext)
        -> Repository?
    {
        guard let entityDescription = NSEntityDescription.entity(forEntityName: toString(Repository.self), in: context) else { return nil
        }
        
        let object = Repository(entity: entityDescription, insertInto: context)
        object.name = name
        object.url = url
        object.stars = stars
        
        return object
    }
    
    var stars: Int {
        get {
            return self.starsCount?.intValue ?? 0
        }
        set {
            self.starsCount = NSNumber(value: newValue)
        }
    }
}
