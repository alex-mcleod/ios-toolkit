//
//  ModelRegistrationManager.swift
//  Spaces
//
//  Created by Alex McLeod on 3/07/2014.
//  Copyright (c) 2014 Alex McLeod. All rights reserved.
//

import Foundation

let GET_METHOD = "GET"

class ResourceRegistrationManager {
    /* 
        Registers ResourceDescriptor classes with RestKit objectManager. Unifies
        RestKit with our convenient ResourceDescriptr class (which marries resources with
        NSManagedObjects.
    */
    
    let objectManager:RKObjectManager
    
    init(objectManager:RKObjectManager) {
        self.objectManager = objectManager
    }
    
    func hasRegistered(managedObject:CoreDataRestKitResourceDescriptor) -> Bool{
        // TODO Finish this function!
        return false
    }
    
    func register(resource:CoreDataRestKitResourceDescriptor) {
        /* Register an RKManagedOBject with the shared object manager. */
        // TODO need to use model.entity.name, but that will cause crash 
        let entityMapping = RKEntityMapping(forEntityForName: resource.entityDescription.name, inManagedObjectStore: self.objectManager.managedObjectStore)
        // TODO Get mapping will cause problems.
        entityMapping.addAttributeMappingsFromDictionary(resource.getMapping())
        entityMapping.identificationAttributes = [resource.identificationAttribute]
        
        let responseDescriptor = RKResponseDescriptor(
            mapping: entityMapping,
            method: RKRequestMethodFromString(GET_METHOD),
            pathPattern: resource.pathPattern,
            keyPath: nil,
            statusCodes: RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful)
        )
        
        objectManager.addResponseDescriptor(responseDescriptor)
        
    }
}