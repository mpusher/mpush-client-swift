//
//  FastConnectOkHandler.swift
//  mpush_client
//
//  Created by ohun on 16/6/20.
//  Copyright © 2016年 mpusher. All rights reserved.
//

import Foundation

final class FastConnectOkHandler: BaseMessageHandler<FastConnectOkMessage> {
    
    override func decode(packet:Packet, connection:Connection) -> FastConnectOkMessage {
        return FastConnectOkMessage(packet: packet, conn: connection);
    }
    
    override func handle(message: FastConnectOkMessage) {
        ClientConfig.I.logger.w({">>> fast connect ok, message=\(message)"});
        
        let connection = message.getConnection();
        let context = connection.context;
        
        context.setHeartbeat(message.heartbeat);
                
        let listener =  ClientConfig.I.clientListener;
        listener.onHandshakeOk(connection.client, heartbeat: message.heartbeat);
        
    }
}