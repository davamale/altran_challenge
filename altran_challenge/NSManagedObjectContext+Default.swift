//
//  NSManagedObjectContext+Default.swift
//  altran_challenge
//
//  Created by Dava on 7/9/17.
//
//

import UIKit
import CoreData

extension NSManagedObjectContext {
    public func insertObject<Entity: NSManagedObject> () -> Entity where Entity: ManagedObjectType {
        
        // If running on test
        let environment = ProcessInfo.processInfo.environment as [String : AnyObject]
        let isTestTarget = (environment["XCTestConfigurationFilePath"] as? String) != nil
        
        if isTestTarget {
            guard let entity = NSEntityDescription.entity(forEntityName: Entity.entityName, in: self) else {
                fatalError("Wrong Object")
            }
            
            let obj: Entity = Entity(entity: entity, insertInto: self)
            
            return obj
        }
        
        guard let obj = NSEntityDescription.insertNewObject(forEntityName: Entity.entityName, into: self) as? Entity else {
            fatalError("Wrong Object")
        }
        
        return obj
    }
//    
//    public func entityObject<Entity: NSManagedObject>() -> Entity where  Entity: ManagedObjectType {
//        guard let obj = NSEntityDescription.entity(forEntityName: Entity.entityName, in: self) as? Entity else {
//            fatalError("Wrong Object")
//        }
//        return obj
//    }
    
}
