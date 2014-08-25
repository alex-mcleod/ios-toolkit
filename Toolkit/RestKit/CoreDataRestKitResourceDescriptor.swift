//
//  Resource.swift
//  Spaces
//
//  Created by Alex McLeod on 6/07/2014.
//  Copyright (c) 2014 Alex McLeod. All rights reserved.
//

import Foundation

let DEFAULT_IDENTIFICATION_ATTRIBUTE = "id"

class CoreDataRestKitResourceDescriptor {
    /* 
        Defines a server side resource and links it with a local core data entity.
        Override this for individual models/resources and define self.entityName in 
        init which matches a local core data entity! Then, just need to make sure resource
        descriptors are registerd with RestKit using ResourceRegistrationManager.
    */
    
    let managedObjectContext: NSManagedObjectContext
    let sharedManager:RKObjectManager
    let identificationAttribute:String = DEFAULT_IDENTIFICATION_ATTRIBUTE
    let defaultSortDescriptor:NSSortDescriptor = NSSortDescriptor(key: DEFAULT_IDENTIFICATION_ATTRIBUTE, ascending: false)
    
    var pathPattern:String! {
        return "/\(self.entityName.lowercaseString)"
    }
    
    var entityName:String! = nil

    var _entityDescription:NSEntityDescription! = nil
    var entityDescription:NSEntityDescription {
        if (self._entityDescription) {
            return self._entityDescription
        }
        let entityDescription = NSEntityDescription.entityForName(self.entityName, inManagedObjectContext: self.managedObjectContext)
        self._entityDescription = entityDescription
        return self._entityDescription
    }

    init() {
        self.sharedManager = RKObjectManager.sharedManager()
        self.managedObjectContext = self.sharedManager.managedObjectStore.mainQueueManagedObjectContext
    }
    
    func getMapping() -> NSDictionary {
        /* By default, mapping just uses attributes of CoreData entity */
        var mapping:Dictionary<String, String> = Dictionary()
        let attributes = self.entityDescription.attributesByName
        for (key : AnyObject) in attributes.allKeys {
            let attribute = key as String
            mapping[attribute] = attribute
        }
        return mapping.bridgeToObjectiveC()
    }
    
}