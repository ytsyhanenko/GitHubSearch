//
//  PersistentStoreProvider.swift
//  GitHubSearch
//
//  Created by Genek on 5/4/18.
//  Copyright © 2018 Yevhen Tsyhanenko. All rights reserved.
//

import Foundation
import CoreData

class PersistentStoreProvider {
    
    // MARK: - Public properties
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "GitHubSearch")
        container.loadPersistentStores { _, _ in }
        container.viewContext.automaticallyMergesChangesFromParent = true
        
        return container
    }()
    
    var mainContext: NSManagedObjectContext {
        return self.persistentContainer.viewContext
    }
    
    lazy var backgroundContext: NSManagedObjectContext = {
        return self.persistentContainer.newBackgroundContext()
    }()
    
    // MARK: - Public functions
    
    func fetchedResultsController<Entity: NSManagedObject>(
        forEntity entity: Entity.Type,
        sortBy key: String,
        ascending: Bool = false)
        -> NSFetchedResultsController<Entity>
    {
        let fetchRequest = NSFetchRequest<Entity>(entityName: toString(entity))
        let sortDescriptor = NSSortDescriptor(key: key, ascending: ascending)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        return NSFetchedResultsController<Entity>(fetchRequest: fetchRequest, managedObjectContext: self.mainContext, sectionNameKeyPath: nil, cacheName: nil)
    }
    
    func deleteAll<T: NSManagedObject>(entity: T.Type) {
        self.save { context in
            entity.deleteAll(inContext: context)
        }
    }
    
    func save(block: @escaping (NSManagedObjectContext) -> ()) {
        let context = self.mainContext
        
        context.perform {
            block(context)
            
            try? context.save()
        }
    }
    
    func saveMainContext() {
        self.save(context: self.mainContext)
    }
    
    func saveBackgroundContext() {
        self.save(context: self.backgroundContext)
    }
    
    // MARK: - Private functions
    
    private func save(context: NSManagedObjectContext) {
        try? context.save()
    }
}
