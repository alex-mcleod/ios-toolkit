//
//  MeteorInit.swift
//  Spaces
//
//  Created by Alex McLeod on 11/07/2014.
//  Copyright (c) 2014 Alex McLeod. All rights reserved.
//

import Foundation

func initMeteor(url:String) -> MeteorClient {
    let meteorClient = MeteorClient(DDPVersion: "pre2")
    let ddp = ObjectiveDDP(URLString: url, delegate:meteorClient)
    
    meteorClient.ddp = ddp
    meteorClient.ddp.connectWebSocket()
    
    return meteorClient
}