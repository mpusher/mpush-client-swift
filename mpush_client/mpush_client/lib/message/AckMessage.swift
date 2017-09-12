//
//  AckMessage.swift
//  mpush_client
//
//  Created by ohun on 16/9/7.
//  Copyright © 2016年 mpusher. All rights reserved.
//

import Foundation

final class AckMessage: ByteBufMessage, CustomDebugStringConvertible {
    
    init(sessionId: Int32, conn: Connection) {
        super.init(packet: Packet(cmd: Command.ack,sessionId: sessionId), conn: conn)
    }
    
    var debugDescription: String {
        return "AckMessage={sessionId:\(packet.sessionId)}"
    }
}
