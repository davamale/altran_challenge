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
extension Gnome: ManagedObjectType {
    
    public static var defaultSortDescriptors: [NSSortDescriptor] {
        return [NSSortDescriptor(key: "name", ascending: true)]
    }
}

//MARK: - ManagedObjectMethods
extension Gnome: ManagedObjectMethods {
    
    public typealias ModelObject = Gnome
    
    public static func save<Object>(object: Object?) -> Gnome? {
        
        // required to have at least a name
        guard let object = object as? NSDictionary, let name = object["name"] as? String, !name.isEmpty else {
            return nil
        }
        
        var fetchedGnome: Gnome?
        
        //TODO: Validate if name already exists
        if let gnome = Gnome.fetch(uniqueValue: name, forKey: "name") as? Gnome {
            fetchedGnome = gnome
        }
        
        let gnome: Gnome = fetchedGnome ?? CoreDataStack.shared.privateContext.insertObject()
        
        // only update if is different
        if gnome.name != name {
            gnome.name = name
        }
        
        if let id = object["id"] as? Int, gnome.id != Int64(id) {
            gnome.id = Int64(id)
        }
        
        // picture
        if let pictureUrl = object["thumbnail"] as? String, gnome.pictureUrl != pictureUrl {
            gnome.pictureUrl = pictureUrl
        }
        
        // height
        if let height = object["height"] as? Float, gnome.height != height {
            gnome.height = height
        }
        
        // weight
        if let weight = object["weight"] as? Float, gnome.weight != weight {
            gnome.weight = weight
        }
        
        // hair color
        if let hairColor = object["hair_color"] as? String, gnome.hairColor != hairColor {
            gnome.hairColor = hairColor
        }
        
        // age
        if let age = object["age"] as? Int, gnome.age != Int16(age) {
            gnome.age = Int16(age)
        }
        
        // relations
        if let friends = object["friends"] as? [String], friends.count > 0  {
            
            // set has friends as true
            gnome.hasFriends = true
            
            for friend in friends {
                
                // creates a new Gnome
                if let gnomeFriend = save(object: NSDictionary(object: friend, forKey: "name" as NSCopying)) {
                    gnome.addToFriends(gnomeFriend)
                }
            }
            
        }
        
        if let professions = object["professions"] as? [String], professions.count > 0 {
            
            // set profession count
            gnome.professionCount = Int16(professions.count)
            gnome.hasProfessions = true
            
            for profession in professions where !profession.isEmpty {
                
                if let professionObject = Profession.save(object: profession) {
                    gnome.addToProfessions(professionObject)
                    professionObject.addToGnomes(gnome)
                }
            }
            
        }
        
        gnome.hasFriends = gnome.friends != nil ? gnome.friends!.count > 0 : false
        gnome.hasProfessions = gnome.professions != nil ? gnome.professions!.count > 0 : false

        return gnome
    }
}










