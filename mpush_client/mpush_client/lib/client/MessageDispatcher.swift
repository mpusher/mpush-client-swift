//
//  MessageDispatcher.swift
//  mpush-client
//
//  Created by OHUN on 16/6/8.
//  Copyright © 2016年 OHUN. All rights reserved.
//

import Foundation

final class MessageDispatcher: PacketReceiver {
    let dispatchQueue = DispatchQueue(label: "message_dispatch_queue", attributes: DispatchQueue.Attributes.concurrent);
    var handlers = Dictionary<Int8, MessageHandler>();
    let logger = ClientConfig.I.logger;
    
    init() {
        register(Command.heartbeat, handler: HeartbeatHandler());
        register(Command.fast_CONNECT, handler: FastConnectOkHandler());
        register(Command.handshake, handler: HandshakeOkHandler());
        register(Command.kick, handler: KickUserHandler());
        register(Command.ok, handler: OkMessageHandler());
        register(Command.error, handler: ErrorMessageHandler());
        register(Command.push, handler: PushMessageHandler());
    }
    
    func register(_ command: Command, handler: MessageHandler) {
        handlers[command.rawValue] = handler;
    }
    
    func onReceive(_ packet: Packet, connection: Connection) {
        if let handler = handlers[packet.cmd] {
            dispatchQueue.async(execute: {
                
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
