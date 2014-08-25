//
//  Initialization.swift
//  Spaces
//
//  Created by Alex McLeod on 7/07/2014.
//  Copyright (c) 2014 Alex McLeod. All rights reserved.
//

import Foundation

func initRestKit(withApplicationName appName:String, andBaseURL baseURL:String) {
    /* 
        Convenience function for setting up the RestKit stack with CoreData integration.
    */
    let error:NSErrorPointer = nil
    
    // Set up logging.
    // Change environment variables using Product > Scheme > Edit Scheme
    RKLogConfigureFromEnvironment()
    
    // Path for object model, first argument is file name (default is Spaces.xcdatamodeld)
    let modelURL:NSURL = NSURL.fileURLWithPath(NSBundle.mainBundle().pathForResource(appName, ofType: "momd"))
    
    // NOTE: Due to an iOS 5 bug, the managed object model returned is immutable.
    let managedObjectModel:NSManagedObjectModel = NSManagedObjectModel(contentsOfURL: modelURL).mutableCopy() as NSManagedObjectModel
    let managedObjectStore:RKManagedObjectStore = RKManagedObjectStore(managedObjectModel: managedObjectModel)
    
    
    // Initialize the Core Data stack
    managedObjectStore.createPersistentStoreCoordinator()
    
    let storePath = RKApplicationDataDirectory().stringByAppendingPathComponent("\(appName).sqlite")
    
    let persistentStore:NSPersistentStore! = managedObjectStore.addSQLitePersistentStoreAtPath(
        storePath,
        fromSeedDatabaseAtPath: nil,
        withConfiguration: nil,
        options: [
            NSMigratePersistentStoresAutomaticallyOption: true,
            NSInferMappingModelAutomaticallyOption: true
        ],
        error: error
    )
    assert(persistentStore, "Failed to add persistent store: /(error)")
    
    managedObjectStore.createManagedObjectContexts()
    
    // Configure managed onbject cache to ensure we do not create duplicate objects
    managedObjectStore.managedObjectCache = RKInMemoryManagedObjectCache(managedObjectContext: managedObjectStore.mainQueueManagedObjectContext)
    
    // Set the default store shared instance
    RKManagedObjectStore.setDefaultStore(managedObjectStore)
    
    // Setup the object manager. This can be used to register mappings for objects, and then to
    // make calls to retrieve data for those mappings.
    let objectManager:RKObjectManager = RKObjectManager(baseURL: NSURL.URLWithString(baseURL))
    
    objectManager.managedObjectStore = managedObjectStore;
    
    RKObjectManager.setSharedManager(objectManager);
}
