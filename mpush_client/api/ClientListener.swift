//
//  ClientListener.swift
//  mpush_client
//
//  Created by ohun on 16/6/18.
//  Copyright © 2016年 mpusher. All rights reserved.
//

import Foundation

protocol ClientListener {
    
    func onConnected(client: Client);
    
    func onDisConnected(client: Client);
    
    func onHandshakeOk(client: Client, heartbeat: Int);
    
    func onReceivePush(client: Client, content: NSData);
    
    func onKickUser(deviceId: String, userId: String);
}