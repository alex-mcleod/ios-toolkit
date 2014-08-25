//
//  Manager.swift
//  Spaces
//
//  Created by Alex McLeod on 3/07/2014.
//  Copyright (c) 2014 Alex McLeod. All rights reserved.
//

import Foundation

let DEFAULT_BATCH_SIZE = 20

class FetchManager {
    /* 
        Convenience class for performing fetch via restkit and using NSFetchedResultsController
        to handle the results. 
    */
    var managedObjectContext: NSManagedObjectContext
    var sharedManager:RKObjectManager
    var delegate:NSFetchedResultsControllerDelegate
    var resource:CoreDataRestKitResourceDescriptor
    
    init(resourceDescriptor: CoreDataRestKitResourceDescriptor, withDelegate delegate:NSFetchedResultsControllerDelegate) {
        self.sharedManager = RKObjectManager.sharedManager()
        self.managedObjectContext = self.sharedManager.managedObjectStore.mainQueueManagedObjectContext
        self.resource = resourceDescriptor
        self.delegate = delegate
    }
    
    
    func _performRestKitFetch(
        // Optional succcess and failure callbacks
        success: ((RKObjectRequestOperation!, RKMappingResult!)->Void)!,
        failure: ((RKObjectRequestOperation!, NSError!)->Void)!
    ) {
        RKObjectManager.sharedManager().getObjectsAtPath(
            self.resource.pathPattern,
            parameters:nil,
            success:success,
            failure:failure
        )
    }
    
    func fetch(
        // Optional succcess and failure callbacks
        success: ((RKObjectRequestOperation!, RKMappingResult!)->Void)!,
        failure: ((RKObjectRequestOperation!, NSError!)->Void)!
    ) {
        self._performRestKitFetch(success, failure:failure)
    }
    
    var _results: NSFetchedResultsController? = nil
    var results: NSFetchedResultsController {
        if _results != nil {
            return _results!
        }
        
        let fetchRequest = NSFetchRequest()
        // Edit the entity name as appropriate.
        let entity = NSEntityDescription.entityForName(self.resource.entityDescription.name, inManagedObjectContext: self.managedObjectContext)
        
        fetchRequest.entity = entity
        
        // Set the batch size to a suitable number.
        fetchRequest.fetchBatchSize = DEFAULT_BATCH_SIZE
        
        // Edit the sort key as appropriate.
        // TODO Access to sortDescriptor causes problems.
        let sortDescriptor = self.resource.defaultSortDescriptor
        let sortDescriptors = [sortDescriptor]
        fetchRequest.sortDescriptors = [sortDescriptor]
            
        // Edit the section name key path and cache name if appropriate.
        // nil for section name key path means "no sections".
        let aFetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: self.managedObjectContext, sectionNameKeyPath: nil, cacheName: "Master")
        aFetchedResultsController.delegate = self.delegate
        _results = aFetchedResultsController
        
        var error: NSError? = nil
        
        if !_results!.performFetch(&error) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            //println("Unresolved error \(error), \(error.userInfo)")
            abort()
        }
            
        return _results!
    }

}