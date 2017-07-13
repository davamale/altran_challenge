//
//  ObjectHelper.swift
//  altran_challenge
//
//  Created by Dava on 7/9/17.
//
//

import Foundation

struct ObjectHelper {
    
    static var stubFetchedObjectsGreaterThanZero: [Int] {
        return [1,2,3,4,5,6,6,7,8]
    }
    
    static var stubFetchedObjectsEqualsToZero: [Int] {
        return []
    }
    
    static var stubFetchedObjectsNil: [Int]? {
        return nil
    }
    
    // MARK: - GnomeListViewModelTests
    
    /// JSON Gnome Mock object
    ///
    /// - Returns: JSON object
    static func gnomeJsonMock(name: String? = nil) -> JSON {
        
        let object = NSMutableDictionary()
        
        object.setValue(name ?? "David Martinez", forKey: "name")
        object.setValue(64, forKey: "age")
        object.setValue(12.98, forKey: "weight")
        object.setValue(6.87, forKey: "height")
        object.setValue("brown", forKey: "hair_color")
        object.setValue("http://something.com", forKey: "thumbnail")
        object.setValue(12, forKey: "id")
        
        return object
        
    }
    
    /// JSON Gnome Mock object without a name
    ///
    /// - Returns: JSON object
    static func noNameGnomeJsonMock() -> JSON {
        
        let object = NSMutableDictionary()
        
        object.setValue(64, forKey: "age")
        object.setValue(12.98, forKey: "weight")
        object.setValue(6.87, forKey: "height")
        object.setValue("brown", forKey: "hair_color")
        object.setValue("http://something.com", forKey: "thumbnail")
        object.setValue(12, forKey: "id")
        
        return object
        
    }
    
    /// JSON Gnome Mock object with only name
    ///
    /// - Returns: JSON object
    static func onlyNameGnomeJsonMock() -> JSON {
        
        let object = NSMutableDictionary()
        
        object.setValue("David Martinez", forKey: "name")
        
        return object
    }
    
    /// Returns a random number between 0 and array.count. Used to evaluate arrays in during testing.
    ///
    /// - Parameter array: objects
    /// - Returns: random generate number
    static func randomNumber<T>(in array: Array<T>) -> Int {
        return Int(arc4random_uniform(UInt32(array.count)))
    }
    
    // MARK: -
    
}







