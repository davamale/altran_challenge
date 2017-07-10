//
//  Gnome+Methods.swift
//  altran_challenge
//
//  Created by Dava on 7/9/17.
//
//

import Foundation
import CoreData

//MARK: - ManagedObjectType
extension Gnome: ManagedObjectType {}

//MARK: - ManagedObjectMethods
extension Gnome: ManagedObjectMethods {
    
    public typealias ModelObject = Gnome
    
    public static func save(object: NSDictionary?) -> Gnome? {
        
        // required to have at least a name and an id
        guard let object = object, let name = object["name"] as? String, !name.isEmpty else {
            return nil
        }
        
        var fetchedGnome: Gnome?
        
        //TODO: Validate if name already exists
        if let gnome = Gnome.fetch(uniqueValue: name, forKey: "name") as? Gnome {
            fetchedGnome = gnome
        }
        
        let gnome: Gnome = fetchedGnome ?? CoreDataStack.shared.context.insertObject()
        
        gnome.name = name
        
        if let id = object["id"] as? Int {
            gnome.id = Int64(id)
        }
        
        // picture
        if let pictureUrl = object["thumbnail"] as? String {
            gnome.pictureUrl = pictureUrl
        }
        
        // height
        if let height = object["height"] as? Float {
            gnome.height = height
        }
        
        // weight
        if let weight = object["weight"] as? Float {
            gnome.weight = weight
        }
        
        // hair color
        if let hairColor = object["hair_color"] as? String {
            gnome.hairColor = hairColor
        }
        
        // age
        if let age = object["age"] as? Int {
            gnome.age = Int16(age)
        }
        
        // relations
        if let friends = object["friends"] as? [String] {
            
            // set has friends as rue
            gnome.hasFriends = true
            
            for friend in friends {
                
                // creates a new Gnome
                if let gnomeFriend = save(object: NSDictionary(object: friend, forKey: "name" as NSCopying)) {
                    gnomeFriend.addToFriends(gnome)
                    gnome.addToFriends(gnomeFriend)
                }
                
            }
        }
        
        if let profession = object["professions"] as? [String] {
            
        }

        return gnome
    }
    
}
