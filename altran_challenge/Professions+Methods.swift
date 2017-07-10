//
//  Professions+Methods.swift
//  altran_challenge
//
//  Created by Dava on 7/9/17.
//
//

import Foundation

//MARK: - ManagedObjectType
extension Profession: ManagedObjectType {}

//MARK: - ManagedObjectMethods
extension Profession: ManagedObjectMethods {
    
    public typealias ModelObject = Profession
    
    public static func save(object: NSDictionary?) -> Profession? {
        
        //TODO: Does this manages an array or a single object?
        
        // required to have at least a name and an id
        guard let object = object, let professions = object["profession"] as? [String], professions.count > 0 else {
            return nil
        }
        
        var fetchedProfession: Profession?
        
        //TODO: Validate if name already exists
        if let profession = Profession.fetch(uniqueValue: name, forKey: "name") as? Profession {
            fetchedProfession = profession
        }
        
        let profession: Profession = fetchedProfession ?? CoreDataStack.shared.context.insertObject()
        
        return nil
    }
    
}
