//
//  NSManagedObject+Extensions.swift
//  GitHubSearch
//
//  Created by Genek on 5/5/18.
//  Copyright © 2018 Yevhen Tsyhanenko. All rights reserved.
//

import Foundation
import CoreData

extension NSManagedObject {
    static func deleteAll(inContext context: NSManagedObjectContext) {
        self.allObjects(inContext: context)
            .forEach {
                context.delete($0)
        }
    }
    
    static func allObjects(
        inContext context: NSManagedObjectContext,
        sortBy key: String? = nil,
        ascending: Bool = true)
        -> [NSManagedObject]
    {
        let request = self.fetchRequest()
        
        key.map { NSSortDescriptor(key: $0, ascending: ascending) }
            .map { request.sortDescriptors = [$0] }
        
        let objects = try? context.fetch(request)
        
        return objects as? [NSManagedObject] ?? []
    }
}
