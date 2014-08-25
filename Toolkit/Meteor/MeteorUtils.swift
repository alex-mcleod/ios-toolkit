//
//  MeteorUtils.swift
//  Spaces
//
//  Created by Alex McLeod on 11/07/2014.
//  Copyright (c) 2014 Alex McLeod. All rights reserved.
//

import Foundation

class MeteorUtils {
    class func sharedClient() -> MeteorClient {
        let appDelegate = UIApplication.sharedApplication().delegate as AppDelegate
        return appDelegate.meteor!
    }
}