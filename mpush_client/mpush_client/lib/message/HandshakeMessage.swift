//
//  HandshakeMessage.swift
//  mpush-client
//
//  Created by OHUN on 16/6/8.
//  Copyright © 2016年 OHUN. All rights reserved.
//

import Foundation

final class HandshakeMessage: ByteBufMessage, CustomDebugStringConvertible{
    var deviceId: String!;
    var osName: String!;
    var osVersion: String!;
    var clientVersion: String!;
    var iv: Data!;
    var clientKey: Data!;
    var minHeartbeat: Int32!;
    var maxHeartbeat: Int32!;
    var timestamp: Int64 = 0;
    
    init(connection: Connection) {
        super.init(packet: Packet(cmd: Command.handshake, sessionId: BaseMessage.genSessionId()), conn: connection);
    }
    
    override func encode(_ body:RFIWriter){
        body.write(deviceId)
        body.write(osName)
        body.write(osVersion)
        body.write(clientVersion)
        body.writeData(iv)
        body.writeData(clientKey)
        body.write(minHeartbeat)
        body.write(maxHeartbeat)
        body.write(timestamp)
    }
    
    var debugDescription: String {
        return "HandshakeMessage=deviceId=\(deviceId), clientKey:\(clientKey),  minHeartbeat=\(minHeartbeat), maxHeartbeat=\(maxHeartbeat)"
    }
}
