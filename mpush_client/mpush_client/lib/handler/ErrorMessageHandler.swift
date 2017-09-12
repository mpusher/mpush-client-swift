//
//  ErrorMessageHandler.swift
//  mpush_client
//
//  Created by ohun on 16/6/20.
//  Copyright © 2016年 mpusher. All rights reserved.
//

import Foundation

final class ErrorMessageHandler: BaseMessageHandler<ErrorMessage> {
    
    override func decode(_ packet:Packet, connection:Connection) -> ErrorMessage {
        return ErrorMessage(packet: packet, conn: connection);
    }
    
    override func handle(_ message: ErrorMessage) {
        ClientConfig.I.logger.w({">>> receive an error message=\(message)"});
        if (message.cmd == Command.fast_CONNECT.rawValue) {
            //ClientConfig.I.getSessionStorage().clearSession();
            message.getConnection().client.handshake();
        } else if (message.cmd == Command.handshake.rawValue) {
            message.getConnection().client.stop();
        } else {
            message.getConnection().reconnect();
        }
    }
}
