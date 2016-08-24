//
//  KickUserHandler.swift
//  mpush_client
//
//  Created by ohun on 16/6/20.
//  Copyright © 2016年 mpusher. All rights reserved.
//

import Foundation

final class KickUserHandler: BaseMessageHandler<KickUserMessage> {
    
    override func decode(packet:Packet, connection:Connection) -> KickUserMessage {
        return KickUserMessage(packet: packet, conn: connection);
    }
    
    override func handle(message: KickUserMessage) {
        ClientConfig.I.logger.w({">>> receive kickUser message=\(message)"});
        let listener = ClientConfig.I.clientListener;
        listener.onKickUser(message.deviceId, userId: message.userId);
    }
}