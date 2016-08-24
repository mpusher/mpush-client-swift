//
//  FastConnectMessage.swift
//  mpush_client
//
//  Created by ohun on 16/6/20.
//  Copyright © 2016年 mpusher. All rights reserved.
//

import Foundation

class FastConnectMessage: ByteBufMessage, CustomDebugStringConvertible {
    
    var sessionId:String!;
    var deviceId:String!;
    var minHeartbeat: Int32!;
    var maxHeartbeat: Int32!;
    
    init(connection: Connection) {
        super.init(packet: Packet(cmd: Command.FAST_CONNECT, sessionId: BaseMessage.genSessionId()), conn: connection);
    }
    
    override func encode(body:RFIWriter){
        body.writeString(sessionId)
        body.writeString(deviceId)
        body.writeInt32(minHeartbeat)
        body.writeInt32(maxHeartbeat)
    }
    
    var debugDescription: String {
        return "FastConnectMessage={sessionId:\(sessionId), deviceId=\(deviceId), minHeartbeat=\(minHeartbeat), maxHeartbeat=\(maxHeartbeat)}"
    }
}