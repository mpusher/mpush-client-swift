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
    var iv: NSData!;
    var clientKey: NSData!;
    var minHeartbeat: Int32!;
    var maxHeartbeat: Int32!;
    var timestamp: Int64 = 0;
    
    init(connection: Connection) {
        super.init(packet: Packet(cmd: Command.HANDSHAKE, sessionId: BaseMessage.genSessionId()), conn: connection);
    }
    
    override func encode(body:RFIWriter){
        body.writeString(deviceId)
        body.writeString(osName)
        body.writeString(osVersion)
        body.writeString(clientVersion)
        body.writeData(iv)
        body.writeData(clientKey)
        body.writeInt32(minHeartbeat)
        body.writeInt32(maxHeartbeat)
        body.writeInt64(timestamp)
    }
    
    var debugDescription: String {
        return "HandshakeMessage=deviceId=\(deviceId), clientKey:\(clientKey),  minHeartbeat=\(minHeartbeat), maxHeartbeat=\(maxHeartbeat)"
    }
}