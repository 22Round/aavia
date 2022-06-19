//
//  CoreDataStack.swift
//  ExpenseTracker
//
//  Created by Alfian Losari on 19/04/20.
//  Copyright © 2020 Alfian Losari. All rights reserved.
//

import CoreData

class CoreDataStack {
    
    static let shared: CoreDataStack = .init(containerName: "ExpenseTracker")
    
    private let containerName: String
    var viewContext: NSManagedObjectContext { persistentContainer.viewContext }
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: containerName)
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                print(error.localizedDescription)
            }
            print(storeDescription)
        })
        return container
    }()
    
    init(containerName: String) {
        self.containerName = containerName
        _ = persistentContainer
    }
}

extension NSManagedObjectContext {
    
    func saveContext(complation: ((Bool) -> Void)? = nil) throws {
        guard hasChanges else {
            complation?(false)
            return
        }
        do {
            try save()
            complation?(true)
        } catch let error {
            print("Error: \(error)")
            complation?(false)
        }
    }
}
