//
//  CoreDataProtocol.swift
//  altran_challenge
//
//  Created by Dava on 7/7/17.
//
//

import CoreData

// MARK: ManageObject Protocol
public protocol ManagedObjectType: class {
    
    static var entityName: String { get }
    static var defaultSortDescriptors: [NSSortDescriptor] { get }
    static var sortedFetchRequest: NSFetchRequest<NSFetchRequestResult> { get }
}


extension ManagedObjectType where Self: NSManagedObject {
    
    public static var entityName: String {
        return String(describing: Self.self)
    }
    
    public static var defaultSortDescriptors:[NSSortDescriptor] {
        return[]
    }
    
    public static var sortedFetchRequest: NSFetchRequest<NSFetchRequestResult> {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
        request.sortDescriptors = defaultSortDescriptors
        return request
    }
}

public typealias Predicate = [String : AnyObject]

// MARK: Methods Protocol
public protocol ManagedObjectMethods: class {
    
    associatedtype ModelObject
    
    /**
     Saves json to core data. Doesn't provide default implementation.
     
     - Parameter objects: key value pair to store.
     
     - Returns: generic type <Object: NSManagedObject>
     */
    static func save<Object>(object: Object?) -> ModelObject?
    
    /**
     Fetch all objects for the Entity type and returns them.
     
     - Returns: [Entity]? an optional array of Entity objects
     */
    static func fetchAll<Entity: NSManagedObject>() -> [Entity]?
    
    /**
     Fetch objects by identifier
     
     - Parameter value: to be fetched.
     - Parameter key: is the variable that should hold the value.
     
     - Returns: Entity? optional Entity objects
     */
    static func fetch<Entity: NSManagedObject>(uniqueValue value: String, forKey key: String) -> Entity?
}

//MARK: ManagedObjectMethods Default Implementation
extension ManagedObjectMethods where Self: ManagedObjectType {
    
    public static func fetchAll<Entity: NSManagedObject>() -> [Entity]? {
        
        let request = sortedFetchRequest
        
        guard let fetchedObjects = try? CoreDataStack.shared.context.fetch(request) as? [Entity], fetchedObjects!.count > 0 else {
            return nil
        }
 
        return  fetchedObjects
    }
    
    public static func fetch<Entity: NSManagedObject>(uniqueValue value: String, forKey key: String) -> Entity? {
        let cdStack = CoreDataStack.shared
        
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
        request.predicate = NSPredicate(format: "%K = %@", key, value)
        
        let fetchResult = (try? cdStack.context.fetch(request)) as? [Entity]
        
        if let results = fetchResult {
            if !results.isEmpty && results.count > 0 {
                return results[0]
            }
        }
        return nil
    }
}










