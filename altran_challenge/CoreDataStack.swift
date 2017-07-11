//
//  CoreDataStack.swift
//  altran_challenge
//
//  Created by Dava on 7/7/17.
//
//

import Foundation
import CoreData

class CoreDataStack {
    
    private(set) var context: NSManagedObjectContext!
    
    static let shared: CoreDataStack = {
        let sharedCoreDataStack = CoreDataStack()
        return sharedCoreDataStack
    }()
    
    
    init() {
        
        // This resource is the same name as your xcdatamodeld contained in your project.
        guard let modelURL = Bundle.main.url(forResource: "Model", withExtension:"momd") else {
            fatalError("Error loading model from bundle")
        }
        
        
        // The managed object model for the application. It is a fatal error for the application not to be able to find and load its model.
        guard let managedObjectModel = NSManagedObjectModel(contentsOf: modelURL) else {
            fatalError("Error initializing mom from: \(modelURL)")
        }
        
        
        let persistentStoreCoordinator = NSPersistentStoreCoordinator(managedObjectModel: managedObjectModel)
        context = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        context.persistentStoreCoordinator = persistentStoreCoordinator
        
        DispatchQueue.global(qos: DispatchQoS.QoSClass.default).async {
            let urls = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
            
            let docURL = urls[urls.endIndex-1]

            let storeURL = docURL.appendingPathComponent("DataModel.sqlite")
            
            do {
                try persistentStoreCoordinator.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: storeURL, options: nil)
            }
                
            catch {
                fatalError("Error migrating store: \(error)")
            }
        }
    }
    
    func save() {
        if context.hasChanges {
            do {
                try context.save()
            } catch let error as NSError {
                print("Oops there was an error \(error.localizedDescription)")
                abort()
            }
        }
    }
    
}
