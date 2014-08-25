//
//  Collection.swift
//  Spaces
//
//  Created by Alex McLeod on 17/07/2014.
//  Copyright (c) 2014 Alex McLeod. All rights reserved.
//

import Foundation

class MeteorCollection {
    /* 
        Convenience class which allows views to subscribe to server side collections even 
        if MeteorClient has not finished connecting yet.
    */
    let client:MeteorClient!
    let name:String!
    
    var _collection:Array<AnyObject> {
        get{
            let name = self.name as NSString
            if (self.client.collections.objectForKey(name)) {
                return self.client.collections.objectForKey(name) as Array<AnyObject>
            } else {
                return []
            }
        }
    }
    
    var count:Int {
        get {
            return self._collection.count
        }
    }
    
    subscript(index: Int) -> Dictionary<String, String>{
        get {
            let entity = _collection[index] as Dictionary<String, String>
            return entity
        }
    }
    
    init (client: MeteorClient, name: String) {
        self.client = client
        self.name = name
        if (!self.client.collections.objectForKey(self.name as NSString)) {
            // Assumes that adding multiple subscriptions is not problematic!
            self.client.addSubscription(self.name)
        }
    }
    
    convenience init(name: String) {
        self.init(client: MeteorUtils.sharedClient(), name:name);
    }
    
    // Event handling
    
    func addObserverForEvent(observer: NSObject, event: String, selector: String) {
        NSNotificationCenter.defaultCenter().addObserver(observer, selector:Selector(selector), name:"\(self.name)_\(event)", object:nil)
    }
    
    func addObserverForAdditions(observer:NSObject, selector:String) {
        self.addObserverForEvent(observer, event: "added", selector:selector);
    }
    
    func addObserverForRemovals(observer:NSObject, selector:String) {
        self.addObserverForEvent(observer, event: "removed", selector:selector);
    }
    
    func addObserverForUpdates(observer:NSObject, selector:String) {
        self.addObserverForAdditions(observer, selector:selector)
        self.addObserverForRemovals(observer, selector:selector)
    }
    
    func removeObserver(observer: NSObject) {
        NSNotificationCenter.defaultCenter().removeObserver(observer);
    }
    
    //
}