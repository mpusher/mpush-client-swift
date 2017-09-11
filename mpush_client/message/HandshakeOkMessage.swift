//
//  HandshakeOkMessage.swift
//  mpush-client
//
//  Created by OHUN on 16/6/8.
//  Copyright © 2016年 OHUN. All rights reserved.
//

import Foundation


class HandshakeOkMessage: ByteBufMessage, CustomDebugStringConvertible {
    
    var serverKey:Data!;
    var heartbeat:Int!;
    var sessionId:String!;
    var expireTime:Int64!;
    
    override func decode(_ body:RFIReader) {
        serverKey = body.readData();
        heartbeat = Int(body.readInt32());
        sessionId = body.readString()!;
        expireTime = body.readInt64();
    }
    
    var debugDescription: String {
        return "HandshakeOkMessage={serverKey:\(serverKey), heartbeat=\(heartbeat), sessionId=\(sessionId), expireTime=\(expireTime)}"
    }

}
