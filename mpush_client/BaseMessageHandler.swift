//
//  BaseMessageHandler.swift
//  mpush_client
//
//  Created by ohun on 16/6/17.
//  Copyright © 2016年 mpusher. All rights reserved.
//

import Foundation

class BaseMessageHandler<T:BaseMessage>: MessageHandler {
    
    func decode(packet:Packet, connection:Connection) -> T {
        fatalError("implement me!");
    }
    
    func handle(message:T) {
        
    }
    
    func handle(packet:Packet, connection:Connection)  throws {
        let t = decode(packet, connection: connection);
        try t.decodeBody();
        handle(t);
    }
}