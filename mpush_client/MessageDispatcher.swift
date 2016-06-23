//
//  MessageDispatcher.swift
//  mpush-client
//
//  Created by OHUN on 16/6/8.
//  Copyright © 2016年 OHUN. All rights reserved.
//

import Foundation

final class MessageDispatcher: PacketReceiver {
    let dispatchQueue = dispatch_queue_create("message_dispatch_queue", DISPATCH_QUEUE_CONCURRENT);
    var handlers = Dictionary<Int8, MessageHandler>();
    let logger = ClientConfig.I.logger;
    
    init() {
        register(Command.HEARTBEAT, handler: HeartbeatHandler());
        register(Command.FAST_CONNECT, handler: FastConnectOkHandler());
        register(Command.HANDSHAKE, handler: HandshakeOkHandler());
        register(Command.KICK, handler: KickUserHandler());
        register(Command.OK, handler: OkMessageHandler());
        register(Command.ERROR, handler: ErrorMessageHandler());
        register(Command.PUSH, handler: PushMessageHandler());
    }
    
    func register(command: Command, handler: MessageHandler) {
        handlers[command.rawValue] = handler;
    }
    
    func onReceive(packet: Packet, connection: Connection) {
        if let handler = handlers[packet.cmd] {
            dispatch_async(dispatchQueue, {
                
                    do {
                        try handler.handle(packet, connection: connection);
                    } catch _ {
                        self.logger.e({"handle message error, packet=\(packet)"});
                        connection.reconnect();
                    }
            });
        } else {
            logger.w({"<<< receive unsupported message, do reconnect, packet=\(packet)"});
            connection.reconnect();
        }
    }
}