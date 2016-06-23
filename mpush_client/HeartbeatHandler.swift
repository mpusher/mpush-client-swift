//
//  HeartbeatHandler.swift
//  mpush_client
//
//  Created by ohun on 16/6/17.
//  Copyright © 2016年 mpusher. All rights reserved.
//

import Foundation

class HeartbeatHandler: MessageHandler {
    
    func handle(packet:Packet, connection:Connection) {
        ClientConfig.I.logger.d(">>> receive heartbeat pong...")
        //connection.reconnect();
    }
}