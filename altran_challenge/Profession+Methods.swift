//
//  Profession+Methods.swift
//  altran_challenge
//
//  Created by Dava on 7/9/17.
//
//

import Foundation

//MARK: - ManagedObjectType
extension Profession: ManagedObjectType {/* Adopting the procotol provides default implementation */}

//MARK: - ManagedObjectMethods
extension Profession: ManagedObjectMethods {
    
    public typealias ModelObject = Profession
    
    /// Adds a profession string into MOC
    ///
    /// - Parameter object: (generic) string
    /// - Returns: Profession
    public static func save<Object>(object: Object?) -> Profession? {
        
        // cast generic as [String]
        guard let professionName = object as? String, !professionName.isEmpty else {
            return nil
        }
        
        var fetchedProfession: Profession?

        if let profession = Profession.fetch(uniqueValue: professionName, forKey: "name") as? Profession {
            fetchedProfession = profession
        }
        
        let profession: Profession = fetchedProfession ?? CoreDataStack.shared.privateContext.insertObject()
        
        profession.id = Generator.newId
        profession.name = professionName
        
        return profession
    }
    
}
