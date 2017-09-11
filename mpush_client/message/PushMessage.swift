//
//  PushMessage.swift
//  mpush_client
//
//  Created by ohun on 16/6/20.
//  Copyright © 2016年 mpusher. All rights reserved.
//

import Foundation

final class PushMessage: BaseMessage, CustomDebugStringConvertible {
    var content:Data!;
    
    override func decode(_ body:Data) {
        content = body;
    }
    
    
    func autoAck() -> Bool {
        return packet.hasFlag(Packet.FLAG_AUTO_ACK);
    }
    
    func bizAck() -> Bool {
        return packet.hasFlag(Packet.FLAG_BIZ_ACK);
    }
    
    var debugDescription: String {
        return "PushMessage={content:\(content.count)}"
    }
}
