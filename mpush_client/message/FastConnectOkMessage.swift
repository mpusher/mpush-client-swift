//
//  FastConnectOkMessage.swift
//  mpush_client
//
//  Created by ohun on 16/6/20.
//  Copyright © 2016年 mpusher. All rights reserved.
//

import Foundation

class FastConnectOkMessage:ByteBufMessage, CustomDebugStringConvertible {
    var heartbeat:Int!;
    
    override func decode(body:RFIReader) {
        heartbeat = Int(body.readInt32());
    }
    
    var debugDescription: String {
        return "FastConnectOkMessage={heartbeat:\(heartbeat)}"
    }
}