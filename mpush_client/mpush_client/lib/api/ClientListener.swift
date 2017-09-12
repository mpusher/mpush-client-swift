//
//  ClientListener.swift
//  mpush_client
//
//  Created by ohun on 16/6/18.
//  Copyright © 2016年 mpusher. All rights reserved.
//

import Foundation

protocol ClientListener {
    
    func onConnected(_ client: Client);
    
    func onDisConnected(_ client: Client);
    
    func onHandshakeOk(_ client: Client, heartbeat: Int);
    
    func onReceivePush(_ client: Client, content: Data, messageId: Int32);
    
    func onKickUser(_ deviceId: String, userId: String);
}
