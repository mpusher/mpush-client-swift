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
        super.init(packet: Packet(cmd: Command.fast_CONNECT, sessionId: BaseMessage.genSessionId()), conn: connection);
    }
    
    override func encode(_ body:RFIWriter){
        body.write(sessionId)
        body.write(deviceId)
        body.write(minHeartbeat)
        body.write(maxHeartbeat)
    }
    
    var debugDescription: String {
        return "FastConnectMessage={sessionId:\(sessionId), deviceId=\(deviceId), minHeartbeat=\(minHeartbeat), maxHeartbeat=\(maxHeartbeat)}"
    }
}
