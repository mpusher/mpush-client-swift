//
//  OkMessageHandler.swift
//  mpush_client
//
//  Created by ohun on 16/6/20.
//  Copyright © 2016年 mpusher. All rights reserved.
//

import Foundation

final class OkMessageHandler: BaseMessageHandler<OkMessage> {
    
    override func decode(packet:Packet, connection:Connection) -> OkMessage {
        return OkMessage(packet: packet, conn: connection);
    }
    
    override func handle(message: OkMessage) {
        ClientConfig.I.logger.w({">>> receive ok message=\(message)"});
    }
}