//
//  ObjectHelper.swift
//  altran_challenge
//
//  Created by Dava on 7/9/17.
//
//

import Foundation

struct ObjectHelper {
    
    static func gnomeObjectMock() -> NSMutableDictionary {
        
        let object = NSMutableDictionary()
        
        object.setValue("David Martinez", forKey: "name")
        object.setValue(64, forKey: "age")
        object.setValue(12.98, forKey: "weight")
        object.setValue(6.87, forKey: "height")
        object.setValue("brown", forKey: "hair_color")
        object.setValue("http://something.com", forKey: "thumbnail")
        object.setValue(12, forKey: "id")
        
        return object
        
    }
    
    static func faultGnomeObjectMock() -> NSMutableDictionary {
        
        let object = NSMutableDictionary()
        
        object.setValue("", forKey: "name")
        object.setValue(64, forKey: "age")
        object.setValue(12.98, forKey: "weight")
        object.setValue(6.87, forKey: "height")
        object.setValue("brown", forKey: "hair_color")
        object.setValue("http://something.com", forKey: "thumbnail")
        object.setValue(12, forKey: "id")
        
        return object
        
    }
    
}
