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
    
    /// Context in main queue
    private(set) lazy var context: NSManagedObjectContext = {
        let moc = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        moc.persistentStoreCoordinator = self.persistentStoreCoordinator
        return moc
    }()
    
    private lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator = {
        return NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
    }()
    
    /// Context in private context
    lazy var privateContext: NSManagedObjectContext =  {
        let privateMOC = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
        
        return privateMOC
    }()
    
    // The managed object model for the application. It is a fatal error for the application not to be able to find and load its model.
    private lazy var managedObjectModel: NSManagedObjectModel = {
        return NSManagedObjectModel(contentsOf: self.modelURL!)!
    }()
    
    // This resource is the same name as your xcdatamodeld contained in your project.
    let modelURL = Bundle.main.url(forResource: "Model", withExtension:"momd")
    
    static let shared: CoreDataStack = {
        let sharedCoreDataStack = CoreDataStack()
        return sharedCoreDataStack
    }()
    
    init() {
        
        NotificationCenter.default.addObserver(self, selector: #selector(contextDidSave(notification:)), name: NSNotification.Name.NSManagedObjectContextDidSave, object: nil)
        
        privateContext.parent = self.context
        
        DispatchQueue.global(qos: DispatchQoS.QoSClass.default).async {
            let urls = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
            
            let docURL = urls[urls.endIndex-1]

            let storeURL = docURL.appendingPathComponent("DataModel.sqlite")
            
            do {
                try self.persistentStoreCoordinator.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: storeURL, options: nil)
            }
                
            catch {
                fatalError("Error migrating store: \(error)")
            }
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    func save() {
        if privateContext.hasChanges {
            
            do {
                try privateContext.save()
            } catch let error as NSError {
                print("Oops there was an error \(error.localizedDescription)")
                abort()
            }
        }
    }
    
    @objc fileprivate func contextDidSave(notification: Notification) {
        if let sender = notification.object as? NSManagedObjectContext, sender != context {
            context.mergeChanges(fromContextDidSave: notification)
            if context.hasChanges {
                do {
                    try context.save()
                } catch let error as NSError {
                    print("\(error.localizedDescription)")
                    abort()
                }
            }
        }
    }
    
}







